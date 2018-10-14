//
//  MatchesAndChatServicesDelegate.swift
//  Blint
//
//  Created by Ferit Bölezek on 2017-06-18.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import Foundation
import UIKit

@objc protocol MatchesAndChatServiceDelegate: class {
    @objc optional func latestMessageChanged()
    @objc optional func userWasUnblocked(chat: Chat, userUnBlockedID: String)
    @objc optional func userWasBlocked(chat: Chat, userBlockedID: String)
    @objc optional func userPhotoWasDownloaded(chat: Chat, theImage: UIImage)
}
