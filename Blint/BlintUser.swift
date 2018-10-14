//
//  BlintUser.swift
//  Blint
//
//  Created by Ferit Bölezek on 14/05/17.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper

/// This enum will be used to decide what data should be downloaded.
enum FetchOptions {
    
    case fetchAllData
    case fetchUserInformation
    case fetchUserSpecifics
    case fetchMatches
    case fetchChats
    
}

enum userTaggy {
    
    case userPreferences
    case userInterests
    case userEducationAndWork
    
}

class BlintUser: NSObject {
    
    var userInterestsID: String?
    var userPreferencesID: String?
    var userEducationAndWorkID: String?
    var userMatchesReferenceID: String?
    var userFCMToken: String?
    
    var userProfilePhotoID: String?
    
    private var _userKeychainID: String?
    
    var userKeychainID: String {
        if let userIDExists = KeychainWrapper.standard.string(forKey: USER_UID) {
            return userIDExists
        } else {
            print("CRITICAL ERROR, NO ID FOUND IN KEYCHAIN!")
            return "CRITICAL ERROR, NO ID FOUND IN KEYCHAIN!"
        }
    }
    
    
    var userInformation = Dictionary<String,Any>()
    var chats = Dictionary<String,Any>()
    var matches = Dictionary<String,Any>()
    var userSpecifics = Dictionary<String,Any>()
    var userPreferences = Dictionary<String,Any>()
    var userID = ""
    
    var userPreferencesLabels = [String]()
    var userInterestsLabels = [String]()
    var userEducationAndWorkLabels = [String]()
    
    override init() {
        super.init()
        setFCMToken()
    }
    init(matchAttemptUserID: String, userDict: Dictionary<String,Any>) {
        self.userID = matchAttemptUserID
        self.userInformation = userDict["userInformation"] as! Dictionary<String,Any>
    }
    
    func setFCMToken() {
        let token = Messaging.messaging().fcmToken
        self.userFCMToken = token
        if token != nil {
            DataService.standard.CURRENT_USER_REF.child("userInformation").child("FCMToken").setValue(token!)
        }
    }
    
    func fetchUserData(dataToFetch: FetchOptions, forUserID: String ,completion: @escaping () -> ()) {
        
        DataService.standard.USERS_REF.child(forUserID).observe(.value, with: { (snapshot) in
            if snapshot.value is NSNull {
                return
            }
            if let snap = snapshot.children.allObjects as? [DataSnapshot] {
                for child in snap {
                    
                    if let extractedValue = child.value as? Dictionary<String, Any> {
                        switch child.key {
                        case "userInformation":
                            self.userInformation = extractedValue
                            break
                        case "chats":
                            self.chats = extractedValue
                            break
                        case "matches":
                            self.matches = extractedValue
                            break
                        case "userSpecifics":
                            self.userSpecifics = extractedValue
                            self.assignValues()
                            break
                        default:
                            print("fatal error")
                        }
                        
                    }
                }
                completion()
                
            }
            
        })
        
        
        
    }
    
    func downloadAllComparableData(completion: @escaping () -> ()) {
        
        DataService.standard.getPathToUserInterests(userInterestsID: self.userInterestsID!).observe(.value, with: { (snapshot) in
            self.userInterestsLabels.removeAll()
            if let snaps = snapshot.children.allObjects as? [DataSnapshot] {
                for interest in snaps {
                    self.userInterestsLabels.append(interest.key)
                }
            }
        })
        
        DataService.standard.getPathToUserPreferences(userPreferencesID: self.userPreferencesID!).observe(.value, with: { (snapshot) in
            self.userPreferencesLabels.removeAll()
            if let snaps = snapshot.children.allObjects as? [DataSnapshot] {
                for preference in snaps {
                    self.userPreferencesLabels.append(preference.key)
                }
            }
        })
        DataService.standard.getPathToUserEducationAndWork(userEducationAndWorkID: self.userEducationAndWorkID!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            self.userEducationAndWorkLabels.removeAll()
            if let snaps = snapshot.children.allObjects as? [DataSnapshot] {
                for interest in snaps {
                    self.userEducationAndWorkLabels.append(interest.key)
                }
            }
            completion()
        })
        
        
        
    }
    
    func loadInPreferences(completion: @escaping (_ preferencesLabels: [String]) -> ()) {
        DataService.standard.getPathToUserPreferences(userPreferencesID: userPreferencesID!).observe(.value, with: { (snapshot) in
            self.userPreferencesLabels.removeAll()
            
            if let snaps = snapshot.children.allObjects as? [DataSnapshot] {
                for preference in snaps {
                    self.userPreferencesLabels.append(preference.key)
                }
            }
            completion(self.userPreferencesLabels)
        })
    }
    func loadInInterests(completion: @escaping (_ InterestsLabels: [String]) -> ()) {
        DataService.standard.getPathToUserInterests(userInterestsID: userInterestsID!).observe(.value, with: { (snapshot) in
            
            self.userInterestsLabels.removeAll()
            if let snaps = snapshot.children.allObjects as? [DataSnapshot] {
                for interest in snaps {
                    self.userInterestsLabels.append(interest.key)
                }
            }
            completion(self.userInterestsLabels)
        })
    }
    func loadInEducationAndWork(completion: @escaping (_ educationAndWork: [String]) -> ()) {
        DataService.standard.getPathToUserEducationAndWork(userEducationAndWorkID: userEducationAndWorkID!).observe(.value, with: { (snapshot) in
            self.userEducationAndWorkLabels.removeAll()
            if let snaps = snapshot.children.allObjects as? [DataSnapshot] {
                for interest in snaps {
                    self.userEducationAndWorkLabels.append(interest.key)
                }
            }
            completion(self.userEducationAndWorkLabels)
        })
    }
    
    
    func assignValues() { // Called from extension
        if let userSpecificsLoaded = userSpecifics["userPreferences"] as? String {
            userPreferencesID = userSpecificsLoaded
        }
        if let userSpecificsLoaded = userSpecifics["userInterests"] as? String {
            userInterestsID = userSpecificsLoaded
        }
        if let userSpecificsLoaded = userSpecifics["userEducationAndWork"] as? String {
            userEducationAndWorkID = userSpecificsLoaded
        }
    }
    
    func saveUserInfo(biography: String? = nil, relationshipStatus: String? = nil) {
        
        if let userBiography = biography, let userRelationshipStatus = relationshipStatus {
            DataService.standard.USERS_REF.child("userInformation").setValue(userBiography)
        }
        
    }
    
    func saveUserSpecifics(data: String ,typeOfData: UserInformationType, completion: @escaping (_ error: Error?) -> ()) {
        let path = dataPath(typeOfData: typeOfData)
        
        path.updateChildValues([data: true]) { (error, reference) in
            if error != nil {
                completion(error)
            } else {
                completion(nil)
            }
        }
        
    }
    
    func deleteUserSpecifics(data: String ,typeOfData: UserInformationType, completion: @escaping (_ error: Error?) -> ()) {
        let path = dataPath(typeOfData: typeOfData)
        
        path.child(data).removeValue { (error, reference) in
            if error != nil {
                completion(error)
            } else {
                completion(nil)
            }
        }
        
    }
    
    func dataPath(typeOfData: UserInformationType) -> DatabaseReference {
        
        switch typeOfData {
        case .preferences:
            return DataService.standard.getPathToUserPreferences(userPreferencesID: userPreferencesID!)
        case .interests:
            return DataService.standard.getPathToUserInterests(userInterestsID: userInterestsID!)
        case .educationAndWork:
            return DataService.standard.getPathToUserEducationAndWork(userEducationAndWorkID: userEducationAndWorkID!)
        }
        
    }
    
    func downloadCurrentUsersImageIfExists(completion: @escaping (_ theImage: UIImage) -> ()) {
        if let profilePhotoID = self.userInformation["profilePhotoID"] as? String {
            DataService.standard.PROFILE_PHOTOS_REF.child(profilePhotoID).getData(maxSize: 1024 * 1000, completion: { (data, error) in
                if error == nil {
                    let userDefaults = UserDefaults.standard
                    userDefaults.set(data!, forKey: "currentProfilePhoto_\(self.userKeychainID)")
                    let imageReceived = UIImage(data: data!)
                    completion(imageReceived!)
                } else {
                    // TODO: Add functionality on download fail.
                    print("FAILED TO DOWNLOAD \(error?.localizedDescription) \(error.debugDescription)")
                }
            })
            
        } else {
            // TODO: Add functionality on "not found" failure.
            print("COULD NOT FIND PROFILE PHOTO ID")
        }
    }
    
    func updateUsersProfileimage(theImage: UIImage, completion: @escaping (_ response: DataResponse) -> ()) {
        
        
        let theImageAsData = UIImageJPEGRepresentation(theImage, 0.1)
        
        let metaData = StorageMetadata()
        
        metaData.contentType = "image/jpeg"
        
        let uniquePhotoID = NSUUID().uuidString
        DataService.standard.PROFILE_PHOTOS_REF.child(uniquePhotoID).putData(theImageAsData!, metadata: metaData) { (metaDetaReturned, error) in
            
            if error != nil {
                completion(.failed)
            } else {
                self.updatePhotoReference(photoID: uniquePhotoID, completion: { (referenceResponse) in
                    if referenceResponse == .success {
                        completion(.success)
                        // success
                    } else {
                        // failed
                    }
                })
            }
            
        }
        
        
    }
    
    func updatePhotoReference(photoID: String, completion: @escaping (_ response: DataResponse) -> ()) {
        DataService.standard.USERS_REF.child(userKeychainID).child("userInformation").child("profilePhotoID").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.value is NSNull {
                // No removal required. This is the users first profile photo.
                DataService.standard.USERS_REF.child(self.userKeychainID).child("userInformation").child("profilePhotoID").setValue(photoID, withCompletionBlock: { (error, reference) in
                    if error != nil {
                        // critical error, not being added to userinformation will cause failures to download image.
                        completion(.failed)
                    } else {
                        completion(.success)
                    }
                })
            } else {
                let previousPhotoID = snapshot.value as! String
                DataService.standard.PROFILE_PHOTOS_REF.child(previousPhotoID).delete(completion: { (error) in
                    if error != nil {
                        // the photo was not removed, could be issues later on because the storage will have unnecessary images. NO HANDLING FOR NOW.
                    }
                    DataService.standard.USERS_REF.child(self.userKeychainID).child("userInformation").child("profilePhotoID").setValue(photoID, withCompletionBlock: { (error, reference) in
                        if error != nil {
                            // critical error, not being added to userinformation will cause failures to download image.
                            completion(.failed)
                        } else {
                            completion(.success)
                        }
                    })
                    
                })
            }
        })
    }
    
    func removeUserPermanently(completion: @escaping (_ error: Bool) -> ()) {
        let currentUser = Auth.auth().currentUser
        DataService.standard.CURRENT_USER_REF.removeAllObservers()
        self.removeAllUserData(completion: { (error) in
            if error {
                completion(true)
            } else {
                self.changeAmountOfUsersVal {
                    currentUser?.delete(completion: { (error) in
                        if error != nil {
                            completion(true)
                        } else {
                            completion(false)
                        }
                    })
                }
            }
        })
    }
    
    func changeAmountOfUsersVal(completion: @escaping () -> ()) {
        DataService.standard.UTILITIES_REF.child("amountOfUsers").observeSingleEvent(of: .value, with: { (snapshot) in
            let amount = snapshot.value as! Int
            DataService.standard.UTILITIES_REF.updateChildValues(["amountOfUsers" : amount - 1], withCompletionBlock: { (error, reference) in
                completion()
            })
            
        })
    }
    
    func removeAllUserData(completion: @escaping (_ error: Bool) -> ()) {
        
        if let userInterestsReady = userInterestsID, let userPreferencesReady = userPreferencesID, let userEducationReady = userEducationAndWorkID, let userMatchedReady = userMatchesReferenceID {
            
            
            DataService.standard.PREFERENCES_REF.child(userPreferencesReady).removeValue()
            DataService.standard.INTERESTS_REF.child(userInterestsReady).removeValue()
            DataService.standard.EDUCATION_AND_WORK_REF.child(userEducationReady).removeValue()
            DataService.standard.MATCHES_REF.child(userMatchedReady).removeValue()
            DataService.standard.CURRENT_USER_REF.removeValue()
            if userProfilePhotoID == nil {
                completion(false)
            } else {
                DataService.standard.PROFILE_PHOTOS_REF.child(userProfilePhotoID!).delete(completion: { (error) in
                    if error == nil {
                        completion(false)
                    } else {
                        completion(false) // Image was not deleted, however we are still going through.
                    }
                })
            }
        } else {
            completion(true)
        }
    }
}
