//
//  DarkMaskView.swift
//  Brunchly
//
//  Created by Jeffery Calhoun on 6/6/17.
//  Copyright © 2017 YoTechnica. All rights reserved.
//

import UIKit


@IBDesignable
class DarkMaskView: UIView {

    @IBInspectable var transparency: CGFloat = 0.5{
        didSet{
            updateView()
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    func updateView(){
        backgroundColor = UIColor(hexString: "#212121", withAlpha: transparency)
    }

}
