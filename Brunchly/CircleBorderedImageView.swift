//
//  CircleImageView.swift
//  Brunchly
//
//  Created by Jeffery Calhoun on 6/5/17.
//  Copyright © 2017 YoTechnica. All rights reserved.
//

import UIKit

class CircleBorderedImageView: UIImageView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = frame.size.width / 2
        self.clipsToBounds = true
        
        
    }

}
