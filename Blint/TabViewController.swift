//
//  TabViewController.swift
//  Blint
//
//  Created by Ferit Bölezek on 01/05/17.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase


var profileViewController: UIViewController!

class TabViewController: UIViewController {

    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet var tabButtons: [UIButton]!
    
    @IBOutlet weak var tabBar: UIView!
    
    var expandMenuTapped: UITapGestureRecognizer?
    
    var viewControllers: [UIViewController]!
    
    var selectedIndex: Int = 0
    
    var tabBarAnimated = true
    
    var plusLabel: UILabel!
    
    var currentUser: BlintUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        expandMenuTapped = UITapGestureRecognizer(target: self, action: #selector(expandMenu(sender:)))
        expandMenuTapped?.isEnabled = false
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let homeViewController = storyboard.instantiateViewController(withIdentifier: "Home") as! HomeViewController
        profileViewController = storyboard.instantiateViewController(withIdentifier: "Profile") as! ProfileViewController
        let chatViewController = storyboard.instantiateViewController(withIdentifier: "Chat") as! MyChatsViewController
        let moreViewController = storyboard.instantiateViewController(withIdentifier: "More") as! MoreViewController
        viewControllers = [homeViewController, profileViewController, chatViewController, moreViewController]
        tabBarStartSize()
        tabButtons[selectedIndex].isSelected = true
        tabItemTapped(tabButtons[selectedIndex])
        for tabItem in tabButtons {
            tabItem.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        }
        
        homeViewController.currentUser = self.currentUser
        chatViewController.currentUser = self.currentUser
        moreViewController.currentUser = self.currentUser
    }
    
    func tabBarStartSize() {
        
//        tabBar.frame = CGRect(x: UIScreen.main.bounds.width - 60, y: UIScreen.main.bounds.height - 60, width: 50, height: 50)
//        for button in tabButtons {
//            button.isHidden = true
//        }
//        tabBar.layer.cornerRadius = tabBar.frame.size.width / 2
        tabBar.clipsToBounds = true
        plusLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        plusLabel.text = "+"
        plusLabel.isUserInteractionEnabled = true
        plusLabel.isHidden = true
        plusLabel.font = UIFont(name: "Avenir", size: 40)
        plusLabel.textAlignment = NSTextAlignment.center
        plusLabel.textColor = UIColor.white
        plusLabel.addGestureRecognizer(expandMenuTapped!)
        tabBar.addSubview(plusLabel)
        tabBar.backgroundColor = UIColor.white
        
        
    }
    
    
    
    @IBAction func menuBarSwiped(_ sender: Any) {
        animateTabBar()
        
    }
    
    func expandMenu(sender: UITapGestureRecognizer) {
        animateTabBar()
    }
    
    func animateTabBar() {
        
        if tabBarAnimated == false {
            
            UIView.animate(withDuration: 0.40) {

//                self.plusLabel.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_4))
                let midPoint = CGPoint(x: UIScreen.main.bounds.midX, y: self.tabBar.center.y)
                self.tabBar.center = midPoint
                self.tabBar.backgroundColor = UIColor.white
                //                self.plusLabel.textColor = redColor
                if UIDevice.current.userInterfaceIdiom == .pad {
                    self.tabBar.frame = CGRect(x: 0, y: (UIScreen.main.bounds.maxY - 100), width: UIScreen.main.bounds.width, height: 100)
                } else {
                    self.tabBar.frame = CGRect(x: 0, y: (UIScreen.main.bounds.maxY - 50), width: UIScreen.main.bounds.width, height: 50)
                }
                
                
            }
            
            UIView.animate(withDuration: 0.2, delay: 0.2, options: .curveEaseIn, animations: {
                for button in self.tabButtons {
                    button.alpha = 1.0
                }
            }) { (completed) in
                self.tabBarAnimated = true
                self.plusLabel.isHidden = true
                self.expandMenuTapped?.isEnabled = false
            }
            
            
            
            let cornerRadiusAnimation = CABasicAnimation(keyPath: "cornerRadius")
            cornerRadiusAnimation.toValue = 0.0
            cornerRadiusAnimation.duration = 0.25
            
            cornerRadiusAnimation.isRemovedOnCompletion = false
            cornerRadiusAnimation.fillMode = kCAFillModeForwards
            self.tabBar.layer.add(cornerRadiusAnimation, forKey: "cornerRadiusAnim")
        } else {
            animateTabBarReverse()
        }
        
        
    }
    
    func animateTabBarReverse() {
        self.plusLabel.isHidden = false
        UIView.animate(withDuration: 0.40) {
            self.expandMenuTapped?.isEnabled = false
//            self.plusLabel.transform = CGAffineTransform(rotationAngle: 0)
            let midPoint = CGPoint(x: UIScreen.main.bounds.midX, y: self.tabBar.center.y)
            self.tabBar.center = midPoint
            self.tabBar.backgroundColor = redColor
            self.plusLabel.textColor = UIColor.white
            
                self.tabBar.frame = CGRect(x: UIScreen.main.bounds.width - 60, y: UIScreen.main.bounds.height - 60, width: 50, height: 50)
            
        }
        
        UIView.animate(withDuration: 0.2, delay: 0.2, options: .curveEaseIn, animations: {
            for button in self.tabButtons {
                button.alpha = 0.0
            }
        }) { (completed) in
            self.tabBarAnimated = false
            
            self.expandMenuTapped?.isEnabled = true
        }
        
        let cornerRadiusAnimation = CABasicAnimation(keyPath: "cornerRadius")
        cornerRadiusAnimation.toValue = 25
        cornerRadiusAnimation.duration = 0.25
        
        cornerRadiusAnimation.isRemovedOnCompletion = false
        cornerRadiusAnimation.fillMode = kCAFillModeForwards
        self.tabBar.layer.add(cornerRadiusAnimation, forKey: "cornerRadiusAnim")

    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        didMove(toParentViewController: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tabItemTapped(_ sender: UIButton) {
        let previousIndex = selectedIndex
        selectedIndex = sender.tag
        tabButtons[previousIndex].isSelected = false
        let previousVC = viewControllers[previousIndex]
        
        previousVC.willMove(toParentViewController: nil)
        previousVC.view.removeFromSuperview()
        previousVC.removeFromParentViewController()
        
        sender.isSelected = true
        
        let vc = viewControllers[selectedIndex]
        
        addChildViewController(vc)
        
        vc.view.frame = contentView.bounds
        
        contentView.addSubview(vc.view)
        
        vc.didMove(toParentViewController: self)
    }

}
