//
//  MyChatsViewController.swift
//  Blint
//
//  Created by Ferit Bölezek on 2017-06-17.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import UIKit

class MyChatsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MessagingDelegate, MatchesAndChatServiceDelegate {
    
    var chatsToDisplay = [Chat]()
    
    var currentUser: BlintUser!
    
    var previousChat: Chat!
    
    var previousMessages: [Message]!
    
    let matchesAndChats = MatchesAndChatService()
    
    @IBOutlet weak var chatsTableView: UITableView!
    
    var test = false
    override func viewDidLoad() {
        super.viewDidLoad()
        matchesAndChats.delegate = self
        matchesAndChats.checkForMatches(currentUser: currentUser) { (response, chatNodesFound) in
            if response == .success {
                self.matchesAndChats.loadInChats(chatNodes: chatNodesFound!, completion: { (chats) in
                    self.chatsToDisplay = chats
                    for chat in chats {
                        self.matchesAndChats.checkForBlocks(chat: chat)
                        self.matchesAndChats.checkForBlockRemovals(chat: chat)
                    }
                    self.chatsTableView.reloadData()
                    if !self.test {
                        self.checkForLatestMessages()
                        self.test = true
                    }
                })
            }
        }
        let matchID = currentUser.userInformation["matchesReference"] as! String
        matchesAndChats.newMatchAndChat(matchReferenceID: matchID) { (chatReceived) in
            self.chatsToDisplay.append(chatReceived[0])
            self.matchesAndChats.checkForBlocks(chat: chatReceived[0])
            self.matchesAndChats.checkForBlockRemovals(chat: chatReceived[0])
            self.chatsTableView.reloadData()
        }
        
    }
    func checkForLatestMessages() {
        for chat in self.chatsToDisplay {
            self.matchesAndChats.observeLatestMessageChanges(chat: chat, completion: { (changesDictionary) in
                for cell in self.chatsTableView.visibleCells {
                    if (cell as! MatchedMessageCell).chatID == chat.chatID {
                        let updatedCell = cell as! MatchedMessageCell
                        updatedCell.setupView(chat: chat, updatedValues: changesDictionary)
                    }
                }
            })
        }
        
    }
    
    
    func userWasUnblocked(chat: Chat, userUnBlockedID: String) {
        for chatsDisplaying in chatsToDisplay {
            if chatsDisplaying.chatID == chat.chatID {
                if userUnBlockedID == chatsDisplaying.secondChattersID {
                chatsDisplaying.secondChatterIsBlocked = nil
                } else if userUnBlockedID == chatsDisplaying.currentUsersID {
                    chatsDisplaying.currentUserIsBlocked = nil
                }
            }
        }
    }
    
    func userWasBlocked(chat: Chat, userBlockedID: String) {
        for chatsDisplaying in chatsToDisplay {
            if chatsDisplaying.chatID == chat.chatID {
                if userBlockedID == chatsDisplaying.secondChattersID {
                    chatsDisplaying.secondChatterIsBlocked = true
                } else if userBlockedID == chatsDisplaying.currentUsersID {
                    chatsDisplaying.currentUserIsBlocked = true
                }
            }
        }
    }
    
    func userPhotoWasDownloaded(chat: Chat, theImage: UIImage) {
        for chatDisplaying in chatsToDisplay {
            if chatDisplaying.chatID == chat.chatID {
                
                chatDisplaying.secondChattersAvatar = theImage
                let theIndex = chatsToDisplay.index(of: chatDisplaying)
                let cellToUpdate = self.chatsTableView.cellForRow(at: IndexPath(row: theIndex!, section: 0)) as! MatchedMessageCell
                
                cellToUpdate.matchedUsersAvatar.image = theImage
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "matchedMessageCell", for: indexPath) as? MatchedMessageCell {
            cell.setupView(chat: chatsToDisplay[indexPath.row])
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatsToDisplay.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellAtIndexPath = chatsTableView.cellForRow(at: indexPath) as! MatchedMessageCell
        if chatsToDisplay[indexPath.row].read == false && chatsToDisplay[indexPath.row].latestMessageSenderID != chatsToDisplay[indexPath.row].currentUsersID {
            matchesAndChats.updateLastMessageReadStatus(chatID: chatsToDisplay[indexPath.row].chatID)
            cellAtIndexPath.backgroundColor = UIColor.white
        }
        performSegue(withIdentifier: "toMessage", sender: chatsToDisplay[indexPath.row])
    }
    func viewDismissed(chat: Chat, messages: [Message]) {
        self.previousChat = chat
        self.previousMessages = messages
        if let indexPath = self.chatsTableView.indexPathForSelectedRow {
        let selectedCell = self.chatsTableView.cellForRow(at: indexPath) as! MatchedMessageCell
            if selectedCell.matchedUsersAvatar.image == UIImage(named: "NoPhoto") {
                if chat.secondChattersAvatar != nil {
                    selectedCell.matchedUsersAvatar.image = chat.secondChattersAvatar
                }
            }
        self.chatsTableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 125
        } else {
            return 85
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? MessagingViewController {
            dest.chat = sender as! Chat
            dest.matchesAndChats = self.matchesAndChats
            dest.delegate = self
        }
    }
}
