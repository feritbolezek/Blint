//
//  MatchingSystemDelegate.swift
//  Blint
//
//  Created by Ferit Bölezek on 2017-06-12.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import Foundation
import UIKit

protocol MatchingSystemDelegate: class {
    func readyToDisplayMatches(matches: [Matches])
    func noMatchesFound()
    func readyToDisplayProfilePhotoFor(match: Matches, profilePhoto: UIImage)
}
