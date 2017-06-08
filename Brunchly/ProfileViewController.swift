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
import CZPicker
import ALCameraViewController
import LocationPicker
import SwiftValidators
import FirebaseStorage

class ProfileViewController: UIViewController, CZPickerViewDelegate, CZPickerViewDataSource, UITextFieldDelegate{
    
    let maleImage = UIImage(named: "male")
    let femaleImage = UIImage(named: "female")
    let anyGenderImage = UIImage(named: "preference")
    let genericUser = #imageLiteral(resourceName: "generic_user.png")
    
    var isPhotoSet: Bool! = false{
        didSet{
            print("is photo set: \(isPhotoSet)")
        }
    }
    
    var initialImage: UIImage?
    var profilePhotoChanged = false{
        didSet{
            resetAction.isEnabled = profilePhotoChanged
            isPhotoSet = initialImage == nil
        }
    }
    
    var photoPickerAlert: UIAlertController!
    var resetAction: UIAlertAction!
    
    var imagePickerController: CameraViewController!
    
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
        
        var toastMessage: String?
        
        var nameSubstrings: [String]?
        var nameSubstringsValid = true
        var trimmedName: String?
        
        let nameMinLengthValidator = Validator.minLength(8)
        let nameMaxLengthValidator = Validator.maxLength(32)
        let nameTextValidator = Validator.isAlpha()
        let nameEmptyValidator = Validator.required()
        
        let locationSetValidator = Validator.required()
        
        
        //check each space-separated substring of the name to make sure they only contain alphabet
        
        if let name = nameField.text{
            trimmedName = name.trimmingCharacters(in: CharacterSet.whitespaces)
            nameSubstrings = trimmedName!.components(separatedBy: " ")
            
            for subString in nameSubstrings!{
                if !nameTextValidator.apply(subString){
                    nameSubstringsValid = false
                    break
                }
            }
        }
        
        
        
        if !isPhotoSet{
            toastMessage = "A profile photo is required"
        }
        else if !nameEmptyValidator.apply(nameField.text){
            toastMessage = "Must enter a name"
        }
        else if !nameMinLengthValidator.apply(trimmedName!){
            toastMessage = "Name must be at least 8 characters"
        }
        else if !nameMaxLengthValidator.apply(trimmedName!){
            toastMessage = "Name must be no more than 32 characters"
        }
        else if !nameSubstringsValid{
            toastMessage = "Invalid name. Only letters and spaces allowed"
        }
        else if !locationSetValidator.apply(locationTextField.text){
            toastMessage = "Location required. Tap the location pin to set"
        }
        
        if let errorMsg = toastMessage{
            var errorToast = Toast(text: errorMsg, delay: 0, duration: Delay.short)
            errorToast.view.backgroundColor = UIColor.flatRed()
            errorToast.view.textColor = UIColor.white
            errorToast.show()
        }
        else{
//            Toast(text: "should save profile", delay: 0, duration: Delay.short).show()
            
            switch preferenceButton.currentTitle!{
                case "Men":
                    globalUser!.sexPreference = Gender.male
                
                case "Women":
                    globalUser!.sexPreference = Gender.female
                case "All":
                    globalUser!.sexPreference = Gender.unspecified
                default:
                    globalUser!.sexPreference = Gender.unspecified
            }
            
            switch genderSwitch.isOn{
                case true: //assumed to be men
                    globalUser!.gender = Gender.male
                case false: //assumed to be woman
                    globalUser!.gender = Gender.female
            }
            
            globalUser!.name = nameField.text!
            globalUser!.location = locationTextField.text!
            globalUser!.isProfileComplete = true
            
            //attempt to upload profile picture if neccessary, then save user to db
            
            if profilePhotoChanged{
                //upload new photo and update user in db
                uploadProfilePicture(photo: photoView.image!, callback: { (url, error) in
                    if let error = error{
                        var errorToast = Toast(text: "Error saving profile!", delay: 0, duration: Delay.short)
                        errorToast.view.backgroundColor = UIColor.flatRed()
                        errorToast.view.textColor = UIColor.white
                        errorToast.show()
                    }
                    else{
                        GlobalUser.sharedInstance.setGlobalUser(user: self.globalUser!, callback: { (error, reference) in
                            if let err = error{
                                var errorToast = Toast(text: "Error saving profile!", delay: 0, duration: Delay.short)
                                errorToast.view.backgroundColor = UIColor.flatRed()
                                errorToast.view.textColor = UIColor.white
                                errorToast.show()
                            }
                            else{
                                //photo uploaded, profile saved
                                Toast(text: "profile and image saved!", delay: 0, duration: Delay.short).show()
                            }
                        })
                    }
                })
            }
            else{
                //skip photo upload and just update user in db
                
                GlobalUser.sharedInstance.setGlobalUser(user: globalUser!, callback: { (error, reference) in
                    if let err = error{
                        var errorToast = Toast(text: "Error saving profile!", delay: 0, duration: Delay.short)
                        errorToast.view.backgroundColor = UIColor.flatRed()
                        errorToast.view.textColor = UIColor.white
                        errorToast.show()
                    }
                    else{
                        //user saved to database
                        Toast(text: "profile saved!", delay: 0, duration: Delay.short).show()
                    }
                })
            }
            
            
        }
        
        
        
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
            
            nameField.text = user.name ?? ""
            locationTextField.text = user.location ?? ""
            
            //set user gender
            
            if let gender = user.gender{
                switch gender{
                    case .female:
                        genderSwitch.isOn = false
                        genderLabel.text = "Woman"
                        genderImage.image = femaleImage
                    default:
                        genderSwitch.isOn = true
                        genderLabel.text = "Man"
                        genderImage.image = maleImage
                }
            }
            else{
                genderSwitch.isOn = true
                genderImage.image = maleImage
            }
            
            //set user preference
            
            if let preference = user.sexPreference{
                
                switch preference {
                case .female:
                    preferenceButton.setTitle("Women", for: UIControlState.normal)
                    preferenceImage.image = femaleImage
                case .male:
                    preferenceButton.setTitle("Men", for: UIControlState.normal)
                    preferenceImage.image = maleImage
                default:
                    preferenceButton.setTitle("Any", for: UIControlState.normal)
                    preferenceImage.image = anyGenderImage
                }
                
            }
            else{
                preferenceButton.setTitle("Any", for: UIControlState.normal)
                preferenceImage.image = anyGenderImage
            }
            
            if let urlString = user.photoURLString, let url = URL(string: urlString){
                photoView.kf.setImage(with: url, placeholder: genericUser, options: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, url) in
                    self.initialImage = image
                    self.isPhotoSet = true
                })
            }
            else{
                isPhotoSet = false
            }
        }
        else{
            photoView.image = UIImage(named: "generic_user.png")
        }
        
        let redColor = UIColor(hexString: "#F44336")
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
        
        
        photoPickerAlert = UIAlertController(title: "Change Photo", message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        resetAction = UIAlertAction(title: "Reset", style: .destructive) { (action) in
            //handle reset option
            self.photoView.image = self.initialImage ?? self.genericUser
            self.profilePhotoChanged = false
        }
        
        resetAction.isEnabled = false
        
        let cameraAction = UIAlertAction(title: "Choose", style: .default) { (action) in
            //handle camera action
            self.present(self.imagePickerController, animated: true, completion: nil)
        }
        
        photoPickerAlert.addAction(cameraAction)
        photoPickerAlert.addAction(resetAction)
        photoPickerAlert.addAction(cancelAction)
        
        genderSwitch.tintColor = UIColor(hexString: "#E91E63")
        
        imagePickerController = CameraViewController(croppingEnabled: true) { [weak self] image, asset in
            // Do something with your image here.
            // If cropping is enabled this image will be the cropped version
            
            self?.profilePhotoChanged = true
            self?.photoView.image = image
            
            self?.dismiss(animated: true, completion: nil)
        }
        
        nameField.delegate = self
        locationTextField.delegate = self
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated);
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LogOut", let welcomeVC = segue.destination as? WelcomeViewController{
            welcomeVC.logout()
        }
        else if segue.identifier == "ShowLocationPicker", let locationPicker = segue.destination as? LocationPickerViewController{
            
            locationPicker.showCurrentLocationButton = true
            locationPicker.showCurrentLocationInitially = true
            locationPicker.mapType = .standard
            locationPicker.useCurrentLocationAsHint = true
            locationPicker.completion = {(location) in
                self.locationTextField.text = location?.address
            }
            
        }
        
        
    }
    
    //MARK: CZPickerViewDelegate
    
    func czpickerView(_ pickerView: CZPickerView!, didConfirmWithItemAtRow row: Int){
        pickerView.animationDuration = 0
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
    
    
    //MARK: TextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nameField.resignFirstResponder()
        locationTextField.resignFirstResponder()
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
    
    func uploadProfilePicture(photo: UIImage, callback: @escaping (_ photoUrl: String?, _ error: Error?) -> Void){
        print("uploading photo")
        
        if let data = UIImagePNGRepresentation(photo) as NSData?{
            
            let photoRef = FIRStorage.storage().reference().child("profile_photos").child(globalUser!.id!)
            
            
            let uploadTask = photoRef.put(data as Data, metadata: nil) { (metadata, error) in
                
                if let metadata = metadata{
                    let url = metadata.downloadURL()
                    callback(url?.absoluteString, nil)
                }
                
            }

        }
        
    }

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

