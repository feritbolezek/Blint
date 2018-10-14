//
//  CustomUIViewStylings.swift
//  Blint
//
//  Created by Ferit Bölezek on 08/05/17.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import UIKit

@IBDesignable class CustomUIViewStylings: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
    
    @IBInspectable var blurEffect: Bool = false {
        didSet{
            if blurEffect {
                addBlurEffect()
            }
        }
    }
    
    
    @IBInspectable var gradientBackground: Bool = false {
        didSet{
            if gradientBackground {
                addBlintGradient()
            }
        }
    }
    
    @IBInspectable var darkBlur: Bool = false {
        didSet {
            
        }
    }
    
    func addBlurEffect() {
        self.backgroundColor = UIColor.clear
        var blurEffect: UIBlurEffect!
        if darkBlur {
            blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        } else {
            blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        }
        
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.frame = bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        insertSubview(blurEffectView, at: 0)
        
    }
    
    func addVibrancyEffect() {
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
        let vibrancy = UIVibrancyEffect(blurEffect: blurEffect)
        let blurEffectView = UIVisualEffectView(effect: vibrancy)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(blurEffectView, at: 0)
        
    }
    func addBlintGradient() {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = [redColor.cgColor, UIColor.purple.cgColor]
        
        gradientLayer.locations = [0.0,1.0]

        let rectForGradient = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: frame.height)
        gradientLayer.frame = rectForGradient

        self.layer.insertSublayer(gradientLayer, at: 0)

    }

}
