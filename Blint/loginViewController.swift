//
//  loginViewController.swift
//  Blint
//
//  Created by Ferit Bölezek on 25/04/17.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class loginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailAddressLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    @IBOutlet weak var emailAdressTextField: SignUpScreenTextFieldStylings!
    @IBOutlet weak var passwordTextField: SignUpScreenTextFieldStylings!
    
    var notifView: NotificationView?
    
    weak var delegate: LoginDelegate?
    
    var error = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailAdressTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailAdressTextField {
            animateEmailLabel(reverseAnimate: false)
        } else if textField == passwordTextField {
            animatePasswordLabel(reverseAnimate: false)
        }
        
        textField.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        textField.layer.shadowColor = UIColor.gray.cgColor
        textField.layer.shadowOffset = CGSize(width: 0, height: 0)
        textField.layer.shadowRadius = 2.0
        textField.layer.shadowOpacity = 1.0
        
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        if textField == emailAdressTextField && textField.text == "" {
            animateEmailLabel(reverseAnimate: true)
            
        } else if textField == passwordTextField && textField.text == "" {
            animatePasswordLabel(reverseAnimate: true)
        }
    }
    
    
    func animateEmailLabel(reverseAnimate: Bool) {
        
        if !reverseAnimate {
            UIView.animate(withDuration: 0.25) {
                if UIDevice.current.userInterfaceIdiom == .pad {
                self.emailAddressLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                self.emailAddressLabel.transform = CGAffineTransform(translationX: 0, y: -44)
                } else {
                    self.emailAddressLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                    self.emailAddressLabel.transform = CGAffineTransform(translationX: 0, y: -22)
                }
            }
        } else {
            UIView.animate(withDuration: 0.25) {
                if UIDevice.current.userInterfaceIdiom == .pad {
                self.emailAddressLabel.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
                self.emailAddressLabel.transform = CGAffineTransform(translationX: 0, y: 0)
                } else {
                    self.emailAddressLabel.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
                    self.emailAddressLabel.transform = CGAffineTransform(translationX: 0, y: 0)
                }
            }
        }

        
    }
    func animatePasswordLabel(reverseAnimate: Bool) {
        
        if !reverseAnimate {
            UIView.animate(withDuration: 0.25) {
                if UIDevice.current.userInterfaceIdiom == .pad {
                self.passwordLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                self.passwordLabel.transform = CGAffineTransform(translationX: 0, y: -44)
                } else {
                    self.passwordLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                    self.passwordLabel.transform = CGAffineTransform(translationX: 0, y: -22)
                }
            }
        } else {
            UIView.animate(withDuration: 0.25) {
                if UIDevice.current.userInterfaceIdiom == .pad {
                self.passwordLabel.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
                self.passwordLabel.transform = CGAffineTransform(translationX: 0, y: 0)
                } else {
                    self.passwordLabel.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
                    self.passwordLabel.transform = CGAffineTransform(translationX: 0, y: 0)
                }
            }
        }
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailAdressTextField {
            emailAdressTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            passwordTextField.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        guard let username = emailAdressTextField.text, let password = passwordTextField.text else {
            if self.error == false {
                self.error = true
            self.notifView = NotificationView()
            self.notifView!.addMeToView(notificationMessage: "Please enter your credentials.", subviewMeTo: self.view)
            self.notifView!.removeMe(timeUntilDeletion: 3, completion: {
                self.notifView!.removeFromSuperview()
                self.error = false
            })
            }
            return
        }
        
        if username != "" && password != "" {
           AuthenticationService.standard.signin(withEmail: username, password: password, oncComplete: { (error, user) in
            if error != nil {
                if self.error == false {
                    self.error = true
                self.notifView = NotificationView()
                self.notifView!.addMeToView(notificationMessage: "\(String(describing: error!))", subviewMeTo: self.view)
                self.notifView!.removeMe(timeUntilDeletion: 3.0, completion: {
                    self.notifView!.removeFromSuperview()
                    self.error = false
                })
                }
            } else {
                self.dismiss(animated: false, completion: nil)
                self.delegate?.userSignsIn()
            }
           })
        }
        
    }
    
    @IBAction func mainScreenSwiped(_ sender: Any) {
        emailAdressTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    
    @IBAction func backBtnTapped(_ sender: Any) {
        
        _ = navigationController?.popToRootViewController(animated: true)
        
    }
    
    

}
