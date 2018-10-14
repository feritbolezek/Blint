//
//  UserDataFacebook.swift
//  Blint
//
//  Created by Ferit Bölezek on 28/05/17.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import Foundation
import FBSDKCoreKit


class UserDataFacebook {

    private var userData: Dictionary<String,String>?
    private var usersCalculatedAge = ""
    
    func getGraphAPIData(completion: @escaping (_ userData: Dictionary<String,String>) -> ()) {
    
        let connection = FBSDKGraphRequestConnection()
        let path = FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "birthday, first_name, education, about, gender, email"])
        
        connection.add(path, completionHandler: { (request, result, GRAPHerror) in
            
            if GRAPHerror == nil {
                if let facebookDict = result as? Dictionary<String,Any> {
                    self.setupData(facebookDataDictionary: facebookDict)
                }
            } else {
                print("There was an error trying to fetch users data from Facebook.")
            }
            if let dataFilled = self.userData {
                completion(dataFilled)
            }
        })
        connection.start()
        
        //TODO: SETUP COMPLETION HANDLER AND PASS DATA TO VIEWCONTROLLER AND THEN SETUP NODES ON FIREBASE WITH THE DATA RECIEVED FROM GRAPH API
    }
    
    func setupData(facebookDataDictionary: Dictionary<String,Any>) {
        
        let name = facebookDataDictionary["first_name"] as! String
        let birthday = facebookDataDictionary["birthday"] as? String
        let gender = facebookDataDictionary["gender"] as! String
        let email = facebookDataDictionary["email"] as! String
        
        if let birth = birthday {
        usersAgeCalculated(age: birth)
        }
        
        userData = ["usersName" : name, "usersEmail" : email, "gender": gender, "usersAge" : usersCalculatedAge]
        
        // Dont forget about education etc
    }
    
    private func usersAgeCalculated(age: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let usersBirthday = dateFormatter.date(from: age)
        let timeSince = Double(usersBirthday!.timeIntervalSinceNow)
        
        let dat = Double.abs(timeSince)
        
        let toYears = dat / (365*24*60*60)
        
        let usersAge = Int(toYears)
        
        usersCalculatedAge = String(usersAge)
    }


}
