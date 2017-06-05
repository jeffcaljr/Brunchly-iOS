//
//  GlobalUser.swift
//  Brunchly
//
//  Created by Jeffery Calhoun on 6/4/17.
//  Copyright © 2017 YoTechnica. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class GlobalUser{
    
    private var auth: FIRAuth?
    private var storedUser: User?
    
    
    static let sharedInstance = GlobalUser(auth: FIRAuth.auth())
    
    private init(auth: FIRAuth?){
        self.auth = auth
    }
    
    
    func getUserLocal() -> User?{
        
        return storedUser
    }
    
    func getUserRemote(callback: @escaping (_ user: User?) -> Void){
        
        if let id = auth?.currentUser?.uid{
            User.firReadUser(userID: id) {
                (user) in
                self.storedUser = user
                callback(user)
            }
        }
        
    }
    
    func setGlobalUser(user: User, callback: @escaping (_ error: Error?, _ reference: FIRDatabaseReference) -> Void){
        storedUser = user
        User.firUpdateUser(user: user, callback: callback)
    }
    
    func initGlobalUser(callback: @escaping (_ error: Error?, _ reference: FIRDatabaseReference) -> Void){
        if let user = auth?.currentUser{
            User.firCreateUser(user: user, callback: callback)
        }
    }
    
    
}
