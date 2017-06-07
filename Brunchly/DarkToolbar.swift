//
//  DarkToolbar.swift
//  Brunchly
//
//  Created by Jeffery Calhoun on 6/5/17.
//  Copyright © 2017 YoTechnica. All rights reserved.
//

import UIKit
import SideMenu

class DarkToolbar: UIToolbar {
    
    private var viewController: UIViewController?
    private var menuItem: UIBarButtonItem!

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        barStyle = .blackTranslucent
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let menuIcon = UIImage(named: "menu")
         menuItem = UIBarButtonItem(image: menuIcon, style: .plain, target: self, action: #selector(DarkToolbar.openMenu))
        
        menuItem.tintColor = UIColor(hexString: "#F44336")
        
        setItems([flexSpace, menuItem], animated: false)
        
    }
    
    @objc private func openMenu(){
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.openNavigationMenu()
//        if let vc = viewController{
//            let navMenuController = vc.storyboard?.instantiateViewController(withIdentifier: "NavigationMenuController") as! UISideMenuNavigationController
//            
//            
//            vc.present(navMenuController, animated: true, completion: nil)
        
//            let openMenuSegue = UIStoryboardSegue(identifier: "OpenMenu", source: vc, destination: navMenuController)
//            openMenuSegue.perform()
//        }
        
        
    }
    
    
    func setViewController(viewController: UIViewController){
        //TODO: Delete later.
        //TODO: Open Menu When Menu icon pressed
        self.viewController = viewController
    }
    
}
