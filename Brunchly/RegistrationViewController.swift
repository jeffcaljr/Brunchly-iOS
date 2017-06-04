//
//  RegistrationViewController.swift
//  Brunchly
//
//  Created by Jeffery Calhoun on 6/3/17.
//  Copyright © 2017 YoTechnica. All rights reserved.
//

import UIKit
import Toaster
import SwiftValidators
import ChameleonFramework
import FirebaseAuth

class RegistrationViewController: UIViewController {
    
    private var userAttemptingRegistration: FIRUser?
    
    @IBOutlet weak var emailField: DesignableUITextField!
    @IBOutlet weak var passwordField: DesignableUITextField!
    @IBOutlet weak var confirmPasswordField: DesignableUITextField!
    @IBOutlet weak var registerButton: RoundedButton!
    @IBOutlet weak var messageLabel: MessageToUserLabel!
    @IBOutlet weak var resendVerificationButton: UIButton!
    
    @IBAction func backToWelcomePressed(_ sender: Any) {
        
        performSegue(withIdentifier: "UnwindFromRegistrationToWelcome", sender: nil)
    }
    
    @IBAction func registerButtonPressed(_ sender: Any){
        
        messageLabel.hide()
        
        if !resendVerificationButton.isHidden {
            resendVerificationButton.isHidden = true
        }
        
//        Toast(text: "Should register user", delay: 0, duration: Delay.short).show()
        
        if let email = emailField.text, let password = passwordField.text{
            EmailAuth.register(email: email, password: password, callback: { (response) in
                
                switch response.result {
                    case .success:
                        //TODO: No need to show message if login successful and performing segue; delete later
                        self.messageLabel.show(message: response.message, messageType: MessageType.normal)
                    case .userEmailAlreadyInUse:
                        self.messageLabel.show(message: response.message, messageType: MessageType.error)
                        
                        let user = response.user
                        
                        if let isVerified = user?.isEmailVerified{
                            if !isVerified{
                                self.resendVerificationButton.isHidden = false
                                self.userAttemptingRegistration = user
                            }
                            else{
                                //email is taken by a verified user
                            }
                            
                        }
                    
                    case .unknown:
                        self.messageLabel.show(message: response.message, messageType: MessageType.error)
                        Toast(text: response.message, delay: 0, duration: Delay.short).show()
                    default:
                        self.messageLabel.show(message: response.message, messageType: MessageType.error)
                }
            })
        }
        
    }

    @IBAction func registrationFieldChanged(_ sender: Any) {
        
        //if the user attempts to register with taken email, and then changes data on the registration form, should hide "resend verification" button
        resendVerificationButton.isHidden = true
    
        let emailValidator = Validator.required() && Validator.isEmail()
        let passwordValidator = Validator.required() && Validator.minLength(8)
                                && Validator.isAlphanumeric()
        
        let confirmPasswordValidator = passwordValidator && Validator.equals(passwordField.text!)
        
        if emailValidator.apply(emailField.text)
            && passwordValidator.apply(passwordField.text)
            && confirmPasswordValidator.apply(confirmPasswordField.text){
            registerButton.isEnabled = true
        }
        else{
            registerButton.isEnabled = false
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        resendVerificationButton.addTarget(self, action: #selector(RegistrationViewController.resendVerificationPressed), for: .touchUpInside)
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
    
    func resendVerificationPressed(){
        if let user = userAttemptingRegistration{
            EmailAuth.sendVerificationEmail(user: user, callback: { (response) in
                switch response.result{
                    case .success:
                        self.messageLabel.show(message: response.message, messageType: MessageType.normal)
                        self.resendVerificationButton.isHidden = true
                    case .unknown:
                        self.messageLabel.show(message: response.message, messageType: MessageType.error)
                        Toast(text: response.message, delay: 0, duration: Delay.short).show()
                    default:
                        self.messageLabel.show(message: response.message, messageType: MessageType.error)
                }
            })
        }
    }
    

}



