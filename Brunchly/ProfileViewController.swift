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
import CZPicker

class ProfileViewController: UIViewController, CZPickerViewDelegate, CZPickerViewDataSource {
    
    let maleImage = UIImage(named: "male")
    let femaleImage = UIImage(named: "female")
    let anyGenderImage = UIImage(named: "preference")
    
    var photoPickerAlert: UIAlertController!
    
    var globalUser: User?

    
    var preferenceOptions = ["Men", "Women", "Any"]
    var preferenceImages: [UIImage]!
    
    var preferencePicker: CZPickerView?
    

    @IBOutlet weak var toolbar: DarkToolbar!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var contentScrollView: UIScrollView!
    @IBOutlet weak var photoView: CircleBorderedImageView!
    @IBOutlet weak var nameField: DesignableUITextField!
    @IBOutlet weak var saveProfileButton: RoundedButton!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var preferenceImage: UIImageView!
    @IBOutlet weak var preferenceButton: UIButton!
    @IBOutlet weak var genderSwitch: UISwitch!
    @IBOutlet weak var genderImage: UIImageView!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var changePhotoButton: UIButton!
    
    @IBAction func saveProfileButtonPressed(_ sender: Any) {
    }
    @IBAction func pickLocationButtonPressed(_ sender: Any) {
        showLocationPicker()
    }
    @IBAction func preferenceButtonPressed(_ sender: Any) {
        preferencePicker?.show()
        
    }
    @IBAction func genderSwitchToggled(_ sender: UISwitch) {
        if sender.isOn{
            genderLabel.text = "Man"
            genderImage.image = maleImage
        }
        else{
            genderLabel.text = "Woman"
            genderImage.image = femaleImage
        }
    }
    @IBAction func changePhotoButtonPressed(_ sender: Any) {
        self.present(photoPickerAlert, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        backgroundImageView.addBlurEffect()
        
        contentScrollView.contentSize = CGSize(width: 375, height: view.bounds.height * 2)
        
        toolbar.setViewController(viewController: self)
        
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
        
        let redColor = UIColor.flatRedColorDark()
        let whiteColor = UIColor.white
        
        preferenceButton.contentHorizontalAlignment = .left
        
        preferenceImages = [maleImage!, femaleImage!, anyGenderImage!]
        
        preferencePicker = CZPickerView(headerTitle: "Preference", cancelButtonTitle: "Cancel", confirmButtonTitle: "Confirm")
        preferencePicker?.delegate = self
        preferencePicker?.dataSource = self
        preferencePicker?.needFooterView = true
        preferencePicker?.checkmarkColor = redColor
        preferencePicker?.headerTitleColor = redColor
        preferencePicker?.headerBackgroundColor = whiteColor
        preferencePicker?.cancelButtonNormalColor = redColor
        preferencePicker?.cancelButtonBackgroundColor = whiteColor
        preferencePicker?.confirmButtonNormalColor = whiteColor
        preferencePicker?.confirmButtonBackgroundColor = redColor
        
        photoPickerAlert = UIAlertController(title: "Choose Photo", message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let galleryAction = UIAlertAction(title: "Library", style: .default) { (action) in
            //handle gallery option
        }
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            //handle camera action
        }
        
        photoPickerAlert.addAction(cameraAction)
        photoPickerAlert.addAction(galleryAction)
        photoPickerAlert.addAction(cancelAction)
        
        genderSwitch.tintColor = UIColor(hexString: "#E91E63")
        
        
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
    
    //MARK: CZPickerViewDelegate
    
    func czpickerView(_ pickerView: CZPickerView!, didConfirmWithItemAtRow row: Int){
        preferenceButton.setTitle(preferenceOptions[row], for: .normal)
        preferenceImage.image = preferenceImages[row]
    }
    
    
    
    func czpickerViewDidClickCancelButton(_ pickerView: CZPickerView!){
        
    }
    
    //MARK: CZPickerViewDataSource
    
    func numberOfRows(in pickerView: CZPickerView!) -> Int{
        
        return preferenceOptions.count
        
    }
    
    
    
    
    func czpickerView(_ pickerView: CZPickerView!, titleForRow row: Int) -> String!{
        return preferenceOptions[row]
    }
    
    
    func czpickerView(_ pickerView: CZPickerView!, imageForRow row: Int) -> UIImage!{
        return preferenceImages[row]
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

