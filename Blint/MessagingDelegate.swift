//
//  MessagingDelegate.swift
//  Blint
//
//  Created by Ferit Bölezek on 2017-06-18.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import Foundation

protocol MessagingDelegate: class {
    func viewDismissed(chat: Chat, messages: [Message])
}
