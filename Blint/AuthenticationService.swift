//
//  AuthenticationService.swift
//  Blint
//
//  Created by Ferit Bölezek on 25/04/17.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import Foundation
import Firebase
import FBSDKLoginKit
import SwiftKeychainWrapper

class AuthenticationService {


    public static var standard = AuthenticationService()
    
    typealias Completion = (_ errorMessage: String?,_ data: Any?) -> Void
    
    func signupUserWith(email: String, password: String, onComplete: @escaping Completion) {
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            
            if error == nil {
                KeychainWrapper.standard.set(user!.uid, forKey: USER_UID)
                onComplete(nil, user)
                
            } else {
               self.firebaseError(error: error!, onComplete: onComplete)
            }
            
            
        })
        
    }
    func authenticateWithFacebook(from: UIViewController, onComplete: @escaping Completion) {
        
        let facebookManager = FBSDKLoginManager()

        facebookManager.logIn(withReadPermissions: ["public_profile","email","user_birthday"], from: from) { (result, error) in
            
            if error != nil {
                print("there was an error") // TODO: Error handling Facebook?
            } else if result?.isCancelled == true {
                print("User cancelled login") // I guess do something?
            } else {
                if result!.declinedPermissions.count > 0 {
                    for declined in result!.declinedPermissions {
                        onComplete("Access to necessary data has been declined. All data asked for is necessary, make sure all checkboxed are marked. Or use Blint custom sign up.",nil)
                    }
                } else {
                let credential = FacebookAuthProvider.credential(withAccessToken: result!.token.tokenString)
                self.authenticateWithFirebase(using: credential, onComplete: onComplete)
                }
            }
            
        }
        
    
    }
    
    private func authenticateWithFirebase(using facebookCredentials: AuthCredential, onComplete: @escaping Completion) {
        
        Auth.auth().signIn(with: facebookCredentials, completion: { (user, error) in
            if error == nil {
               KeychainWrapper.standard.set(user!.uid, forKey: USER_UID)
               onComplete(nil, user)
            } else {
                self.firebaseError(error: error!, onComplete: onComplete)
            }
        })
        
    }
    
    func signin(withEmail: String, password: String, oncComplete: @escaping Completion) {
        
        Auth.auth().signIn(withEmail: withEmail, password: password, completion: { (user, error) in
            
            if error != nil {
             
                self.firebaseError(error: error!, onComplete: oncComplete)
                
            } else {
                KeychainWrapper.standard.set(user!.uid, forKey: USER_UID)
                oncComplete(nil, user)
            }
        })
        
    }
    
    func checkIfUserIsLoggedIn() -> Bool {
        if KeychainWrapper.standard.string(forKey: USER_UID) != nil {
            if Auth.auth().currentUser == nil {
                // Keychain value is saved and the user has not logged out, however the user is not 'signed into' Firebase.
                return false
            } else {
            return true
            }
        } else {
            return false
        }
    }
    
    func firebaseError(error: Error?, onComplete: Completion?) {
        if let errorCode = AuthErrorCode(rawValue: (error?._code)!) {
            
            switch errorCode {
            case .invalidEmail:
                onComplete?("The email is invalid.",nil)
            case .emailAlreadyInUse:
                onComplete?("The email is already in use.",nil)
            case .weakPassword:
                onComplete?("Weak password. Please make sure you have minimum 6 letters.",nil)
            case .accountExistsWithDifferentCredential:
                onComplete?("Incorrect password or email.", nil)
            case .networkError:
                onComplete?("Network error.", nil)
            case .wrongPassword:
                onComplete?("Incorrect password or email.", nil)
            case .invalidCredential:
                onComplete?("Invalid credentials.", nil)
            case .userNotFound:
                onComplete?("User could not be found.", nil)
            default:
                onComplete?(" \(error!.localizedDescription) Please try again.",nil)
            }    
        }    }


}
