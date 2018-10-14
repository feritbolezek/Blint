//
//  LoginExtension.swift
//  Blint
//
//  Created by Ferit Bölezek on 25/04/17.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import UIKit

enum CurrentViewVisible {
    
    case nameView
    case emailView
    case ageView
    case genderView
    case passwordView
    
}

extension ViewController {
    
    func transitionToSignUpChoice() {
        
        if currentView == .nameView {
            currentView = .emailView
            if UIDevice.current.userInterfaceIdiom == .pad {
                userEmailAddressView = UserEmailAddressView(frame: CGRect(x: UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: 400))
            } else {
            userEmailAddressView = UserEmailAddressView(frame: CGRect(x: UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: 185))
            }
            userEmailAddressView?.delegate = self
            nameView.addSubview(userEmailAddressView!)
            if usersEnteredEmail != nil {
            userEmailAddressView?.emailTextField.text = usersEnteredEmail
            }
            UIView.animate(withDuration: 0.25) {
                self.welcomeText.alpha = 1.0
                if UIDevice.current.userInterfaceIdiom == .pad {
                self.userEmailAddressView!.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 400)
                } else {
                self.userEmailAddressView!.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 185)
                }
            }
        } else if currentView == .emailView {
            
            self.welcomeText.alpha = 0.0
            self.welcomeText.text = "Welcome to Blint, let's get you started..."
            self.backBtn.isHidden = false
            UIView.animate(withDuration: 0.25, animations: { 
                self.welcomeText.alpha = 1.0
                if UIDevice.current.userInterfaceIdiom == .pad {
                self.userEmailAddressView!.frame = CGRect(x: UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: 400)
                } else {
                self.userEmailAddressView!.frame = CGRect(x: UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: 185)
                }
            }, completion: { (completed) in
                self.transitionAwayFromName()
            })
            
        } else if currentView == .ageView {
            currentView = .emailView
            UIView.animate(withDuration: 0.25) {
                self.welcomeText.alpha = 1.0
                if UIDevice.current.userInterfaceIdiom == .pad {
                self.userEmailAddressView!.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 400)
                }  else {
                self.userEmailAddressView!.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 185)
                }
            }
        } else if currentView == .genderView {
            currentView = .ageView
            UIView.animate(withDuration: 0.25) {
                self.welcomeText.alpha = 1.0
                if UIDevice.current.userInterfaceIdiom == .pad {
                self.ageView!.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 400)
                } else {
                self.ageView!.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 185)
                }
            }
        } else if currentView == .passwordView {
            currentView = .genderView
            UIView.animate(withDuration: 0.25) {
                self.welcomeText.alpha = 1.0
                if UIDevice.current.userInterfaceIdiom == .pad {
                self.genderView!.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 400)
                } else {
                self.genderView!.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 185)
                }
            }
        }
    }
    func transitionAwayFromEmailAdress() {
        currentView = .ageView
        self.welcomeText.alpha = 0.0
        self.welcomeText.text = "And your age is..."
        self.backBtn.isHidden = false
        UIView.animate(withDuration: 0.25) {
            self.welcomeText.alpha = 1.0
            if UIDevice.current.userInterfaceIdiom == .pad {
            self.userEmailAddressView!.frame = CGRect(x: -UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: 400)
            } else {
            self.userEmailAddressView!.frame = CGRect(x: -UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: 185)
            }
        }

    }
    func transitionToAge() {
        if UIDevice.current.userInterfaceIdiom == .pad {
        ageView = userAgeView(frame: CGRect(x: UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: 400))
        } else {
        ageView = userAgeView(frame: CGRect(x: UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: 185))
        }
        ageView?.delegate = self
        nameView.addSubview(ageView!)
        if usersEnteredAge != nil {
            ageView?.ageTextField.text = usersEnteredAge
        }
        transitionAwayFromEmailAdress()
        currentView = CurrentViewVisible.ageView
        UIView.animate(withDuration: 0.25) {
            self.welcomeText.alpha = 1.0
            if UIDevice.current.userInterfaceIdiom == .pad {
            self.ageView!.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 400)
            } else {
            self.ageView!.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 185)
            }
        }
        
    }
    func transitionAwayFromAge(sender: String) {
        welcomeText.alpha = 0.0
        if sender == "forward" {
        UIView.animate(withDuration: 0.25) {
            self.welcomeText.alpha = 1.0
            if UIDevice.current.userInterfaceIdiom == .pad {
            self.ageView!.frame = CGRect(x: -UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: 400)
            } else {
            self.ageView!.frame = CGRect(x: -UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: 185)
            }
        }

            welcomeText.text = "Almost there..."
        } else {
            UIView.animate(withDuration: 0.25) {
                self.welcomeText.alpha = 1.0
                if UIDevice.current.userInterfaceIdiom == .pad {
                self.ageView!.frame = CGRect(x: UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: 400)
                } else {
                self.ageView!.frame = CGRect(x: UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: 185)
                }
            }
        }
        if sender == "back" {
            welcomeText.text = "Hello \(usersEnteredName!), please enter your email address below."
            transitionToSignUpChoice()
        }
        
    }
    func transitionToGender() {
        if UIDevice.current.userInterfaceIdiom == .pad {
        genderView = GenderSelection(frame: CGRect(x: UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: 400))
        } else {
        genderView = GenderSelection(frame: CGRect(x: UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: 185))
        }
        genderView?.delegate = self
        nameView.addSubview(genderView!)
        transitionAwayFromAge(sender: "forward")
        currentView = CurrentViewVisible.genderView
        UIView.animate(withDuration: 0.25) {
            self.welcomeText.alpha = 1.0
            if UIDevice.current.userInterfaceIdiom == .pad {
            self.genderView!.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 400)
            } else {
            self.genderView!.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 185)
            }
        }
        
    }
    func transitionAwayFromGender(sender: String) {
        welcomeText.alpha = 0.0
        if sender == "forward"{
            UIView.animate(withDuration: 0.25) {
                self.welcomeText.alpha = 1.0
                if UIDevice.current.userInterfaceIdiom == .pad {
                self.genderView!.frame = CGRect(x: -UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: 400)
                } else {
                self.genderView!.frame = CGRect(x: -UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: 185)
                }
            }
            
            welcomeText.text = "And finally your password is..."
        } else {
            UIView.animate(withDuration: 0.25) {
                self.welcomeText.alpha = 1.0
                if UIDevice.current.userInterfaceIdiom == .pad {
                self.genderView!.frame = CGRect(x: UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: 400)
                } else {
                self.genderView!.frame = CGRect(x: UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: 185)
                }
            }
        }
        if sender == "back" {
            welcomeText.text = "And your age is..."
            transitionToSignUpChoice()
        }
        
    }
    
    
    func transitionToPassword() {
        if UIDevice.current.userInterfaceIdiom == .pad {
             passwordView = userPassword(frame: CGRect(x: UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: 400))
        } else {
            passwordView = userPassword(frame: CGRect(x: UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: 185))
        }
            passwordView?.delegate = self
            nameView.addSubview(passwordView!)
        
        transitionAwayFromGender(sender: "forward")
            currentView = CurrentViewVisible.passwordView
            UIView.animate(withDuration: 0.25) {
                self.welcomeText.alpha = 1.0
                if UIDevice.current.userInterfaceIdiom == .pad {
           self.passwordView!.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 400)
                } else {
                self.passwordView!.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 185)
                }
        }
        
    }
    func transitionAwayFromPassword() {
        welcomeText.alpha = 0.0
        UIView.animate(withDuration: 0.25) {
            self.welcomeText.alpha = 1.0
            if UIDevice.current.userInterfaceIdiom == .pad {
        self.passwordView!.frame = CGRect(x: UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: 400)
            } else {
            self.passwordView!.frame = CGRect(x: UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: 185)
            }
        }
        if nameTextField.text != nil {

            welcomeText.text = "Almost there..."
        }
        transitionToSignUpChoice()
    }
    
    
    func transitionAwayFromName() {
        if currentView == .nameView {
            
            UIView.animate(withDuration: 0.25, animations: {
                if UIDevice.current.userInterfaceIdiom == .pad {
                    self.nameTextField.frame = CGRect(x: -self.view.frame.width, y: self.nameTextField.frame.minY, width: self.nameTextField.frame.width, height: self.nameTextField.frame.height)
                    
                    self.nextButton.frame = CGRect(x: -self.view.frame.width, y: self.nextButton.frame.minY, width: self.nextButton.frame.width, height: self.nextButton.frame.height)
                } else {
                self.nameTextField.frame = CGRect(x: -self.view.frame.width, y: self.nameTextField.frame.minY, width: self.nameTextField.frame.width, height: self.nameTextField.frame.height)
                
                self.nextButton.frame = CGRect(x: -self.view.frame.width, y: self.nextButton.frame.minY, width: self.nextButton.frame.width, height: self.nextButton.frame.height)
                }
                
            }) { (completed) in
                
                self.transitionToSignUpChoice()
                self.backBtn.isHidden = false
                self.nameTextField.isHidden = true
                self.nextButton.isHidden = true
                
                
            }
            
        } else if currentView == .emailView {
            
            currentView = .nameView
            
            self.nameTextField.frame = CGRect(x: -self.view.frame.width, y: self.nameTextField.frame.minY, width: self.nameTextField.frame.width, height: self.nameTextField.frame.height)
            
            self.nextButton.frame = CGRect(x: -self.view.frame.width, y: self.nextButton.frame.minY, width: self.nextButton.frame.width, height: self.nextButton.frame.height)
            
            self.nameTextField.isHidden = false
            self.nextButton.isHidden = false
            
            
            UIView.animate(withDuration: 0.25, animations: {
                
                let middleScreenXNameTextField = (UIScreen.main.bounds.width / 2) - (self.nameTextField.frame.size.width / 2)
                
                let middleScreenXNextButton = (UIScreen.main.bounds.width / 2) - (self.nextButton.frame.size.width / 2)
                
                
                self.nameTextField.frame = CGRect(x: middleScreenXNameTextField, y: self.nameTextField.frame.minY, width: self.nameTextField.frame.width, height: self.nameTextField.frame.height)
                
                self.nextButton.frame = CGRect(x: middleScreenXNextButton, y: self.nextButton.frame.minY, width: self.nextButton.frame.width, height: self.nextButton.frame.height)
                
            }) { (completed) in
                
                self.backBtn.isHidden = true
                
            }
        }
    }
    
}
