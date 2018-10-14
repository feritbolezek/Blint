//
//  MessageCell.swift
//  Blint
//
//  Created by Ferit Bölezek on 08/05/17.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import UIKit

class MessageCell: UICollectionViewCell {
    
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    func setupView(message: Message, imageSet: UIImage? = nil) {
        messageTextView.text = message.message
        self.insertSubview(textBubbleView, at: 0)
        profileImageView.layer.cornerRadius = 16.0
        profileImageView.layer.masksToBounds = true
        if imageSet != nil {
            profileImageView.image = imageSet!
        }
    }
    
    let textBubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(white: 0.95, alpha: 1.0)
        view.layer.cornerRadius = 15.0
        view.layer.masksToBounds = true
        return view
    }()
    
    
    
}
