//
//  ProfileViewController.swift
//  Brunchly
//
//  Created by Jeffery Calhoun on 6/3/17.
//  Copyright © 2017 YoTechnica. All rights reserved.
//

import UIKit
import Toaster

class ProfileViewController: UIViewController {
    
    var globalUser: User?

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var contentScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        backgroundImageView.addBlurEffect()
        
        contentScrollView.contentSize = CGSize(width: 375, height: view.bounds.height * 2)
        
        //TODO: delete contentView touch listener later
        
//        contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.testContentViewTouched)))
        
        globalUser = GlobalUser.sharedInstance.getUserLocal()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        var testMessage: String
        
        if let user = globalUser{
            testMessage = "hello, user# \(user.id)"
        }
        else{
            testMessage = "failed to load user!"
        }
        Toast(text: testMessage, delay: 0, duration: Delay.long).show()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LogOut", let welcomeVC = segue.destination as? WelcomeViewController{
            welcomeVC.logout()
        }
    }
    
    
    //TODO: Delete testContentViewTouched later
    func testContentViewTouched(){
        print("content view touched")
    }

}

extension UIImageView{
    
    func addBlurEffect(){
    
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.frame = self.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.addSubview(blurEffectView)
    }
}
