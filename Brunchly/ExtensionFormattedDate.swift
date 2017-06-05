//
//  ExtensionFormattedDate.swift
//  Brunchly
//
//  Created by Jeffery Calhoun on 6/4/17.
//  Copyright © 2017 YoTechnica. All rights reserved.
//

import Foundation

extension Date{
    func getFormattedDate() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let formattedDate = formatter.string(from: self)
        return formattedDate
    }
    
    static func fromFormattedString(dateString: String) -> Date?{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = formatter.date(from: dateString)
        return date
    }
}
