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
        
        MockUserService.shared.loadUsers(count: 25, gender: TestGender.female, withCompletion: {(users, images) in
            
            if let users = users, let images = images{
                
                for user in users{
                    self.users.append(user)
                }
                
                for image in images{
                    self.images.append(image)
                }
                
                self.kolodaView.dataSource = self
                self.kolodaView.delegate = self
                self.kolodaView.reloadData()
            }
            else{
                Toast(text: "error loading sample users", delay: 0, duration: Delay.long).show()
            }

        })





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
        
        imageView.image = images[index]
        
        
        let overlay = CustomOverlayView()
        overlay.configureView(user: users[index])
        overlay.backgroundColor = UIColor.flatLime()
        
        
        cardView.addSubview(imageView)
        cardView.addSubview(overlay)
        
        overlay.translatesAutoresizingMaskIntoConstraints = false
        
        
        cardView.addConstraint(NSLayoutConstraint(item: overlay, attribute: .leading, relatedBy: .equal, toItem: cardView, attribute: .leading, multiplier: 1, constant: 0))
        cardView.addConstraint(NSLayoutConstraint(item: overlay, attribute: .trailing, relatedBy: .equal, toItem: cardView, attribute: .trailing, multiplier: 1, constant: 0))

    
        cardView.addConstraint(NSLayoutConstraint(item: overlay, attribute: .top, relatedBy: .equal, toItem: cardView, attribute: .top, multiplier: 1, constant: 0))

        
        
        
        return cardView
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView?{
        
//        var overlay = CustomOverlayView()
//        overlay.configureView(user: users[index])
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

extension String {
    var first: String {
        return String(characters.prefix(1))
    }
    var last: String {
        return String(characters.suffix(1))
    }
    var capitalized: String {
        return first.uppercased() + String(characters.dropFirst())
    }
}
