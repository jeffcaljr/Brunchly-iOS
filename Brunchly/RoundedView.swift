//
//  RoundedView.swift
//  Brunchly
//
//  Created by Jeffery Calhoun on 6/5/17.
//  Copyright © 2017 YoTechnica. All rights reserved.
//

import UIKit


@IBDesignable
class RoundedView: UIView {

    
    @IBInspectable var cornerRadius: CGFloat = 0{
        didSet{
            updateView()
        }
    }
    
    
    func updateView() {
        layer.cornerRadius = cornerRadius
    }

}
