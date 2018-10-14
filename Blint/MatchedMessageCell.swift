//
//  MatchedMessageCell.swift
//  Blint
//
//  Created by Ferit Bölezek on 2017-06-17.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import UIKit

class MatchedMessageCell: UITableViewCell {

    @IBOutlet weak var matchedUsersAvatar: avatarView!
    
    @IBOutlet weak var matchedUsersName: UILabel!
    
    @IBOutlet weak var latestMessage: UILabel!
    
    @IBOutlet weak var latestMessageTimestamp: UILabel!
    
    var newTimestamp: String!
    
    var chatID: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setupView(chat: Chat, updatedValues: Dictionary<String,Any>? = nil) {
        if chat.secondChattersAvatar != nil {
            matchedUsersAvatar.image = chat.secondChattersAvatar!
        }
        
        self.chatID = chat.chatID
        if chat.latestMessageSenderID == chat.currentUsersID {
            self.backgroundColor = UIColor.white
        } else {
            if chat.read == false {
                self.backgroundColor = UIColor(red: 228/240, green: 240/255, blue: 255/255, alpha: 1.0)
            }
            
        }
        matchedUsersName.text = chat.secondChattersName
        if chat.latestMessageTimestamp != nil {
        timestampConverter(timestamp: chat.latestMessageTimestamp!)
        }
        if let lastMessageTimeStamp = newTimestamp {
            latestMessageTimestamp.text = "\(lastMessageTimeStamp)"
        }
        if let lastMessage = chat.latestMessage {
            latestMessage.text = lastMessage
        } else {
            latestMessage.text = "Send a new message to \(chat.secondChattersName!)!"
        }
        if latestMessage.text == "" || latestMessage.text == nil{
            latestMessage.text = "Send a new message to \(chat.secondChattersName!)!"
        }
        
        if let newValues = updatedValues {
            
            
            if let read = newValues["read"] as? Bool {
            if (read) == false && chat.latestMessageSenderID != chat.currentUsersID{
            self.backgroundColor = UIColor(red: 228/240, green: 240/255, blue: 255/255, alpha: 1.0)
            } else if (read) == true && chat.latestMessageSenderID != chat.currentUsersID {
                self.backgroundColor = UIColor.white
            }
            }
            latestMessage.text = newValues["latestMessage"] as? String
            if latestMessage.text == "" || latestMessage.text == nil{
                latestMessage.text = "Send a new message to \(chat.secondChattersName!)!"
            }
            if let timestampReceived = newValues["timestamp"] as? String {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            let theTimestamp = dateFormatter.date(from: timestampReceived)
            timestampConverter(timestamp: theTimestamp!)
            if let time = newTimestamp {
            latestMessageTimestamp.text = "\(time)"
            }
            }
        }
        
    }
    
    func timestampConverter(timestamp: Date) {
        let timeSince = Date().timeIntervalSince(timestamp)
        
        if timeSince > 86400 {
            let localizedDate = DateFormatter.localizedString(from: timestamp, dateStyle: DateFormatter.Style.short, timeStyle: DateFormatter.Style.short)
            newTimestamp = localizedDate
            
        } else {
            let localizedDate = DateFormatter.localizedString(from: timestamp, dateStyle: DateFormatter.Style.none, timeStyle: DateFormatter.Style.short)
            newTimestamp = localizedDate
        }
    }
    
    func updateView(chat: Chat) {
        // Usable later for change in last message, can be called from MyChatsViewController viewDidLoad. This function might be deleted later on if not to different from setupView.
    }
    
//    func timeSince(timestamp: TimeInterval) -> Double {
//        let since = NSDate()
//        var rounded = 0
//        let theTime = Date(timeIntervalSince1970: timestamp)
//        var compare = since.timeIntervalSince(theTime)
//        
//        if compare > 3600 {
//            compare = (compare / 60) / 60
//            timeSinceLblText = "hours ago"
//            rounded += 1
//        }
//        if compare > 24 && rounded == 1 {
//            compare = compare / 24
//            timeSinceLblText = "days ago"
//        }
//        if compare < (60 * 1) && rounded < 1 {
//            timeSinceLblText = "Just now"
//        }
//        if compare < 3600 && compare > (60 * 2) {
//            compare = compare / 60
//            timeSinceLblText = "minutes ago"
//            rounded += 1
//        }
//        compare.round()
//        return Double(compare)
//    }

}
