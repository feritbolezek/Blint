//
//  MatchesAndChatService.swift
//  Blint
//
//  Created by Ferit Bölezek on 2017-06-17.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import Foundation
import Firebase

enum DataResponse {
    
    case failed
    case success
    case noData
}

class MatchesAndChatService {

    private var chatNodes: [(userID: String, chatID: String)]?
    private var chats: [Chat]?
    private var newChats: [Chat]?
    private var chatters: Dictionary<String,Any>?
    private var chatDetails: Dictionary<String,Any>?
    
    weak var delegate: MatchesAndChatServiceDelegate?
    
    /// Load in chats can be called in this functions completion handler if 2nd param  of completion handler is not nil.
    func checkForMatches(currentUser: BlintUser, completion: @escaping (_ response: DataResponse, _ chats: [(String,String)]?) -> ()) {
        
        chatNodes = [(userID: String, chatID: String)]()
        let matchesRef = currentUser.userInformation["matchesReference"] as! String
        DataService.standard.MATCHES_REF.child(matchesRef).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.value is NSNull {
                completion(.noData, nil)
            } else {
                
                let chatsFound = snapshot.children.allObjects as! [DataSnapshot]
                for chat in chatsFound {
                    
                    let userIDFound = chat.key
                    let chatIDFound = chat.value as! String

                    self.chatNodes?.append((userID: userIDFound, chatID: chatIDFound))
                }
                
                completion(.success, self.chatNodes)
            }
        })
    }
    
    func loadInChats(chatNodes: [(String,String)], completion: @escaping (_ chats: [Chat]) -> ()) {
        chats = [Chat]()
        self.chatters = Dictionary<String,Any>()
        self.chatDetails = Dictionary<String,Any>()
        let dispatchGroup = DispatchGroup()
        for chat in chatNodes {
            dispatchGroup.enter()
            DataService.standard.CHATS_REF.child(chat.1).child("chatDetails").observeSingleEvent(of: .value, with: { (snapshot) in
                
                let snaps = snapshot.children.allObjects as! [DataSnapshot]
                
                for details in snaps {
                    
                    if let chatters = details.value as? Dictionary<String, Any> {
                        self.chatters = chatters
                    } else {
                        self.chatDetails?.updateValue(details.value!, forKey: details.key)
                    }
                    
                }
                let newChat = Chat(chatID: chat.1, chatDetails: self.chatDetails!, chatters: self.chatters!)
                self.checkForProfilePhoto(theChat: newChat)
                self.chats!.append(newChat)
                self.chatDetails?.removeAll()
                dispatchGroup.leave()
            })
            
        }
        dispatchGroup.notify(queue: .main) { 
            completion(self.chats!)
        }
        
    }
    
    private func checkForProfilePhoto(theChat: Chat) {
    DataService.standard.USERS_REF.child(theChat.secondChattersID).child("userInformation").child("profilePhotoID").observeSingleEvent(of: .value, with: { (snapshot) in
        if snapshot.value is NSNull {
            // No profile image.
            print("NO PROFILE IMAGE FOUND")
        } else {
            let profilePhotoID = snapshot.value as! String
            DataService.standard.PROFILE_PHOTOS_REF.child(profilePhotoID).getData(maxSize: 1024*1000, completion: { (data, error) in
                if error == nil {
                    let profileImage = UIImage(data: data!)
                    self.delegate?.userPhotoWasDownloaded!(chat: theChat, theImage: profileImage!)
                }
            })
        }
        })
    }
    
    private func downloadProfilePhotosForWorthyMatches(user: BlintUser, profilePhotoID: String) {
        DataService.standard.PROFILE_PHOTOS_REF.child(profilePhotoID).getData(maxSize: 1024 * 100) { (data, error) in
            if error != nil {
                // Display standard photo, downloading image failed.
            } else {
                let profileImage = UIImage(data: data!)
               // match.usersProfileImage = profileImage!
                //self.delegate?.readyToDisplayProfilePhotoFor(match: match, profilePhoto: profileImage!)
            }
        }
    }
    
    
    func newMatchAndChat(matchReferenceID: String, completion: @escaping (_ chats: [Chat]) -> ()) {
        DataService.standard.MATCHES_REF.child(matchReferenceID).observe(.childAdded, with: { (snapshot) in
            self.newChats = [Chat]()
            let newID = snapshot.value as! String
            
            DataService.standard.CHATS_REF.child(newID).child("chatDetails").observe(.childAdded, with: { (snapshot) in
                if let snap = snapshot.value as? Dictionary<String,Any> {
                 let newChat = Chat(chatID: newID, chatDetails: snap, chatters: snap)
                 self.newChats?.append(newChat)
                    completion([newChat])
                    
                }
            })
        })
        
        
    }
    
    
    func loadInMessages(chat: Chat, completion: @escaping ([Message]) -> ()) {
        var messagesToSendBack = [Message]()
        DataService.standard.CHATS_REF.child(chat.chatID).child("messages").observe(.childAdded, with: { (snapshot) in
            if snapshot.value is NSNull {
                // No messages.
            } else {
                let messages = snapshot.children.allObjects as! [DataSnapshot]
                
             //   for message in messages {
                
                    if let messageDict = snapshot.value as? Dictionary<String,Any> {
                        
                      let messeageExtract = self.extractMessageValues(messageDictionary: messageDict)
                        if messeageExtract.readableByReceiver && messeageExtract.sender == chat.secondChattersID {
                        messagesToSendBack.append(messeageExtract)
                        }
                        if messeageExtract.readableByReceiver && chat.currentUsersID == messeageExtract.sender {
                            messagesToSendBack.append(messeageExtract)
                        }
                        if !messeageExtract.readableByReceiver && chat.currentUsersID == messeageExtract.sender {
                            messagesToSendBack.append(messeageExtract)
                        }
                    }
                    
              //  }
                
            }
           completion(messagesToSendBack)
        })
        
    }
    
    private func extractMessageValues(messageDictionary: Dictionary<String,Any>) -> Message {
        let extractedMessage = messageDictionary["message"] as! String
        let extracedReadableByReceiver = messageDictionary["readableByReceiver"] as! Bool
        let extractedReadableBySender = messageDictionary["readableBySender"] as! Bool
        let extractedSender = messageDictionary["sender"] as! String
        let extractedTimestamp = messageDictionary["timestamp"] as! String
        let extractedTimestampEpoch = messageDictionary["timestampEpoch"] as! TimeInterval
        let extractedSendersName = messageDictionary["sendersName"] as! String
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let theTimestamp = dateFormatter.date(from: extractedTimestamp)
        
        return Message(message: extractedMessage, name: extractedSendersName, time: theTimestamp!, senderID: extractedSender, timeEpoch: extractedTimestampEpoch, readbleBySender: extractedReadableBySender, readableByReceiver: extracedReadableByReceiver)
    }
    
    func sendMessage(chat: Chat, messageToSend: Message, completion: @escaping (_ response: DataResponse) -> ()) {
        if chat.secondChatterIsBlocked != nil || chat.currentUserIsBlocked != nil {
            messageToSend.readableByReceiver = false
        }
        DataService.standard.CHATS_REF.child(chat.chatID).child("messages").childByAutoId().updateChildValues(["message" : messageToSend.message, "sender" : chat.currentUsersID, "sendersName" : chat.currentUsersName , "readableBySender" : messageToSend.readableBySender, "readableByReceiver" : messageToSend.readableByReceiver, "timestamp" : String(describing: messageToSend.time), "timestampEpoch" : messageToSend.timeEpoch]) { (error, reference) in
            if error == nil {
                completion(.success)
                self.setLatestMessage(chat: chat, messageToSend: messageToSend)
            } else {
                completion(.failed)
             // Could not execute.
            }
        }
        
    }
    func checkForBlocks(chat: Chat) {
        DataService.standard.CHATS_REF.child(chat.chatID!).child("chatDetails").observe(.childAdded, with: { (snapshot) in
            if snapshot.key.contains("USERBLOCKED_") {
                
                if snapshot.key == "USERBLOCKED_\(chat.secondChattersID!)" {
                    self.delegate?.userWasBlocked!(chat: chat, userBlockedID: chat.secondChattersID!)
                    
                } else if snapshot.key == "USERBLOCKED_\(chat.currentUsersID)" {
                    self.delegate?.userWasBlocked!(chat: chat, userBlockedID: chat.currentUsersID)
                }
            }
        })
    }
    
    func checkForBlockRemovals(chat: Chat) {
        DataService.standard.CHATS_REF.child(chat.chatID!).child("chatDetails").observe(.childRemoved, with: { (snapshot) in
            if snapshot.key.contains("USERBLOCKED_") {
                if snapshot.key == "USERBLOCKED_\(chat.secondChattersID!)" {
                    self.delegate?.userWasUnblocked!(chat: chat, userUnBlockedID: chat.secondChattersID!)
                } else if snapshot.key == "USERBLOCKED_\(chat.currentUsersID)" {
                    self.delegate?.userWasUnblocked!(chat: chat, userUnBlockedID: chat.currentUsersID)
                }
            }
        })
    }
    
    private func setLatestMessage(chat: Chat, messageToSend: Message) {
        DataService.standard.CHATS_REF.child(chat.chatID).child("chatDetails").updateChildValues(["latestMessage" : messageToSend.message, "senderID" : messageToSend.sender, "read" : false, "timestamp" : String(describing: messageToSend.time)]) { (error, reference) in
            if error == nil {
                // success
            }
        }
    }
    
    func deleteMessage() {
        
        
    }
    
    func updateLastMessageReadStatus(chatID: String) {
        DataService.standard.CHATS_REF.child(chatID).child("chatDetails").child("read").setValue(true)
    }
    
    func observeLatestMessageChanges(chat: Chat, completion: @escaping (_ latestMessageDictionary: Dictionary<String,Any>) -> ()) {
        DataService.standard.CHATS_REF.child(chat.chatID).child("chatDetails").observe(.value, with: { (snapshot) in
            if let changes = snapshot.value as? Dictionary<String,Any> {
                completion(changes)
            }
            
        })
        
    }
    
    func blockUser(chatID: String, userToBlockID: String) {
        DataService.standard.CHATS_REF.child(chatID).child("chatDetails").child("USERBLOCKED_\(userToBlockID)").setValue(true)
    }
    
    func unblockUser(chatID: String, userToUnblock: String) {
        DataService.standard.CHATS_REF.child(chatID).child("chatDetails").child("USERBLOCKED_\(userToUnblock)").removeValue()
    }


}
