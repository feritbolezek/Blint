//
//  Matches.swift
//  Blint
//
//  Created by Ferit Bölezek on 2017-06-12.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import Foundation
import UIKit

class Matches {


    var matchedPreferences = [String]()
    var matchedInterests = [String]()
    var matchedEducation = [String]()
    
    var usersName: String!
    var usersAge: String!
    var usersBio: String!
    var usersGender: String!
    var FCMToken: String?
    
    var usersProfileImage: UIImage?
    
    var theUser: BlintUser!
    
    init(user: BlintUser, matchPrefs: [String], matchInts: [String], matchEdu: [String]) {
        matchedPreferences = matchPrefs
        matchedInterests = matchInts
        matchedEducation = matchEdu
        
        theUser = user
        
        usersName = user.userInformation["name"] as! String
        usersAge =  user.userInformation["age"] as! String
        usersGender = user.userInformation["gender"] as! String
        usersBio = user.userInformation["aboutMe"] as! String
        FCMToken = user.userInformation["FCMToken"] as? String
    }
    init() {
        
    }
    

}
