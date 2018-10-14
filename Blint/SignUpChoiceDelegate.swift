//
//  SignUpChoiceDelegate.swift
//  Blint
//
//  Created by Ferit Bölezek on 25/04/17.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import Foundation


@objc protocol SignUpChoiceDelegate: class {
    
    @objc optional func emailFilledIn(emailAddress: String)
    @objc optional func ageFilledIn(age: String)
    @objc optional func genderFilledIn(gender: String)
    @objc optional func passwordFilledIn(password: String)
    @objc optional func termsTapped()
    @objc optional func privacyTapped()
}
