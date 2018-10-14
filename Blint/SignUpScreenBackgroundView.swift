//
//  SignUpBackgroundView.swift
//  Blint
//
//  Created by Ferit Bölezek on 17/04/17.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import UIKit

class SignUpScreenBackgroundView: UIView {
    
    var startPoint: CGPoint = CGPoint(x: 0.0, y: 0.0)
    var endPoint: CGPoint = CGPoint(x: 1.0, y: 1.0)
    
    let gradientLayer = CAGradientLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layoutView()
        
    }

    override init(frame: CGRect) {
       super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func layoutView() {
        
        gradientLayer.colors = [redColor.cgColor, UIColor.purple.cgColor]
        //gradientLayer.locations = [0.0,1.0]
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint

        gradientLayer.frame = UIScreen.main.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
        
        animateBackgroundPoints()
        animateBackgroundColors()
        
    }
    
    func animateBackgroundPoints() {
        
        let gradientAnimationStart = CABasicAnimation(keyPath: "startPoint")
        gradientAnimationStart.fromValue = startPoint
        gradientAnimationStart.toValue = CGPoint(x: 1.0, y: 0.0)
        gradientAnimationStart.duration = 60.0
        
        let gradientAnimationEnd = CABasicAnimation(keyPath: "endPoint")
        gradientAnimationEnd.fromValue = endPoint
        gradientAnimationEnd.toValue = CGPoint(x: 0.0, y: 1.0)
        gradientAnimationEnd.duration = 60.0
        
        gradientAnimationStart.repeatCount = Float.infinity
        gradientAnimationEnd.repeatCount = Float.infinity
        
        gradientAnimationStart.isRemovedOnCompletion = false
        gradientAnimationEnd.isRemovedOnCompletion = false
        
        gradientAnimationStart.autoreverses = true
        gradientAnimationEnd.autoreverses = true
        
        gradientLayer.add(gradientAnimationStart, forKey: "gradientPosAnimStart")
        gradientLayer.add(gradientAnimationEnd, forKey: "gradientPosAnimEnd")
        
        
        
    }
    
    func animateBackgroundColors() {
        
        let gradientAnimationColor = CABasicAnimation(keyPath: "colors")
        
        gradientAnimationColor.fromValue = [redColor.cgColor, UIColor.purple.cgColor]
        gradientAnimationColor.toValue = [UIColor.black.cgColor, UIColor.purple.cgColor]
        
        gradientAnimationColor.duration = 60.0
        gradientAnimationColor.repeatCount = Float.infinity
        gradientAnimationColor.isRemovedOnCompletion = false
        gradientAnimationColor.autoreverses = true
        
        gradientLayer.add(gradientAnimationColor, forKey: "gradientColorAnim")
    
        
    }

}
