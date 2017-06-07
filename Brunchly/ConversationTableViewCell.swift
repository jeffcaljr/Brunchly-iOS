//
//  ConversationTableViewCell.swift
//  Brunchly
//
//  Created by Jeffery Calhoun on 6/7/17.
//  Copyright © 2017 YoTechnica. All rights reserved.
//

import UIKit

class ConversationTableViewCell: UITableViewCell {
    @IBOutlet weak var photoView: CircleBorderedImageView!
    @IBOutlet weak var nameView: UILabel!
    @IBOutlet weak var messageView: UILabel!
    @IBOutlet weak var dateView: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(name: String, photo: UIImage?, message: String, date: String){
        nameView.text = name
        photoView.image = photo
        messageView.text = message
        dateView.text = date
    }

}
