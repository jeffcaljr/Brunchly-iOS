//
//  User.swift
//  Brunchly
//
//  Created by Jeffery Calhoun on 6/4/17.
//  Copyright © 2017 YoTechnica. All rights reserved.
//

import Foundation

struct User{
    var id: String
    var isProfileComplete: Bool = false
    var photoURLString: String
    var name: String
    var brunches: [Brunch]
    var friends: [User]
}
