//
//  TextViewStylings.swift
//  Blint
//
//  Created by Ferit Bölezek on 08/05/17.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import UIKit

@IBDesignable class TextViewStylings: UITextView {

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
    
    @IBInspectable var shadowOpacity: Float = 0.0 {
        didSet {
            self.layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable var shadowColor: UIColor = UIColor.black {
        didSet {
            self.layer.shadowColor = shadowColor.cgColor
        }
    }
    
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0, height: 0) {
        didSet {
            self.layer.shadowOffset = shadowOffset
            
        }
    }
    @IBInspectable var shadowRadius: CGFloat = 0.0 {
        didSet {
            self.layer.shadowRadius = shadowRadius
        }
    }
}
