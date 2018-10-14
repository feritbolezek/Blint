//
//  Message.swift
//  Blint
//
//  Created by Ferit Bölezek on 08/05/17.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import Foundation

class Message {
    
    private var _message: String?
    private var _name: String?
    private var _time: Date?
    private var _timeEpoch: TimeInterval?
    private var _sender: String?
    private var _readableBySender: Bool?
    private var _readableByReceiver: Bool?
    
    var message: String {
        return _message!
    }
    var sender: String {
        return _sender!
    }
    var time: Date {
        return _time!
    }
    var timeEpoch: TimeInterval {
        return _timeEpoch!
    }
    var name: String {
        return _name!
    }
    var readableBySender: Bool {
        return _readableBySender!
    }
    var readableByReceiver: Bool {
        get {
            return _readableByReceiver!
        } set {
            _readableByReceiver = newValue
        }
    }
    
    
    init(message: String, name: String, time: Date, senderID: String, timeEpoch: TimeInterval, readbleBySender: Bool, readableByReceiver: Bool) {
        self._message = message
        self._name = name
        self._time = time
        self._timeEpoch = timeEpoch
        self._sender = senderID
        self._readableBySender = readbleBySender
        self._readableByReceiver = readableByReceiver
    }
    
    
}
