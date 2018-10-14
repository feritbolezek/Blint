//
//  FirebaseDatabaseNodesSetup.swift
//  Blint
//
//  Created by Ferit Bölezek on 25/05/17.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper
import Firebase

/// Preferably setup during authenticationService sign up.
/// Majority of this class is to setup the database structure for new users.

class FirebaseDatabaseNodesSetup {
    
    
    var randomUIDsForSpecifics = [NSUUID]()
    
    func setupNodesForNewUser(WithID keychainID: String, userInformation: Dictionary<String, String>, completion: @escaping (_ alreadyUser: Bool) -> ()) {
        checkIfNecessary(keychainID: keychainID) { (exists) in
            if exists {
                completion(true)
                return
            } else {
                for index in 0...2 {
                    self.randomUIDsForSpecifics.append(NSUUID.init())
                }
                
                
                let ref = DataService.standard.USERS_REF.child(keychainID).child("userSpecifics")
                let refUserInformation = DataService.standard.USERS_REF.child(keychainID).child("userInformation")
                // Profile image node could be maybe set up here?
                
                ref.updateChildValues(["userEducationAndWork" : self.randomUIDsForSpecifics[0].uuidString, "userInterests" : self.randomUIDsForSpecifics[1].uuidString, "userPreferences" : self.randomUIDsForSpecifics[2].uuidString]) { (error, reference) in
                    
                    if error != nil {
                        // TODO: Check this out later.
                        print("Potential critical error. Could not set up Firebase nodes for new user.")
                    } else {
                        let preferencesReference = self.randomUIDsForSpecifics[2].uuidString
                        DataService.standard.PREFERENCES_REF.child(preferencesReference).updateChildValues(["Female" : true, "Male" : true])
                    }
                    
                }
                let UUIDForMatches = NSUUID().uuidString
                refUserInformation.updateChildValues(["aboutMe": "empty", "age" : userInformation["usersAge"]!, "name" : userInformation["usersName"]!, "gender" : userInformation["gender"] , "email" : userInformation["usersEmail"]!, "relationshipStatus" : "empty", "matchesReference" : UUIDForMatches]) { (error, reference) in
                    if error != nil {
                        print(error?.localizedDescription)
                    } else {
                        completion(false)
                    }
                }
            }
        }
        
    }
    
    func checkIfNecessary(keychainID: String, completion: @escaping (_ exists: Bool) -> ()) {
        DataService.standard.USERS_REF.child(keychainID).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                // Path already exists, no need to create new nodes.
                completion(true)
            } else {
                self.addToUtilities()
                completion(false)
            }
        })
    }
    
    func addToUtilities() {
        DataService.standard.UTILITIES_REF.child("amountOfUsers").observeSingleEvent(of: .value, with: { (snapshot) in
            let amount = snapshot.value as! Int
            DataService.standard.UTILITIES_REF.updateChildValues(["amountOfUsers" : amount + 1])
        })
    }
    
    func setFCMToken() {
        let token = Messaging.messaging().fcmToken
        if token != nil {
            DataService.standard.CURRENT_USER_REF.child("userInformation").child("FCMToken").setValue(token!)
        }
    }
    
    
    
}
