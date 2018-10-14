//
//  userPassword.swift
//  Blint
//
//  Created by Ferit Bölezek on 27/04/17.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import UIKit

class userPassword: UIView, UITextFieldDelegate {

    @IBOutlet weak var passwordTextField: SignUpScreenTextFieldStylings!
    @IBOutlet weak var passwordErrorMessageLabel: UILabel!
    @IBOutlet weak var showPasswordButton: UIButton!
    
    weak var delegate: SignUpChoiceDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layouView()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        layouView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layouView()
    }
    
    func layouView() {
        
        let view = Bundle.main.loadNibNamed("userPassword", owner: self, options: nil)?.first as! UIView
        
        view.frame = self.bounds
        
        passwordTextField.delegate = self
        showPasswordButton.isEnabled = false
        
        self.addSubview(view)
        
    }
    
    @IBAction func termsOfUseTapped(_ sender: Any) {
        delegate?.termsTapped!()
    }
    
    
    @IBAction func privacyPolicyTapped(_ sender: Any) {
        delegate?.privacyTapped!()
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        showPasswordButton.isEnabled = true
        textField.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        textField.layer.shadowColor = UIColor.gray.cgColor
        textField.layer.shadowOffset = CGSize(width: 0, height: 0)
        textField.layer.shadowRadius = 2.0
        textField.layer.shadowOpacity = 1.0
        textField.isSecureTextEntry = true
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        
        guard let passwordText = passwordTextField.text else {
            incorrectInput(withError: "No password entered.")
            return
        }
        if passwordText.characters.count > 0 && passwordText != "My preferred password is..." {
            delegate?.passwordFilledIn!(password: passwordText)
        } else {
            incorrectInput(withError: "Please enter your password.")
        }
        
        
    }
    @IBAction func showPasswordTapped(_ sender: UIButton) {
        if passwordTextField.isSecureTextEntry == true {
            sender.alpha = 1.0
            passwordTextField.isSecureTextEntry = false
        } else {
            sender.alpha = 0.6
            passwordTextField.isSecureTextEntry = true
        }
    }
    func incorrectInput(withError: String) {
        passwordErrorMessageLabel.isHidden = false
        passwordErrorMessageLabel.text = withError
        UIView.animate(withDuration: 0.05, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveLinear, animations: {
            self.passwordTextField.center.x += 10
        }, completion: nil)
        
        UIView.animate(withDuration: 0.05, delay: 0.05, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveLinear, animations: {
            self.passwordTextField.center.x -= 20
        }, completion: nil)
        
        UIView.animate(withDuration: 0.05, delay: 0.1, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveLinear, animations: {
            self.passwordTextField.center.x += 10
        }, completion: nil)
        
    }
}
