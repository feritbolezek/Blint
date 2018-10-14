//
//  AddMoreViewController.swift
//  Blint
//
//  Created by Ferit Bölezek on 23/05/17.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import UIKit

class AddMoreViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var addTextField: UITextField!
    
    @IBOutlet weak var textFieldLengthLabel: UILabel!
    
    @IBOutlet weak var descriptionSubLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var selectedSpecifics = [String]()
    
    var currentlyEditing: UserInformationType!
    
    weak var delegate: DataInformationDelegate?
    
    var currentUser: BlintUser?
    
    let rematchingPossible = Notification.Name("rematch")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch currentlyEditing! {
        case .preferences:
            descriptionSubLabel.text = "Add a new preference, try to keep it as generic as possible."
            titleLabel.text = "Add new preferences"
        case .interests:
            descriptionSubLabel.text = "Add a new interest."
            titleLabel.text = "Add new interests"
            addTextField.placeholder = "Basketball"
        case .educationAndWork:
            descriptionSubLabel.text = "Add current or past education/work."
            titleLabel.text = "Add education/work"
            addTextField.placeholder = "Malmö Yrkeshögskola"
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func addTapped(_ sender: Any) {
        
        if let textExists = addTextField.text {
            if textExists.characters.count > 1 {
                currentUser!.saveUserSpecifics(data: textExists, typeOfData: currentlyEditing, completion: { (error) in
                    if error == nil {
                        self.addTextField.text?.removeAll()
                    } else {
                        print("There was an error \(error?.localizedDescription)")
                    }
                })
                
                selectedSpecifics.append(textExists)
                NotificationCenter.default.post(name: rematchingPossible, object: nil)
                delegate?.newDataAdded!(data: selectedSpecifics)
            }
        }
    
    }
    
    @IBAction func generalViewTapped(_ sender: Any) {
        addTextField.resignFirstResponder()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addTextField.resignFirstResponder()
        
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 50
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        
        var textfieldTextLength = newString.length
        if textfieldTextLength > 50 { textfieldTextLength = 50 }
        textFieldLengthLabel.text = "\(textfieldTextLength)" + "/50"
        
        return newString.length <= maxLength
        
    }
    @IBAction func backTapped(_ sender: Any) {
       _ = navigationController?.popViewController(animated: true)
    }

}
