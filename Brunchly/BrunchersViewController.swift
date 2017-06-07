//
//  BrunchersViewController.swift
//  Brunchly
//
//  Created by Jeffery Calhoun on 6/6/17.
//  Copyright © 2017 YoTechnica. All rights reserved.
//

import UIKit
import Koloda
import Toaster
import Alamofire
import AlamofireImage
import SwiftyJSON

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

class BrunchersViewController: UIViewController, KolodaViewDataSource, KolodaViewDelegate {
    
    //TODO: Test code, delete later
    var users: [TestUser]!
    var images: [UIImage]!
    
    @IBOutlet weak var toolbar: DarkToolbar!
    @IBOutlet weak var kolodaView: KolodaView!
    @IBOutlet weak var backgroundImage: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        toolbar.setViewController(viewController: self)
        
        backgroundImage.addBlurEffect()
        
        
        
        //TODO: Uncomment the following 2 lines later
//        kolodaView.dataSource = self
//        kolodaView.delegate = self
        
        
        //TODO: Test Code, delete later
        users = [TestUser]()
        images = [UIImage]()
        let numUsersToLoad = 25
        var loadsComplete = 0
        var tempImageView = UIImageView()

        tempImageView.frame.size = CGSize(width: 500, height: 500)
        
        
        Alamofire.request("https://randomuser.me/api/?results=\(numUsersToLoad)&gender=female&nat=us&inc=name,location,dob,picture").responseJSON { (response) in
            switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    let jsonArr = json["results"].array!
                    for result in jsonArr{
                        
                        var newUser = TestUser()
                        
                        newUser.name = result["name"]["first"].string!
                        
                        newUser.photoURL = result["picture"]["large"].string!
                        
                        let birthDate =  Date.fromFormattedString(dateString: result["dob"].string!)!
                        let birthYear = Calendar.current.component(.year, from: birthDate)
                        newUser.age = 2017 - birthYear
                        
                        newUser.address = result["location"]["city"].string!
                        
                        self.users.append(newUser)
                        print(newUser)
                        
                        Alamofire.request(newUser.photoURL).responseImage(completionHandler: { (response) in
                            
                            loadsComplete += 1
                            print("finished load \(loadsComplete)")
                            
                            if let image = response.result.value{
                                self.images.append(image)
                            }
                            
                            if loadsComplete == numUsersToLoad{
                                
                                print("all done loading images!")
                                
                                self.kolodaView.dataSource = self
                                self.kolodaView.delegate = self
                                self.kolodaView.reloadData()
                            }
                            
                        })

                    }
                    
                
                
                case.failure(let error):
                    Toast(text: "error loading sample users", delay: 0, duration: Delay.long).show()
                
            }
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: KolodaViewDataSource
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int{
        return users.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed{
        
        return DragSpeed.moderate
        
    }
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView{
        
        let cardView = CardView()
        cardView.frame.size = CGSize(width: kolodaView.frame.width, height: kolodaView.frame.height)
        cardView.backgroundColor = UIColor.flatMint()
        cardView.layer.borderWidth = 4
        cardView.layer.borderColor = UIColor.white.cgColor
        cardView.layer.cornerRadius = 4
        cardView.clipsToBounds = true
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.frame.size = CGSize(width: cardView.frame.width, height: cardView.frame.width - 8)
        imageView.backgroundColor = UIColor.black
        imageView.layer.cornerRadius = 2
        imageView.clipsToBounds = true
        
        cardView.addSubview(imageView)
        
        imageView.image = images[index]
        
        return cardView
    }
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView?{
//        return Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil) as? OverlayView
        return nil
    }
    
    //MARK: KolodaViewDelegate
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        Toast(text: "out of cards", delay: 0, duration: Delay.long).show()
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        Toast(text: "selected card!", delay: 0, duration: Delay.short).show()
    }

}
