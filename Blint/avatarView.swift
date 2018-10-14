//
//  avatarView.swift
//  Blint
//
//  Created by Ferit Bölezek on 05/05/17.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import UIKit

@IBDesignable class avatarView: UIImageView {

    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        
        didSet {
                self.layer.cornerRadius = cornerRadius
        }
        
    }
    @IBInspectable var doubleCornerRadius: Bool = false {
        didSet {
            if doubleCornerRadius == true {
                let curr = self.layer.cornerRadius
                if UIDevice.current.userInterfaceIdiom == .pad {
                self.layer.cornerRadius = curr * 2
                } else {
                    self.layer.cornerRadius = curr
                }
            } else {
                self.layer.cornerRadius = cornerRadius
            }
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
