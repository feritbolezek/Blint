//
//  CameraViewDelegate.swift
//  Blint
//
//  Created by Ferit Bölezek on 2017-06-23.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import Foundation
import UIKit

protocol CameraViewDelegate: class {
    func newPhotoChosen(theImage: UIImage)
}
