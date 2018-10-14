//
//  DataService.swift
//  Blint
//
//  Created by Ferit Bölezek on 14/05/17.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper

let databaseReference = Database.database().reference()
let storsageReference = Storage.storage().reference()

class DataService {

    static let standard = DataService()
    
    let USERS_REF = databaseReference.child("Users")
    let PREFERENCES_REF = databaseReference.child("UserPreferences")
    let INTERESTS_REF = databaseReference.child("UserInterests")
    let EDUCATION_AND_WORK_REF = databaseReference.child("EducationAndWork")
    
    let MATCHES_REF = databaseReference.child("Matches")
    let CHATS_REF = databaseReference.child("Chats")
    let REPORTS_REF = databaseReference.child("Reports")
    
    let USERS_REJECTED_REF = databaseReference.child("UsersRejected")
    let USERS_LIKED_REF = databaseReference.child("UsersLiked")
    let REPORTED_USERS_REF = databaseReference.child("ReportedUsers")
    let UTILITIES_REF = databaseReference.child("UtilityData")
    let RANDOM_USERS_REF = databaseReference.child("randomizedSelection")
    
    let PROFILE_PHOTOS_REF = storsageReference.child("ProfilePhotos")

    var CURRENT_USER_REF: DatabaseReference {
        let userInKeychain = KeychainWrapper.standard.string(forKey: USER_UID)
        if userInKeychain == nil {
            return USERS_REF.child("Placeholder, If this is nil for some reason (which it should never be) the results could be fatal.")
        } else {
        return USERS_REF.child(userInKeychain!)
        }
    }
    
    
    func getPathToUserPreferences(userPreferencesID: String) -> DatabaseReference {
        return PREFERENCES_REF.child(userPreferencesID)
    }
    
    func getPathToUserInterests(userInterestsID: String) -> DatabaseReference {
        return INTERESTS_REF.child(userInterestsID)
    }
    
    func getPathToUserEducationAndWork(userEducationAndWorkID: String) -> DatabaseReference {
        return EDUCATION_AND_WORK_REF.child(userEducationAndWorkID)
    }







}
