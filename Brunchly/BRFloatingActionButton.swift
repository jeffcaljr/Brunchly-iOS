//
//  BRFloatingActionButton.swift
//  Brunchly
//
//  Created by Jeffery Calhoun on 6/8/17.
//  Copyright © 2017 YoTechnica. All rights reserved.
//

import UIKit
import Floaty

class BRFloatingActionButton: Floaty {
    
    private var searchItem: FloatyItem!
    private var friendSuggestionsItem: FloatyItem!
    private var newItem: FloatyItem!
    
    
    private var onSearchItemPressed: ((FloatyItem) -> Void)?
    private var onNewItemPressed: ((FloatyItem) -> Void)?
    private var onFriendSuggestionItemPressed: ((FloatyItem) -> Void)?

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
        buttonImage = UIImage.resizeImage(image: UIImage(named: "brunchly_b_icon")!, newWidth: 30)
        
        itemShadowColor = UIColor.white
        
        
        openAnimationType = .slideLeft
        overlayColor = UIColor(hexString: "#000000", withAlpha: 0.7)
        
        searchItem = FloatyItem()
        searchItem.buttonColor = UIColor.white
        searchItem.icon = UIImage(named: "search")!.maskWithColor(color: UIColor(hexString: "#F44336")!)
        searchItem.circleShadowColor = UIColor.red
        searchItem.titleShadowColor = UIColor.blue
        searchItem.title = "Search"
        searchItem.titleShadowColor = UIColor.blue
        searchItem.titleLabel.font = UIFont(name: "Avenir Next", size: 16)
        searchItem.handler = onSearchItemPressed
        
        
        friendSuggestionsItem = FloatyItem()
        friendSuggestionsItem.buttonColor = UIColor.white
        friendSuggestionsItem.icon = UIImage(named: "friend_suggestion")!.maskWithColor(color: UIColor(hexString: "#F44336")!)
        friendSuggestionsItem.circleShadowColor = UIColor.red
        friendSuggestionsItem.titleShadowColor = UIColor.blue
        friendSuggestionsItem.title = "Friend Suggestions"
        friendSuggestionsItem.titleShadowColor = UIColor.blue
        friendSuggestionsItem.titleLabel.font = UIFont(name: "Avenir Next", size: 16)
        friendSuggestionsItem.handler = onSearchItemPressed
        
            
        newItem = FloatyItem()
        newItem.buttonColor = UIColor.white
        newItem.icon = UIImage(named: "add_invitation")!.maskWithColor(color: UIColor(hexString: "#F44336")!)
        newItem.circleShadowColor = UIColor.red
        newItem.titleShadowColor = UIColor.blue
        newItem.title = "New Invitation"
        newItem.titleShadowColor = UIColor.blue
        newItem.titleLabel.font = UIFont(name: "Avenir Next", size: 16)
        newItem.handler = onNewItemPressed
        
        addItem(item: searchItem)
        addItem(item: friendSuggestionsItem)
        addItem(item: newItem)
        
    }
    
    func setSearchItemPressedCallback(method: @escaping (_ item: FloatyItem) -> Void){
        onSearchItemPressed = method
    }

    func setNewItemPressedCallback(method: @escaping (_ item: FloatyItem) -> Void){
        onNewItemPressed = method
    }
    
    func setFriendSuggestionItemPressedCallback(method: @escaping (_ item: FloatyItem) -> Void){
        onFriendSuggestionItemPressed = method
    }
}
