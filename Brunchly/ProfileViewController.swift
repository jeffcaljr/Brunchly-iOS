//
//  ProfileViewController.swift
//  Brunchly
//
//  Created by Jeffery Calhoun on 6/13/17.
//  Copyright © 2017 YoTechnica. All rights reserved.
//

import UIKit
import Kingfisher

class ProfileViewController: UIViewController {
    
    var user: TestUser!
    var photo: UIImage!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var nameView: UILabel!
    @IBOutlet weak var ageView: UILabel!
    @IBOutlet weak var locationView: UILabel!
    @IBOutlet weak var profilePictureView: CircleBorderedImageView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        backgroundImageView.addBlurEffect()
        
        let resizedPhoto = UIImage.resizeImage(image: photo, newWidth: 200)
        profilePictureView.kf.setImage(with: URL(string: user.photoURL))
        nameView.text = user.name
        ageView.text = "\(user.age)"
        locationView.text = user.address
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func configure(withUser user: TestUser, andImage photo: UIImage){
        self.user = user
        self.photo = photo
    }
    


}
