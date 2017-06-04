//
//  EmailAuth.swift
//  Brunchly
//
//  Created by Jeffery Calhoun on 6/4/17.
//  Copyright © 2017 YoTechnica. All rights reserved.
//

import Foundation
import FirebaseAuth

enum ResetPasswordResult{
    case unknown
    case success
    case networkError
    case userNotFound
    case invalidEmail
}

enum SignInResult{
    case unknown
    case success
    case networkError
    case userNotFound
    case invalidEmail
    case userAccountDisabled
    case userCredentialsInvalid
    case userEmailNotVerified
}

enum RegisterResult{
    case unknown
    case success
    case networkError
    case userNotFound
    case invalidEmail
    case userEmailAlreadyInUse
    case passwordTooWeak
}

struct EmailAuthResetPasswordResponse{
    var message: String
    var error: Error?
    var result: ResetPasswordResult
}
struct EmailAuthSignInResponse{
    var message: String
    var error: Error?
    var result: SignInResult
}

struct EmailAuthRegisterResponse{
    var message: String
    var error: Error?
    var result: RegisterResult
    var user: FIRUser?
}

struct EmailAuth{
    
    static func signIn(email: String, password: String, callback: @escaping ((_ response: EmailAuthSignInResponse) -> Void)) {
        
        
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, err) in
            
            var response = EmailAuthSignInResponse(message: "Something went wrong...", error: err, result: .unknown)
            
            if err != nil {
                
                response.error = err
                
                if let errCode = FIRAuthErrorCode(rawValue: err!._code){
                    
                    switch errCode{
                        case .errorCodeUserNotFound:
                            response.message = "User not found."
                            response.result = .userNotFound
                        case .errorCodeNetworkError:
                            response.message = "Network error."
                            response.result = .networkError
                        case .errorCodeUserDisabled:
                            response.message = "Your account has been disabled."
                            response.result = .userAccountDisabled
                        case .errorCodeInvalidEmail:
                            response.message = "Invalid email."
                            response.result = .invalidEmail
                        case.errorCodeWrongPassword:
                            response.message = "Invalid email/password combination."
                            response.result = .userCredentialsInvalid
                        default:
                            //fields should already be properly set in response object
                            print("Error '\(errCode)' wasnt specifically handled in EmailAuth: signIn")
                    }
                    
                }
            }
            else if user != nil{
                if user!.isEmailVerified {
                    response.message = "Logged in successfully"
                    response.result = .success
                }
                else{
                    response.message = "Uh-oh. Looks like you need to verify your email."
                    response.result = .userEmailNotVerified
                }
                
            }
            else{
                print("Unexpected error in EmailAuth: signIn")
                exit(1)
            }
            
            
            callback(response)
        })
    }
    
    
    static func register(email: String, password: String, callback: @escaping ((_ response: EmailAuthRegisterResponse) -> Void)){
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, err) in
            
            var response = EmailAuthRegisterResponse(message: "Something went wrong...", error: err, result: RegisterResult.unknown, user: user)
            if err != nil{
                if let errCode = FIRAuthErrorCode(rawValue: err!._code){
                    
                    switch errCode{
                    case .errorCodeUserNotFound:
                        response.message = "User not found."
                        response.result = .userNotFound
                    case .errorCodeNetworkError:
                        response.message = "Network error."
                        response.result = .networkError
                    case .errorCodeEmailAlreadyInUse:
                        response.message = "This email is already registered."
                        response.result = .userEmailAlreadyInUse
                    case .errorCodeInvalidEmail:
                        response.message = "Invalid email."
                        response.result = .invalidEmail
                    case.errorCodeWeakPassword:
                        //TODO: Give more info as to why the password was too weak.
                        //From Firebase docs: Indicates an attempt to set a password that is considered too weak. The NSLocalizedFailureReasonErrorKey field in the NSError.userInfo dictionary object will contain more detailed explanation that can be shown to the user.
                        //https://firebase.google.com/docs/auth/ios/errors
                        response.message = "Password too weak."
                        response.result = .passwordTooWeak
                    default:
                        //fields should already be properly set in response object
                        print("Error '\(errCode)' wasnt specifically handled in EmailAuth: signIn")
                    }
                    
                }
            }
            else if user != nil{
                self.sendVerificationEmail(user: user!, callback: callback)
//                    callback("Registered successfully", nil, true)
            }
            else{
                print("Unexpected error in EmailAuth: signIn")
                exit(1)
            }
            
            callback(response)
        })
    }
    
    static func sendPasswordResetEmail(email: String, callback: @escaping ((_ response: EmailAuthResetPasswordResponse) -> Void)){
        
        FIRAuth.auth()?.sendPasswordReset(withEmail: email, completion: { (err) in
            
            var response = EmailAuthResetPasswordResponse(message: "Something went wrong...", error: err, result: .unknown)
            if err != nil{
                if let errCode = FIRAuthErrorCode(rawValue: err!._code){
                    
                    switch errCode{
                    case .errorCodeUserNotFound:
                        response.message = "User not found."
                        response.result = .userNotFound
                    case .errorCodeNetworkError:
                        response.message = "Network error."
                        response.result = .networkError
                    case .errorCodeInvalidEmail:
                        response.message = "Invalid email."
                        response.result = .invalidEmail
                    default:
                        //fields should already be properly set in response object
                        print("Error '\(errCode)' wasnt specifically handled in EmailAuth: signIn")
                    }
                    
                }
            }
            else{
                //success
                response.message = "Check your email for password reset instructions."
                response.result = .success
            }
            
            callback(response)

        })
    }
    
    static func sendVerificationEmail(user: FIRUser, callback: @escaping ((_ response: EmailAuthRegisterResponse) -> Void)){
        
        user.sendEmailVerification(completion: { (err) in
            
            var response = EmailAuthRegisterResponse(message: "Something went wrong...", error: err, result: .unknown, user: user)
            
            if err != nil{
                if let errCode = FIRAuthErrorCode(rawValue: err!._code){
                    
                    switch errCode{
                        case .errorCodeUserNotFound:
                            response.message = "User not found."
                            response.result = .userNotFound
                        case .errorCodeNetworkError:
                            response.message = "Network error."
                            response.result = .networkError
                        default:
                            //fields should already be properly set in response object
                            print("Error '\(errCode)' wasnt specifically handled in EmailAuth: signIn")
                    }
                    
                }
            }
            else{
                //success
                response.message = "Check your email for verication."
                response.result = .success
            }

            callback(response)
            
        })
    }
}

