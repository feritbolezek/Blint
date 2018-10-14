//
//  MessagingViewController.swift
//  Blint
//
//  Created by Ferit Bölezek on 09/05/17.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import UIKit

class MessagingViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextViewDelegate, MoreViewDelegate, MatchesAndChatServiceDelegate {

    @IBOutlet weak var messagingCollectionView: UICollectionView!
    
    @IBOutlet weak var textEnterViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var messageTextView: TextViewStylings!

    @IBOutlet weak var titleNameLabel: UILabel!
    
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!

    @IBOutlet weak var bottomView: CustomUIViewStylings!
    
    @IBOutlet weak var messageTextViewHeight: NSLayoutConstraint!
    
    var chat: Chat!
    
    var messages = [Message]()
    
    weak var delegate: MessagingDelegate?
    
    var matchesAndChats: MatchesAndChatService!
    
    var moreOptionsView: MoreOptionsView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        matchesAndChats.delegate = self
        titleNameLabel.text = chat.secondChattersName
        matchesAndChats.loadInMessages(chat: chat) { (messagesLoaded) in
            self.messages = messagesLoaded
            self.messagingCollectionView.reloadData()
            let cellCount = self.messages.count
            self.messagingCollectionView.scrollToItem(at: IndexPath(item: cellCount - 1, section: 0), at: UICollectionViewScrollPosition.top, animated: true)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFunctions), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(selectedRange), name: .UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFunctions), name: .UIKeyboardWillHide, object: nil)
        
    }
    
    func selectedRange(notification: NSNotification) {
        let endPosition = messageTextView.endOfDocument
        messageTextView.selectedTextRange = messageTextView.textRange(from: endPosition, to: endPosition)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    func textViewDidChange(_ textView: UITextView) {
        changeToContentSize()
        adjustConstraintsForKeyboard()
    }
    
    func changeToContentSize() {
        let contentSize = self.messageTextView.sizeThatFits(messageTextView.bounds.size)
        messageTextView.frame.size.height = contentSize.height
        messageTextViewHeight.constant = contentSize.height
        
        
        bottomView.frame.size.height = contentSize.height + 10
        bottomViewHeight.constant = contentSize.height + 10
        
    }

    func keyboardFunctions(notification: NSNotification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame: NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
        if notification.name == .UIKeyboardWillShow {
            self.textEnterViewBottomConstraint.constant = keyboardHeight
            changeToContentSize()
        } else {
            self.textEnterViewBottomConstraint.constant = 0
            bottomView.frame.size.height = 50
            bottomViewHeight.constant = 50
        }
        adjustConstraintsForKeyboard()
    }
    func userPhotoWasDownloaded(chat: Chat, theImage: UIImage) {
        if chat.chatID == chat.chatID {
            chat.secondChattersAvatar = theImage
            for cell in messagingCollectionView.visibleCells {
                if let cellGrabbed = cell as? MessageCell {
                    cellGrabbed.profileImageView.image = theImage
                }
            }
            messagingCollectionView.reloadData()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        view.endEditing(true)
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        
//        let size = CGSize(width: 250, height: 1000)
//        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
//        let estimatedFrame = NSString(string: messageTextView.text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.init(name: "Avenir", size: 18)], context: nil)
//        messageViewBottomHeight.constant = estimatedFrame.height + 10
        return true
    }
    
    
    func adjustConstraintsForKeyboard() {
        UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: { 
            self.view.layoutIfNeeded()
        }) { (completed) in
            
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
            return messages.count
        
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let messageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "messageCell", for: indexPath) as! MessageCell
        if chat.secondChattersAvatar != nil {
            messageCell.setupView(message: messages[indexPath.row], imageSet: chat.secondChattersAvatar!)
        } else {
            messageCell.setupView(message: messages[indexPath.row])
        }
        let messageText = messages[indexPath.item].message
        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.init(name: "Avenir", size: 18)], context: nil)
        if messages[indexPath.item].sender != chat.currentUsersID {
        messageCell.messageTextView.frame = CGRect(x: 56, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 10)
        messageCell.textBubbleView.frame = CGRect(x: 48, y: 0, width: estimatedFrame.width + 16 + 8, height: estimatedFrame.height + 10)
            
            messageCell.profileImageView.isHidden = false
            
             messageCell.textBubbleView.backgroundColor = UIColor(white: 0.95, alpha: 1.0)

            messageCell.messageTextView.textColor = UIColor.black
            
        } else {
            messageCell.messageTextView.frame = CGRect(x: view.frame.width - estimatedFrame.width - 16 - 16, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 10)
            messageCell.textBubbleView.frame = CGRect(x: view.frame.width - estimatedFrame.width - 16 - 8 - 16, y: 0, width: estimatedFrame.width + 16 + 8, height: estimatedFrame.height + 10)
            
            messageCell.profileImageView.isHidden = true
            
            messageCell.textBubbleView.backgroundColor = redColor
            messageCell.messageTextView.textColor = UIColor.white
        }
        return messageCell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 48, left: 0, bottom: 100, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let messageText = messages[indexPath.item].message
        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.init(name: "Avenir", size: 18)], context: nil)
        return CGSize(width: view.frame.width, height: estimatedFrame.height + 10)
    }
    
    @IBAction func sendTapped(_ sender: Any) {
        if messageTextView.text != "" {
            let newMessage = Message(message: messageTextView.text, name: chat.currentUsersName, time: Date.init(), senderID: chat.currentUsersID, timeEpoch: Date().timeIntervalSince1970, readbleBySender: true, readableByReceiver: true)
            matchesAndChats.sendMessage(chat: chat, messageToSend: newMessage, completion: { (response) in
                if response == .success {
                    self.messageTextView.text = ""
                    self.messagingCollectionView.reloadData()
                }
            })
        }
        
    }
    
    @IBAction func moreTapped(_ sender: Any) {
        if moreOptionsView == nil {
            if UIDevice.current.userInterfaceIdiom == .pad {
                moreOptionsView = MoreOptionsView(frame: CGRect(x: (UIScreen.main.bounds.width / 2) - 250, y: UIScreen.main.bounds.height, width: 500, height: 360))
            } else {
                moreOptionsView = MoreOptionsView(frame: CGRect(x: (UIScreen.main.bounds.width / 2) - 150, y: UIScreen.main.bounds.height, width: 300, height: 240))
            }
            moreOptionsView?.delegate = self
        if chat.secondChatterIsBlocked != nil {
            moreOptionsView?.blockButton.setTitle("Unblock", for: .normal)
        } else {
            moreOptionsView?.blockButton.setTitle("Block", for: .normal)
        }
        moreOptionsView?.moreOptionsNameTitle.text = chat.secondChattersName
        self.view.addSubview(moreOptionsView!)
        UIView.animate(withDuration: 0.5) {
            if UIDevice.current.userInterfaceIdiom == .pad {
            self.moreOptionsView?.center.y -= 440
            } else {
                self.moreOptionsView?.center.y -= 320
            }
        }
     }
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    /* More View stuff */
    func reportUserTapped() {
        performSegue(withIdentifier: "reportUser", sender: nil)
        self.moreOptionsView?.removeFromSuperview()
        self.moreOptionsView = nil
    }
    func blockUserTapped() {
        if chat.secondChatterIsBlocked != nil {
        matchesAndChats.unblockUser(chatID: chat.chatID!, userToUnblock: chat.secondChattersID!)
            moreOptionsView?.blockButton.setTitle("Block", for: .normal)
            chat.secondChatterIsBlocked = nil
        } else {
        matchesAndChats.blockUser(chatID: chat.chatID!, userToBlockID: chat.secondChattersID!)
            moreOptionsView?.blockButton.setTitle("Unblock", for: .normal)
            chat.secondChatterIsBlocked = true
        }
    }
    func cancelTapped() {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseOut, animations: {
            if UIDevice.current.userInterfaceIdiom == .pad {
            self.moreOptionsView?.center.y += 440
            } else {
                 self.moreOptionsView?.center.y += 320
            }
        }) { (completed) in
            self.moreOptionsView?.removeFromSuperview()
            self.moreOptionsView = nil
        }
    }
    /* More View stuff */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "reportUser" {
            let dest = segue.destination as! ReportUserViewController
            dest.reportedUsersID = chat.secondChattersID
            dest.reportedUsersName = chat.secondChattersName!
            dest.userReportingName = chat.currentUsersName
            dest.userReportingID = chat.currentUsersID
            dest.chatID = chat.chatID
            dest.reportingFromChat = true
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        delegate?.viewDismissed(chat: self.chat, messages: self.messages)
    }
    
    func userWasUnblocked(chat: Chat, userUnBlockedID: String) {
        if self.chat.chatID == chat.chatID {
            if userUnBlockedID == chat.secondChattersID {
            self.chat.secondChatterIsBlocked = nil
            } else {
                self.chat.currentUserIsBlocked = nil
            }
        }
    }
    func userWasBlocked(chat: Chat, userBlockedID: String) {
        if self.chat.chatID == chat.chatID {
            if userBlockedID == chat.secondChattersID! {
                self.chat.secondChatterIsBlocked = true
            } else {
                self.chat.currentUserIsBlocked = true
            }
        }
    }

    
    
}
