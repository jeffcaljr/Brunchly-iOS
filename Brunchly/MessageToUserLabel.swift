//
//  MessageToUserLabel.swift
//  Brunchly
//
//  Created by Jeffery Calhoun on 6/4/17.
//  Copyright © 2017 YoTechnica. All rights reserved.
//

import UIKit
import ChameleonFramework

class MessageToUserLabel: UILabel {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func show(message: String, messageType type: MessageType){
        text = message
        isHidden = false
        
        switch type{
        case .error:
            textColor = UIColor.flatRedColorDark()
            
        case.normal:
            textColor = UIColor.flatWhite()
        }
    }
    
    func hide(){
        text = ""
        isHidden = true
        textColor = UIColor.flatWhite()
    }

}

enum MessageType {
    case error
    case normal
}
