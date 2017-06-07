//
//  NavigationMenuViewController.swift
//  Brunchly
//
//  Created by Jeffery Calhoun on 6/6/17.
//  Copyright © 2017 YoTechnica. All rights reserved.
//

import UIKit

class NavigationMenuViewController: UIViewController {
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
