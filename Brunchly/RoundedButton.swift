//
//  RoundedButton.swift
//  Brunchly
//
//  Created by Jeffery Calhoun on 6/3/17.
//  Copyright © 2017 YoTechnica. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {
    
    var disabledAlpha = 0.5
    
    override var isEnabled: Bool{
        didSet{
            if isEnabled == true{
                alpha = 1.0
            }
            else{
                alpha = CGFloat(disabledAlpha)
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 4
        if isEnabled == false{
            alpha = CGFloat(disabledAlpha)
        }
    }

}
