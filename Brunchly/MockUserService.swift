//
//  MockUserService.swift
//  Brunchly
//
//  Created by Jeffery Calhoun on 6/7/17.
//  Copyright © 2017 YoTechnica. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import SwiftyJSON

class MockUserService{
    
    private static var _testUsers: [TestUser]?
    private static var _testUserImages: [UIImage]?
    private static var _lastSearchedGender: TestGender?
    
    static let shared = MockUserService()
    
    private init(){}
    
    func loadUsers(count: Int, gender: TestGender?, withCompletion: @escaping (_ testUsers: [TestUser]?, _ testImages: [UIImage]?) -> Void){
        
        
        if let mTestUsers = MockUserService._testUsers, let mImages = MockUserService._testUserImages, let lastGender = MockUserService._lastSearchedGender, let thisGender = gender, thisGender == lastGender{
            //if the number of test users the user requested has already been loaded, return those
            if count == mTestUsers.count{
                withCompletion(mTestUsers, mImages)
            }
            //if the caller requests less test users than have been loaded, return the specified number of users from the loaded set
            else if count < mTestUsers.count{
                let users = mTestUsers.prefix(count)
                let images = mImages.prefix(count)
                let usrs: [TestUser] = Array(users)
                let imgs: [UIImage] = Array(images)
                withCompletion(usrs, imgs)
            }
            else{
                loadNewUsers(count: count, gender: gender, withCompletion: withCompletion)
            }
        }
        else{
            loadNewUsers(count: count, gender: gender, withCompletion: withCompletion)
        }
        
    }
    
    private func loadNewUsers(count: Int, gender: TestGender?, withCompletion: @escaping (_ testUsers: [TestUser]?, _ testImages: [UIImage]?) -> Void){
        
        let numUsersToLoad = count
        var loadsComplete = 0
        
        var genderConstraint: String = ""
        
        if let gender = gender{
            genderConstraint = "&gender=\(gender.rawValue)"
        }
        
        var testUsers = [TestUser]()
        var images = [UIImage]()
        
        
        
        Alamofire.request("https://randomuser.me/api/?results=\(count)\(genderConstraint)&nat=us&inc=name,location,dob,picture").responseJSON { (response) in
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                let jsonArr = json["results"].array!
                for result in jsonArr{
                    
                    var newUser = TestUser()
                    
                    newUser.name = result["name"]["first"].string!.capitalized
                    
                    newUser.photoURL = result["picture"]["large"].string!
                    
                    let birthDate =  Date.fromFormattedString(dateString: result["dob"].string!)!
                    let birthYear = Calendar.current.component(.year, from: birthDate)
                    newUser.age = 2017 - birthYear
                    
                    newUser.address = result["location"]["city"].string!.capitalized
                    
                    testUsers.append(newUser)
                    
                    Alamofire.request(newUser.photoURL).responseImage(completionHandler: { (response) in
                        
                        loadsComplete += 1
                        print("finished load \(loadsComplete)")
                        
                        if let image = response.result.value{
                            images.append(image)
                        }
                        
                        if loadsComplete == numUsersToLoad{
                            
                            print("all done loading images!")
                            
                            MockUserService._testUsers = testUsers
                            MockUserService._testUserImages = images
                            MockUserService._lastSearchedGender = gender
                            withCompletion(testUsers, images)
                        }
                        
                    })
                    
                }
                
                
                
            case.failure(let error):
                MockUserService._testUserImages = nil
                MockUserService._testUsers = nil
                MockUserService._lastSearchedGender = nil
                withCompletion(nil, nil)
                
            }
        }
        
    }
}

enum TestGender: String{
    case male = "male"
    case female = "female"
}

struct TestUser{
    var name: String
    var age: Int
    var address: String
    var photoURL: String
    
    init() {
        name = "John Doe"
        age = 0
        address = "123 Main St"
        photoURL = ""
    }
}

