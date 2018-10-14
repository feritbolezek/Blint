//
//  MoreViewDelegate.swift
//  Blint
//
//  Created by Ferit Bölezek on 2017-06-22.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import Foundation

protocol MoreViewDelegate: class {
    func reportUserTapped()
    func blockUserTapped()
    func cancelTapped()
}
