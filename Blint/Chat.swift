//
//  Chat.swift
//  Blint
//
//  Created by Ferit Bölezek on 2017-06-17.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

class Chat: NSObject {
    
    var chatID: String!
    
    var currentUsersID: String = KeychainWrapper.standard.string(forKey: USER_UID)!
    
    var currentUsersName: String!
    var secondChattersName: String!
    var secondChattersID: String!
    
    var latestMessage: String?
    var latestMessageTimestamp: Date?
    var latestMessageSenderID: String?
    var read: Bool?
    
    var secondChatterIsBlocked: Bool?
    var currentUserIsBlocked: Bool?
    
    var secondChattersAvatar: UIImage?
    
    
//    init(currentUsersName: String, secondChattersName: String, latestMessage: String, latestMessageTimestamp: TimeInterval, secondChattersAvatar: avatarView? = nil) {
//        self.currentUsersName = currentUsersName
//        self.secondChattersName = secondChattersName
//        self.latestMessage = latestMessage
//        self.latestMessageTimestamp = latestMessageTimestamp
//        self.secondChattersAvatar = secondChattersAvatar
//        
//    }
    init(chatID: String, chatDetails: Dictionary<String,Any>, chatters: Dictionary<String,Any>) {
        self.chatID = chatID
        for user in chatters {
            if (user.value as! String) != currentUsersID {
                secondChattersName = user.key
                secondChattersID = user.value as! String
            } else {
                currentUsersName = user.key
            }
        }
        for details in chatDetails {
            if details.key == "USERBLOCKED_\(secondChattersID!)" {
                secondChatterIsBlocked = true
            }
        }
        
        latestMessage = chatDetails["latestMessage"] as? String
        let lastestMessageTmstamp = chatDetails["timestamp"] as? String
        if lastestMessageTmstamp != nil {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let theTimestamp = dateFormatter.date(from: lastestMessageTmstamp!)
        latestMessageTimestamp = theTimestamp
        }
        latestMessageSenderID = chatDetails["sender"] as? String
        read = chatDetails["read"] as? Bool
        
    }
    
}
