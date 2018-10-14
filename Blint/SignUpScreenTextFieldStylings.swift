//
//  SignUpScreenTextFieldStylings.swift
//  Blint
//
//  Created by Ferit Bölezek on 18/04/17.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import UIKit

@IBDesignable class SignUpScreenTextFieldStylings: UITextField, UITextFieldDelegate {

    let padding = UIEdgeInsetsMake(0, 5, 0, 0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)
        delegate = self
        
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
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
    
    

}
