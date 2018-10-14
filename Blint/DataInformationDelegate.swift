//
//  DataInformationDelegate.swift
//  Blint
//
//  Created by Ferit Bölezek on 30/05/17.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import Foundation

@objc protocol DataInformationDelegate: class {
   @objc optional func newDataAdded(data: [String])
    @objc optional func fetchedAllData(user: BlintUser)
    @objc optional func fetchedInformationFor(type: String)
    @objc optional func userInfoWasChanged(dataChanged: String, theData: String, secondaryData: String?)
    @objc optional func segueCalledForInformation()
}
