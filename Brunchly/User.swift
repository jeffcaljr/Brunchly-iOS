//
//  User.swift
//  Brunchly
//
//  Created by Jeffery Calhoun on 6/4/17.
//  Copyright © 2017 YoTechnica. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

enum Gender : String{
    case male = "male"
    case female = "female"
    case unspecified = "unspecified"
}


struct User{
    
    var id: String?
    var isProfileComplete: Bool? = false
    var joinDate: Date?
    var photoURLString: String?
    var name: String?
    var brunches: [String]?
    var friends: [String]?
    var gender: Gender?
    var sexPreference: Gender?
    //TODO: Ficure out how to store location
    
    static func fromJSONDictionary(json: [String: Any]) -> User?{
        let id = json[UserKeys._idKey] as? String
        let isProfileComplete = json[UserKeys._isProfileCompleteKey] as? Bool
        let joinDate = Date.fromFormattedString(dateString: (json[UserKeys._joinDateKey] as? String)!)
        let photoURLString = json[UserKeys._photoURLStringKey] as? String
        let name = json[UserKeys._nameKey] as? String
        let brunches = json[UserKeys._brunchesKey] as? [String]
        let friends = json[UserKeys._friendsKey] as? [String]
        let gender = json[UserKeys._genderKey] as? Gender
        let sexPreference = json[UserKeys._sexPreferenceKey] as? Gender
        let user = User(id: id, isProfileComplete: isProfileComplete, joinDate: joinDate, photoURLString: photoURLString, name: name, brunches: brunches, friends: friends, gender: gender, sexPreference: sexPreference)
        return user
        
    }
    
    func toDictionary() -> [String: Any]{
        var json = [String: Any]()
        
        json[UserKeys._idKey] = id ?? ""
        json[UserKeys._isProfileCompleteKey] = isProfileComplete ?? false
        json[UserKeys._joinDateKey] = joinDate?.getFormattedDate() ?? ""
        json[UserKeys._photoURLStringKey] = photoURLString ?? ""
        json[UserKeys._nameKey] = name ?? ""
        json[UserKeys._brunchesKey] = brunches ?? [String]()
        json[UserKeys._friendsKey] = friends ?? [String]()
        json[UserKeys._genderKey] = gender ?? "unspecified"
        json[UserKeys._sexPreferenceKey] = sexPreference ?? "unspecified"
        
        return json
    }
    
    
    static func firCreateUser(user: FIRUser, callback: @escaping (_ error: Error?, _ reference: FIRDatabaseReference) -> Void){
        
        //get the user's photo URL (facebook pic lin if auth with Facebook, generic user image link otherwise)
        
        let photoURL = User.getFacebookProfilePhotoUrlString(user: user)
        
        print("photoURL: \(photoURL)")
        
        let usersRef = FIRDatabase.database().reference().child("users").child(user.uid)
        let thisUser = User(id: user.uid, isProfileComplete: false, joinDate: Date(), photoURLString: photoURL, name: user.displayName ?? nil, brunches: nil, friends: nil, gender: nil, sexPreference: nil)
        
        //TODO: Consider adding completion listener to setValue call, so that application can respond to errors
        usersRef.setValue(thisUser.toDictionary(), withCompletionBlock: callback)
    }
    
    
    static func firReadUser(userID: String, callback: @escaping (_ user: User?) -> Void){
        let userRef = FIRDatabase.database().reference().child("users").child(userID)
        
        userRef.observeSingleEvent(of: .value, with: {
            (snapshot) in
            print("firReadUser snapshot: \(snapshot)")
            
            if let result = snapshot.value as? [String: Any]{
                callback(User.fromJSONDictionary(json: result))
            }
            else{
                callback(nil)
            }
        })
        
    }
    
    static func firUpdateUser(user: User, callback: @escaping (_ error: Error?, _ reference: FIRDatabaseReference) -> Void){
        if let id = user.id{
            let userRef = FIRDatabase.database().reference().child("users").child(id)
            
            //TODO: Consider adding completion listener to setValue call, so that application can respond to errors
            userRef.setValue(user.toDictionary(), withCompletionBlock: callback)
        }
        
    }
    
    static func firDeleteUser(userID: String, callback: @escaping (_ error: Error?, _ reference: FIRDatabaseReference) -> Void){
        let userRef = FIRDatabase.database().reference().child("users").child(userID)
        
        //TODO: Consider adding completion listener to setValue call, so that application can respond to errors
        userRef.removeValue(completionBlock: callback)
    }
    
    private static func getFacebookProfilePhotoUrlString(user: FIRUser, width: Int = 200, height: Int = 200) -> String?{
        var providerID: String
        
        for provider in user.providerData{
            if provider.providerID == "facebook.com"{
                providerID = provider.uid
                return "https://graph.facebook.com/\(providerID)/picture?type=square&width=\(width)&height=\(height)"
            }
            break
        }
        
        return FIRStorage.storage().reference().child("profile_photos").child("generic_user.png").fullPath
//        "https://firebasestorage.googleapis.com/v0/b/brunchly-ad173.appspot.com/o/profile_photos%2Fgeneric_user.png?alt=media&token=646fcb90-cc0d-41ef-99e9-95772afe7a95"
    }
}


struct UserKeys{
    static var _idKey = "id"
    static var _isProfileCompleteKey = "profileComplete"
    static var _joinDateKey = "joinDate"
    static var _photoURLStringKey = "profilePicUrl"
    static var _nameKey = "name"
    static var _brunchesKey = "brunches"
    static var _friendsKey = "friends"
    static var _genderKey = "gender"
    static var _sexPreferenceKey = "sexPreference"
}
