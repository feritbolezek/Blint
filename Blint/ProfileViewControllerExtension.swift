//
//  ProfileViewControllerExtension.swift
//  Blint
//
//  Created by Ferit Bölezek on 26/05/17.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import UIKit

extension ProfileViewController {   // Animations for the top view in the profile view controller
    
    func dragDown(sender: UIPanGestureRecognizer) {
        
        matchView.frame.origin.y = matchView.frame.origin.y + sender.velocity(in: self.view).y * 0.02
        
        if sender.state == .ended {
            
            if sender.location(in: self.view).y > UIScreen.main.bounds.height / 2 {
                if matchView.frame.origin.y >= UIScreen.main.bounds.height / 2 {
                    animateUp()
                } else {
                  animateDown()
                }
                
            } else {
                animateUp()
                
            }
        }
        
    }
    
    func animateDown() {
        if dynamicAnimator?.behaviors != nil {
            dynamicAnimator?.removeAllBehaviors()
        }
        gravityBehaviour = UIGravityBehavior(items: [matchView])
        gravityBehaviour?.gravityDirection = CGVector(dx: 0, dy: 10.0)
        gravityBehaviour?.magnitude = 1
        
        collisionBehaviour = UICollisionBehavior(items: [matchView])
        collisionBehaviour?.removeAllBoundaries()
        collisionBehaviour?.addBoundary(withIdentifier: "bottomBoundry" as NSCopying, from: CGPoint(x:0, y:self.view.frame.maxY + 2), to: CGPoint(x:UIScreen.main.bounds.width, y:self.view.frame.maxY + 2))
        collisionBehaviour?.collisionDelegate = self
        
        dynamicAnimator?.addBehavior(collisionBehaviour!)
        dynamicAnimator?.addBehavior(gravityBehaviour!)
        
        
    }
    func animateUp() {
        if dynamicAnimator?.behaviors != nil {
            dynamicAnimator?.removeAllBehaviors()
        }
        gravityBehaviour = UIGravityBehavior(items: [matchView])
        gravityBehaviour?.gravityDirection = CGVector(dx: 0, dy: -10.0)
        gravityBehaviour?.magnitude = 1
        
        
        collisionBehaviour = UICollisionBehavior(items: [matchView])
        collisionBehaviour?.removeAllBoundaries()
        collisionBehaviour?.addBoundary(withIdentifier: "topBoundary" as NSCopying, from: CGPoint(x:0, y:startingPos - matchView.bounds.height), to: CGPoint(x:UIScreen.main.bounds.width, y: startingPos - matchView.bounds.height))
        collisionBehaviour?.collisionDelegate = self
        
        dynamicAnimator?.addBehavior(collisionBehaviour!)
        dynamicAnimator?.addBehavior(gravityBehaviour!)
    }
    func collisionBehavior(_ behavior: UICollisionBehavior, endedContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?) {
        if let ident = identifier as? String {
            if ident == "bottomBoundry" {
                NotificationCenter.default.post(name: NSNotification.Name("containerAtBottom"), object: nil)
                generator.impactOccurred()
            }
        }
    }
    

}
