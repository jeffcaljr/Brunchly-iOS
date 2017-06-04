//
//  LoginViewController.swift
//  Brunchly
//
//  Created by Jeffery Calhoun on 6/3/17.
//  Copyright © 2017 YoTechnica. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var authOptionsView: UIStackView!
    @IBOutlet weak var fbLoginButton: RoundedButton!
    @IBOutlet weak var emailRegistrationButton: RoundedButton!
    @IBOutlet weak var loginButton: RoundedButton!
    
    
    
    @IBAction func onfbLoginPressed(_ sender: Any) {
    }
    
    @IBAction func onEmailRegistrationPressed(_ sender: Any) {
    }
    
    @IBAction func onLoginPressed(_ sender: Any) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
