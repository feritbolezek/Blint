//
//  ButtonStylings.swift
//  Blint
//
//  Created by Ferit Bölezek on 17/04/17.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import UIKit

enum ContentAlignments: String {
    case center = "center"
    case left = "left"
}

@IBDesignable class ButtonStylings: UIButton {

    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    @IBInspectable var borderRadius: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = borderRadius
        }
    }
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    @IBInspectable var alignment: String = "center" {
        didSet {
            if alignment == ContentAlignments.left.rawValue.lowercased() {
                self.contentHorizontalAlignment = .left
                self.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
            } else {
                self.contentHorizontalAlignment = .center
            }
            
        }
    }
    

}
