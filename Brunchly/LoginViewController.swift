//
//  LoginViewController.swift
//  Brunchly
//
//  Created by Jeffery Calhoun on 6/3/17.
//  Copyright © 2017 YoTechnica. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: RoundedButton!
    
    
    @IBAction func backToWelcomePressed(_ sender: Any) {
        performSegue(withIdentifier: "UnwindFromLoginToWelcome", sender: nil)
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        let emailIcon = UIImageView(image: UIImage(named: "email"))
//        let passwordIcon = UIImageView(image: UIImage(named: "password"))
//        
//        emailField.leftViewMode = .always
//        emailField.leftView = emailIcon
//        
//        passwordField.leftViewMode = .always
//        passwordField.leftView = passwordIcon
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
