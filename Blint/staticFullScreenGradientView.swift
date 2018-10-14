//
//  staticFullScreenGradientView.swift
//  Blint
//
//  Created by Ferit Bölezek on 2017-06-16.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import UIKit

class staticFullScreenGradientView: UIView {

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
    
    func addBlurEffect() {
        self.backgroundColor = UIColor.clear
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
        
        blurEffectView.frame = bounds
        vibrancyEffectView.frame = bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        vibrancyEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(blurEffectView, at: 0)
        insertSubview(vibrancyEffectView, at: 0)
        
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
        
        let rectForGradient = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        gradientLayer.frame = rectForGradient
        
        self.layer.insertSublayer(gradientLayer, at: 0)
        
    }

}
