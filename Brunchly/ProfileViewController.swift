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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
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

}
