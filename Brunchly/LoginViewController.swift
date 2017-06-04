//
//  LoginViewController.swift
//  Brunchly
//
//  Created by Jeffery Calhoun on 6/3/17.
//  Copyright © 2017 YoTechnica. All rights reserved.
//

import UIKit
import Toaster
import SwiftValidators

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: RoundedButton!
    @IBOutlet weak var messageLabel: MessageToUserLabel!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    
    @IBAction func backToWelcomePressed(_ sender: Any) {
        performSegue(withIdentifier: "UnwindFromLoginToWelcome", sender: nil)
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        messageLabel.hide()
//        Toast(text: "Should log user in", delay: 0, duration: Delay.short).show()
        
        if let email = emailField.text, let password = passwordField.text{
            EmailAuth.signIn(email: email, password: password, callback: { (response) in
                
                switch response.result {
                    case .success:
                        //TODO: No need to show message if login successful and performing segue; delete later
                        self.messageLabel.show(message: response.message, messageType: MessageType.normal)
                    case .userEmailNotVerified:
                        self.messageLabel.show(message: response.message, messageType: MessageType.error)
                    case .unknown:
                        self.messageLabel.show(message: response.message, messageType: MessageType.error)
                        Toast(text: response.message, delay: 0, duration: Delay.short).show()
                    default:
                        self.messageLabel.show(message: response.message, messageType: MessageType.error)
                    
                }
            })
        }
    }
    
    @IBAction func loginFieldChanged(_ sender: Any){
        let emailValidator = Validator.required() && Validator.isEmail()
        let passwordValidator = Validator.required() && Validator.minLength(8)
            && Validator.isAlphanumeric()
        
        if emailValidator.apply(emailField.text)
            && passwordValidator.apply(passwordField.text){
            loginButton.isEnabled = true
        }
        else{
            loginButton.isEnabled = false
        }
        
    }
    
    @IBAction func forgotPasswordButtonPressed(_ sender: Any) {
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
