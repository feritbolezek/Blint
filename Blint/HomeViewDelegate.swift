//
//  HomeViewDelegate.swift
//  Blint
//
//  Created by Ferit Bölezek on 2017-06-12.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import Foundation
import UIKit

protocol HomeViewDelegate: class {
    func displayUserInfo(matches: [Matches])
    func noMatches()
    func likeTapped()
    func nopeTapped()
    func profileImageReadyToDisplay(match: Matches, theImage: UIImage)
}
