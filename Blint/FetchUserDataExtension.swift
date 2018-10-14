//
//  FetchUserDataExtension.swift
//  Blint
//
//  Created by Ferit Bölezek on 15/05/17.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import Foundation
import Firebase


extension BlintUser {
    
    
    /** Use this function only to fetch any sort of data.
     
        param1: The userID saved in keychain.
        param2: The desired data to be fetched.
        param3: Completion handler.
 
    **/
    func checkConnection(completion: @escaping (_ received: Bool) -> ()) {

        
        let connectedRef = Database.database().reference(withPath: ".info/connected")
        connectedRef.observe(.value, with: { snapshot in
            if let connected = snapshot.value as? Bool, connected {
              completion(true)
            } else {
              completion(false)
            }
        })
        

    }
    
    func fetchData(userID: String, dataToFetch: FetchOptions ,completion: @escaping () -> ()) {
            
        let dataFetch = DataThatWillBeFetched(userID: userID, dataToFetch: dataToFetch)
        DataService.standard.USERS_REF.child(dataFetch).observe(.value, with: { (snapshot) in
            if dataToFetch == .fetchAllData {
                if let snap = snapshot.children.allObjects as? [DataSnapshot] {
               // print("A STEP BEFORE \(snapshot.value)") // --> The value for non-all data needs to be extracted here
                for child in snap {
                    if let extractedValue = child.value as? Dictionary<String, Any> {
                        self.pickDictionaryToFill(child: child, extractedValue: extractedValue, dataToExtract: dataToFetch)
                        
                    }
                }
                completion()
            }
            } else {
                let extractedValue = snapshot.value as! Dictionary<String,Any>
                self.pickDictionaryToFill(child: snapshot, extractedValue: extractedValue, dataToExtract: dataToFetch)
                completion()
            }
        })
    }
    
    
    func fetchDaata(userID: String, dataToFetch: FetchOptions ,completion: @escaping () -> ()) {
        
        let dataFetch = DataThatWillBeFetched(userID: userID, dataToFetch: dataToFetch)

        let observer = DataService.standard.USERS_REF.child(dataFetch).observe(.value, with: { (snapshot) in
            
            if let connected = snapshot.value as? Bool, connected {
                
            } else {
                // TODO: Add functionality.
                print("NOT CONNECTED")
            }
            
            if dataToFetch == .fetchAllData {
                if let snap = snapshot.children.allObjects as? [DataSnapshot] {
                    // print("A STEP BEFORE \(snapshot.value)") // --> The value for non-all data needs to be extracted here
                    for child in snap {
                        if let extractedValue = child.value as? Dictionary<String, Any> {
                            self.pickDictionaryToFill(child: child, extractedValue: extractedValue, dataToExtract: dataToFetch)
                            
                        }
                    }
                    completion()
                }
            } else {
                let extractedValue = snapshot.value as! Dictionary<String,Any>
                self.pickDictionaryToFill(child: snapshot, extractedValue: extractedValue, dataToExtract: dataToFetch)
                completion()
            }
        })
    }
    
    private func DataThatWillBeFetched(userID: String, dataToFetch: FetchOptions) -> String {
        
        var dataToDownload = ""
        
        switch dataToFetch {
            
        case .fetchAllData:
            dataToDownload = userID
            return dataToDownload
            
        case .fetchUserInformation:
            dataToDownload = userID + "/userInformation"
            return dataToDownload
            
        case .fetchChats:
            dataToDownload = userID + "/chats"
            return dataToDownload
            
        case .fetchMatches:
            dataToDownload = userID + "/matches"
            return dataToDownload
            
        case .fetchUserSpecifics:
            dataToDownload = userID + "/userSpecifics"
            return dataToDownload
        }
        
    }
    
    func pickDictionaryToFill(child: DataSnapshot,extractedValue: Dictionary<String,Any>, dataToExtract: FetchOptions) {
        if dataToExtract == .fetchAllData {
        switch child.key {
        case "userInformation":
            self.userInformation = extractedValue
            self.userMatchesReferenceID = self.userInformation["matchesReference"] as? String
            self.userProfilePhotoID = self.userInformation["profilePhotoID"] as? String
            break
        case "chats":
            self.chats = extractedValue
            break
        case "matches":
            self.matches = extractedValue
            break
        case "userSpecifics":
            self.userSpecifics = extractedValue
            assignValues()
            break
        default:
            print("fatal error")
         }
        } else {
            switch dataToExtract {
            case .fetchChats:
                self.chats = extractedValue
                break
            case .fetchUserInformation:
                self.userInformation = extractedValue
                break
            case .fetchMatches:
                self.matches = extractedValue
                break
            case .fetchUserSpecifics:
                self.userSpecifics = extractedValue
                break
            default:
                break
            }
        }
    }


}
