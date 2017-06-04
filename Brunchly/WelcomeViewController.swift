//
//  LoginViewController.swift
//  Brunchly
//
//  Created by Jeffery Calhoun on 6/3/17.
//  Copyright © 2017 YoTechnica. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import Toaster

class WelcomeViewController: UIViewController, FBSDKLoginButtonDelegate {

    //MARK: - View Controller

    //MARK: - Login Button Delegate

    //MARK: - View Controller

    //MARK: - Login Button Delegate
    
    private var loginManager: FBSDKLoginManager!

    @IBOutlet weak var authOptionsView: UIStackView!
    @IBOutlet weak var fbLoginButton: RoundedFbLoginButton!
    @IBOutlet weak var emailRegistrationButton: RoundedButton!
    @IBOutlet weak var loginButton: RoundedButton!
    
    
    
    @IBAction func onfbLoginPressed(_ sender: Any) {
        //attempt auth with Facebook application
            //if successful, attempt login with firebase application
                //if successful, go to Home screen
                //else, if unsuccesful, display message to user
            //else, if unsuccesful, display message to user
        
        loginManager.logIn(withReadPermissions: ["public_profile", "email", "user_friends"], from: self){ (result, error) in
            
            if error != nil {
                Toast(text: "Oops! Error logging in with Facebook!", delay: 0, duration: Delay.long).show()
            }
            else{
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: (result?.token.tokenString)!)
                FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
                    
                    if error != nil {
                        Toast(text: "Oops! Something went wrong!", delay: 0, duration: Delay.long).show()
                    }
                    else{
                        if user != nil{
                            //signed into Facebook and Firebase successfully
                            
                            self.proceedToHomeScreen();
                        }
                        else{
                            print("no FIRUser")
                        }
                    }
                    
                })
                
            }
            
        }
    }
    
    @IBAction func onEmailRegistrationPressed(_ sender: Any) {
        performSegue(withIdentifier: "GoToRegistration", sender: nil)
    }
    
    @IBAction func onLoginPressed(_ sender: Any) {
        performSegue(withIdentifier: "GoToLogin", sender: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        loginManager = FBSDKLoginManager()
        
        fbLoginButton.delegate = self
        
        //TODO: Delete later
        logout()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        //checkIfAuthenticated
            //if so, proceed to Home
        //if not, present normal view
        
        if isAuthenticated() {
            proceedToHomeScreen()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: FBSDKLoginButton
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!){
        Toast(text: "Oops! Error logging in with Facebook!", delay: 0, duration: Delay.long).show()
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!){
        logout()
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func isAuthenticated() -> Bool{
        if FBSDKAccessToken.current() != nil {
            if FIRAuth.auth()?.currentUser != nil{
                return true
            }
            else{
                print("not logged into firebase")
                return false
            }
        }
        else{
            print("not logged into facebook")
            return false
        }
    }
    
    
    func proceedToHomeScreen(){
        
        performSegue(withIdentifier: "GoToHomeScreen", sender: nil)
        
    }
    
    func logout(){
        try! FIRAuth.auth()?.signOut()
        loginManager.logOut()
    }

}
