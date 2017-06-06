//
//  DarkToolbar.swift
//  Brunchly
//
//  Created by Jeffery Calhoun on 6/5/17.
//  Copyright © 2017 YoTechnica. All rights reserved.
//

import UIKit

class DarkToolbar: UIToolbar {
    
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
        
        menuItem.tintColor = UIColor.white
        
        setItems([flexSpace, menuItem], animated: false)
        
    }
    
    
    func openMenu(){
        //TODO: Delete later.
        //TODO: Open Menu When Menu icon pressed
    }
    
}
