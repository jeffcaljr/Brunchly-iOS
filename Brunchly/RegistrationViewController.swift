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

class RegistrationViewController: UIViewController {
    @IBOutlet weak var emailField: DesignableUITextField!
    @IBOutlet weak var passwordField: DesignableUITextField!
    @IBOutlet weak var confirmPasswordField: DesignableUITextField!
    @IBOutlet weak var registerButton: RoundedButton!
    @IBOutlet weak var messageLabel: MessageToUserLabel!
    
    
    @IBAction func backToWelcomePressed(_ sender: Any) {
        
        performSegue(withIdentifier: "UnwindFromRegistrationToWelcome", sender: nil)
    }
    
    @IBAction func registerButtonPressed(_ sender: Any){
        messageLabel.hide()
        Toast(text: "Should register user", delay: 0, duration: Delay.short).show()
    }

    @IBAction func registrationFieldChanged(_ sender: Any) {
    
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



