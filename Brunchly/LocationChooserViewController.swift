//
//  LocationPickerViewController.swift
//  Brunchly
//
//  Created by Jeffery Calhoun on 6/5/17.
//  Copyright © 2017 YoTechnica. All rights reserved.
//

import UIKit
import LocationPickerViewController
import ChameleonFramework

class LocationChooserViewController: LocationPicker, LocationPickerDelegate {
    
    @IBOutlet weak var cancelItem: UIBarButtonItem!
    @IBOutlet weak var doneItem: UIBarButtonItem!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var toolbar: UIToolbar!
    
    @IBAction func cancelItemPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneItemPressed(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        delegate = self
        
        addBarButtons()
        


        view.frame = contentView.frame
        
        let darkGray = UIColor(hexString: "#5A5A7A")
        let lightGray = UIColor(hexString: "#757575")
        
        pinColor = UIColor.flatPink()

        setColors(themeColor: UIColor.flatRedColorDark(), primaryTextColor: darkGray, secondaryTextColor: lightGray)
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: LocationPickerDelegate
//    override func locationDidSelect(locationItem: LocationItem){
//        doneItem.isEnabled = true
//    }
    

   

}
