//
//  TaggyViewDelegate.swift
//  Blint
//
//  Created by Ferit Bölezek on 02/06/17.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import Foundation

protocol TaggyViewDelegate: class {
    func userWishesToSeeMore(informationType: UserInformationType)
}
