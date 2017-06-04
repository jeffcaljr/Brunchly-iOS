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

class WelcomeViewController: UIViewController{

    //MARK: - View Controller

    //MARK: - Login Button Delegate

    //MARK: - View Controller

    //MARK: - Login Button Delegate
    
    private var loginManager: FBSDKLoginManager!

    @IBOutlet weak var authOptionsView: UIStackView!
    @IBOutlet weak var fbLoginButton: RoundedButton!
    @IBOutlet weak var emailRegistrationButton: RoundedButton!
    @IBOutlet weak var loginButton: RoundedButton!
    
    
    
    @IBAction func onfbLoginPressed(_ sender: Any) {
        //attempt auth with Facebook application
            //if successful, attempt login with firebase application
                //if successful, go to Home screen
                //else, if unsuccesful, display message to user
            //else, if unsuccesful, display message to user
        
        loginManager.logIn(withReadPermissions: ["public_profile", "email", "user_friends"], from: self) { (result, error) in
            if let err = error{
                self.showFacebookErrorMessage()
                print("ERR: \(err.localizedDescription)")
            }
            else{
                //sign in with firebase
                if result != nil{
                    let credential = FIRFacebookAuthProvider.credential(withAccessToken: result!.token.tokenString)
                    FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
                        if user != nil{
                            self.proceedToHomeScreen()
                        }
                        else if let err = error{
                            self.showGenericErrorMessage();
                            print("ERR: \(err.localizedDescription)")
                        }
                    })
                }
                else{
                    self.showFacebookErrorMessage()
                }
                
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
        
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        //checkIfAuthenticated
            //if so, proceed to Home
        //if not, present normal view
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if isAuthenticated() {
            proceedToHomeScreen()
        }
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
    
    func showFacebookErrorMessage(){
        Toast(text: "Oops! Error logging in with Facebook!", delay: 0, duration: Delay.long).show()
    }
    
    func showGenericErrorMessage(){
        Toast(text: "Oops! Something went wrong!", delay: 0, duration: Delay.long).show()
    }
    
    
    func proceedToHomeScreen(){
        
        performSegue(withIdentifier: "GoToHomeScreen", sender: nil)
        
    }
    
    func logout(){
        try! FIRAuth.auth()?.signOut()
        loginManager.logOut()
        Toast(text: "Logged out!", delay: 0, duration: Delay.short).show()
    }

}
