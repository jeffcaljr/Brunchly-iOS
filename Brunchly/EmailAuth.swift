//
//  EmailAuth.swift
//  Brunchly
//
//  Created by Jeffery Calhoun on 6/4/17.
//  Copyright © 2017 YoTechnica. All rights reserved.
//

import Foundation
import FirebaseAuth

class EmailAuth{
    
    func signIn(email: String, password: String, callback: ((_ message: String, _ error: Error?) -> Void)?) {
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, err) in
            if err != nil {
                if let errCode = FIRAuthErrorCode(rawValue: err!._code){
                    
                    switch errCode{
                    case .errorCodeUserNotFound:
                        if let call = callback {
                            call("User not found", err)
                        }
                        case .errorCode
                    default:
                        if let call = callback {
                            call("Something went wrong...", err)
                        }
                    }
                    
                }
                
        
            }
        })
    }
    
}
