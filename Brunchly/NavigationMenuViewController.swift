//
//  NavigationMenuViewController.swift
//  Brunchly
//
//  Created by Jeffery Calhoun on 6/6/17.
//  Copyright © 2017 YoTechnica. All rights reserved.
//

import UIKit
import ChameleonFramework

class NavigationMenuViewController: UIViewController {
    @IBOutlet var icons: [UIImageView]!
    @IBOutlet weak var profileImageView: CircleBorderedImageView!

    @IBAction func logoutButtonPressed(_ sender: Any) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.logout()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //hide the navigation bar for this menu
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        if let user = GlobalUser.sharedInstance.getUserLocal(){
            if let photoURL = user.photoURLString, let url = URL(string: photoURL){
                profileImageView.kf.setImage(with: url)
            }
        }
        
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(NavigationMenuViewController.profilePictureTapped(gesture:))))
        
        let iconColor = UIColor(hexString: "#F44336")
        
        for icon in icons{
            icon.image? = (icon.image?.maskWithColor(color: iconColor!))!
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
    
    func profilePictureTapped(gesture: UIGestureRecognizer){
        
        performSegue(withIdentifier: "MenuShowProfile", sender: self)
        
        
    }
    
    

}

extension UIImage {
    
    func maskWithColor(color: UIColor) -> UIImage? {
        let maskImage = cgImage!
        
        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
        
        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)
        
        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }
    
}
