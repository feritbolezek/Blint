//
//  userAgeView.swift
//  Blint
//
//  Created by Ferit Bölezek on 26/05/17.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import UIKit

class userAgeView: UIView, UITextFieldDelegate {

    @IBOutlet weak var ageTextField: SignUpScreenTextFieldStylings!
    @IBOutlet weak var errorLabel: UILabel!
    
    weak var delegate: SignUpChoiceDelegate?
    
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
        
        let view = Bundle.main.loadNibNamed("userAgeView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        ageTextField.delegate = self
        self.addSubview(view)
        
    }
    func checkInputStatus() {
        if ageTextField.text?.characters.count == 0 {
            
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
        guard let ageText = ageTextField.text else {
            incorrectInput()
            return
        }
        if ageText.characters.count > 0 {
            ageTextField.resignFirstResponder()
            delegate?.ageFilledIn!(age: ageText)
        } else {
            incorrectInput()
        }
    }
    
    func incorrectInput() {
        errorLabel.isHidden = false
        UIView.animate(withDuration: 0.05, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveLinear, animations: {
            self.ageTextField.center.x += 10
        }, completion: nil)
        
        UIView.animate(withDuration: 0.05, delay: 0.05, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveLinear, animations: {
            self.ageTextField.center.x -= 20
        }, completion: nil)
        
        UIView.animate(withDuration: 0.05, delay: 0.1, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveLinear, animations: {
            self.ageTextField.center.x += 10
        }, completion: nil)
        
    }

    

    
    
    
}
