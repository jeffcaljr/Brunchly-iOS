//
//  ProfileViewController.swift
//  Brunchly
//
//  Created by Jeffery Calhoun on 6/3/17.
//  Copyright © 2017 YoTechnica. All rights reserved.
//

import UIKit
import Toaster
import Kingfisher
import FirebaseAuth
import LocationPickerViewController

class ProfileViewController: UIViewController {
    
    var globalUser: User?

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var contentScrollView: UIScrollView!
    @IBOutlet weak var photoView: CircleBorderedImageView!
    @IBOutlet weak var nameField: DesignableUITextField!
    @IBOutlet weak var locationField: DesignableUITextField!
    @IBOutlet weak var saveProfileButton: RoundedButton!
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBAction func saveProfileButtonPressed(_ sender: Any) {
    }
    @IBAction func pickLocationButtonPressed(_ sender: Any) {
        showLocationPicker()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        backgroundImageView.addBlurEffect()
        
        contentScrollView.contentSize = CGSize(width: 375, height: view.bounds.height * 2)
        
        locationField.leftView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.showLocationPicker)))
        
        globalUser = GlobalUser.sharedInstance.getUserLocal()
        
        if let user = globalUser{
            if let urlString = user.photoURLString, let url = URL(string: urlString){
                photoView.kf.setImage(with: url)
                if let name = user.name{
                    nameField.text = name
                }
            }
        }
        else{
            photoView.image = UIImage(named: "generic_user.png")
        }
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LogOut", let welcomeVC = segue.destination as? WelcomeViewController{
            welcomeVC.logout()
        }
        else if segue.identifier == "ShowLocationPicker", let locationPicker = segue.destination as? LocationChooserViewController{
            
//            let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(ProfileViewController.setLocation))
//            doneBtn.tintColor = UIColor.white
//            
//            let cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(ProfileViewController.dismissLocationPicker))
//            
//            cancelBtn.tintColor = UIColor.white
            
//            locationPicker.addBarButtons(doneButtonItem: doneBtn, cancelButtonItem: cancelBtn, doneButtonOrientation: .right)
            
            
//            let darkGray = UIColor(hexString: "#5A5A7A")
//            let lightGray = UIColor(hexString: "#757575")
//            
//            locationPicker.pinColor = UIColor.flatPink()
//            
//            locationPicker.setColors(themeColor: UIColor.flatRedColorDark(), primaryTextColor: darkGray, secondaryTextColor: lightGray)
            
            
            locationPicker.pickCompletion = {(pickedLocationItem) in
                print(pickedLocationItem.description)
                self.locationTextField.text = pickedLocationItem.description
            }
        }
        
        
    }
    
    func showLocationPicker(){
        performSegue(withIdentifier: "ShowLocationPicker", sender: self)
        
    }
    
//    func setLocation(){
//        
//    }
//    
//    func dismissLocationPicker(){
//        print("should dismiss location picker")
//    }

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
