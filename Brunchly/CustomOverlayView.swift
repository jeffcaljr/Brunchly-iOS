//
//  OverlayView.swift
//  Brunchly
//
//  Created by Jeffery Calhoun on 6/6/17.
//  Copyright © 2017 YoTechnica. All rights reserved.
//

import UIKit
import Koloda
import ChameleonFramework

class CustomOverlayView: OverlayView {
    @IBOutlet weak var nameField: UILabel!
    @IBOutlet weak var ageField: UILabel!
    @IBOutlet weak var locationField: UILabel!
    @IBOutlet var contentView: UIView!
    @IBOutlet var icons: [UIImageView]!

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit(){
        Bundle.main.loadNibNamed("CustomOverlayView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let darkGray = UIColor(hexString: "#212121")!
        
        nameField.textColor = darkGray
        ageField.textColor = darkGray
        locationField.textColor = darkGray
        
        for icon in icons{
            icon.image = icon.image?.maskWithColor(color: UIColor(hexString: "#D32F2F"))
        }
        
        backgroundColor = UIColor(hexString: "#EEEEEE")
        
    }
    
    func configureView(user: TestUser){
        nameField.text = user.name
        ageField.text = "\(user.age)"
        locationField.text = user.address
    }

}
