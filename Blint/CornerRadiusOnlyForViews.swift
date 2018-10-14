//
//  CornerRadiusOnlyForViews.swift
//  Blint
//
//  Created by Ferit Bölezek on 17/04/17.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import UIKit

@IBDesignable class CornerRadiusOnlyForViews: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
}
