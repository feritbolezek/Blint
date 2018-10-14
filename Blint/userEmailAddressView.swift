//
//  UserEmailAddressView.swift
//  Blint
//
//  Created by Ferit Bölezek on 22/04/17.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import UIKit

class UserEmailAddressView: UIView, UITextFieldDelegate {
    
    weak var delegate: SignUpChoiceDelegate?
    
    @IBOutlet weak var emailTextField: SignUpScreenTextFieldStylings!
    
    @IBOutlet weak var continueButton: ButtonStylings!
    
    @IBOutlet weak var errorMessage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layoutView()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layoutView()
    }
    func layoutView() {
        
        let view = Bundle.main.loadNibNamed("userEmailAddress", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        emailTextField.delegate = self
        self.addSubview(view)
        
    }
    func checkInputStatus() {
        if emailTextField.text?.characters.count == 0 {
            
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        textField.layer.shadowColor = UIColor.gray.cgColor
        textField.layer.shadowOffset = CGSize(width: 0, height: 0)
        textField.layer.shadowRadius = 2.0
        textField.layer.shadowOpacity = 1.0
    }
    
    @IBAction func continueTapped(_ sender: Any) {
        
        guard let emailText = emailTextField.text else {
            incorrectInput()
            return
        }
        if emailText.characters.count > 0 {
            emailTextField.resignFirstResponder()
            delegate?.emailFilledIn!(emailAddress: emailText)
        } else {
            incorrectInput()
        }
        
    }
    
    func incorrectInput() {
        errorMessage.isHidden = false
    UIView.animate(withDuration: 0.05, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveLinear, animations: {
        self.emailTextField.center.x += 10
    }, completion: nil)
        
        UIView.animate(withDuration: 0.05, delay: 0.05, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveLinear, animations: {
            self.emailTextField.center.x -= 20
        }, completion: nil)
        
        UIView.animate(withDuration: 0.05, delay: 0.1, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveLinear, animations: {
            self.emailTextField.center.x += 10
        }, completion: nil)

    }
}
