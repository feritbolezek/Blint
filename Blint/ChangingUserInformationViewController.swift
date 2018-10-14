//
//  ChangingUserInformationViewController.swift
//  Blint
//
//  Created by Ferit Bölezek on 03/06/17.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import UIKit

enum ChangingTypeOfInformation {
    case nameAge
    case gender
    case relationship
}

class ChangingUserInformationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var relationshipChoicesTableView: UITableView!
    
    @IBOutlet weak var topTipLabel: UILabel!
    
    @IBOutlet weak var bottomTipLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var nameAndAgeView: UIView!
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var ageTextField: UITextField!
    
    
    @IBOutlet weak var errorMessageForName: UILabel!
    
    @IBOutlet weak var errorMessageForAge: UILabel!
    
    var infoChanging = ChangingTypeOfInformation.nameAge // changed from prepare for segue
    
    var relationshipStatusesTexts = ["No answer","Single","In a relationship","Complicated", "No strings"]
    var genderChoices = ["Male","Female","Other"]
    
    var currentUser: BlintUser!
    
    var userGender: String!
    
    var userRelationshipStatus: String!
    
    var usersName: String!
    
    var usersAge: String!
    
    var delegate: DataInformationDelegate?
    
    let rematchingPossible = Notification.Name("rematch")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userGender = currentUser.userInformation["gender"] as! String
        userRelationshipStatus = currentUser.userInformation["relationshipStatus"] as! String
        usersName = currentUser.userInformation["name"] as! String
        usersAge = currentUser.userInformation["age"] as! String
        
        if infoChanging == .nameAge {
            titleLabel.text = "Name & age"
            topTipLabel.text = "Set your name and age, may only be changed once."
            relationshipChoicesTableView.isHidden = true
            nameTextField.text = usersName
            ageTextField.text = usersAge
            
        } else if infoChanging == .relationship {
            nameAndAgeView.isHidden = true
            let count = relationshipStatusesTexts.count
            tableViewHeight.constant = relationshipChoicesTableView.rowHeight * CGFloat(count) + 50
        } else if infoChanging == .gender {
            titleLabel.text = "Gender"
            topTipLabel.text = "Select your gender."
            nameAndAgeView.isHidden = true
            let count = genderChoices.count
            tableViewHeight.constant = relationshipChoicesTableView.rowHeight * CGFloat(count) + 50
//            setupView(for: .gender)
        }
        // Do any additional setup after loading the view.

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 80
        } else {
            return 60
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "changingInformationChoice", for: indexPath) as? relationshipCell {
            if infoChanging == .relationship {
            cell.relationshipLabelText = relationshipStatusesTexts[indexPath.row]
                if relationshipStatusesTexts[indexPath.row] == userRelationshipStatus {
                    relationshipChoicesTableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
                }
            } else if infoChanging == .gender {
                cell.relationshipLabelText = genderChoices[indexPath.row]
                if genderChoices[indexPath.row] == userGender {
                    relationshipChoicesTableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
                }
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if infoChanging == .relationship {
        return relationshipStatusesTexts.count
        } else if infoChanging == .gender {
        return genderChoices.count
        } else {
            return 0
        }
    }

    @IBAction func saveTapped(_ sender: Any) {
        
        if infoChanging == .nameAge {
            if let nameEntered = nameTextField.text {
                if nameEntered != "" && nameEntered.characters.count > 2 {
                    DataService.standard.CURRENT_USER_REF.child("userInformation").updateChildValues(["name" : nameEntered])
                    if checkAge(age: ageTextField.text!) {
                        usersAge = ageTextField.text!
                    delegate?.userInfoWasChanged!(dataChanged: "name", theData: nameEntered, secondaryData: usersAge)
                        NotificationCenter.default.post(name: rematchingPossible, object: nil)
                    } else {
                delegate?.userInfoWasChanged!(dataChanged: "name", theData: nameEntered, secondaryData: nil)
                        NotificationCenter.default.post(name: rematchingPossible, object: nil)
                    }
                    
                } else {
                    errorMessageForName.isHidden = false
                }
                
            }
            // TODO: MIGHT ME REMOVED TO MINIMIZE CODE
            if ageTextField.text != "" {
                if checkAge(age: ageTextField.text!){
                DataService.standard.CURRENT_USER_REF.child("userInformation").updateChildValues(["age" : ageTextField.text!])
                    delegate?.userInfoWasChanged!(dataChanged: "age", theData: ageTextField.text!, secondaryData: nil)
                    NotificationCenter.default.post(name: rematchingPossible, object: nil)
                } else {
                    errorMessageForAge.isHidden = false
                }
            } else {
                errorMessageForAge.isHidden = false
            }
            
        } else if infoChanging == .relationship {
            let indexPath = relationshipChoicesTableView.indexPathForSelectedRow
            let selectedCell = relationshipChoicesTableView.cellForRow(at: indexPath!) as! relationshipCell
            DataService.standard.CURRENT_USER_REF.child("userInformation").updateChildValues(["relationshipStatus" : selectedCell.choiceLabel.text!])
            delegate?.userInfoWasChanged!(dataChanged: "relationship", theData: selectedCell.choiceLabel.text!, secondaryData: nil)
            NotificationCenter.default.post(name: rematchingPossible, object: nil)
            
        } else if infoChanging == .gender {
            let indexPath = relationshipChoicesTableView.indexPathForSelectedRow
            let selectedCell = relationshipChoicesTableView.cellForRow(at: indexPath!) as! relationshipCell
            DataService.standard.CURRENT_USER_REF.child("userInformation").updateChildValues(["gender" : selectedCell.choiceLabel.text!], withCompletionBlock: { (error, reference) in
                self.delegate?.userInfoWasChanged!(dataChanged: "gender", theData: selectedCell.choiceLabel.text!, secondaryData: nil)
                NotificationCenter.default.post(name: self.rematchingPossible, object: nil)
            })

        }
        
    }
    
    func checkAge(age: String) -> Bool {
        let userAge = Int(age)
        
        if let ageValid = userAge {
            
            if ageValid > 15 {
                return true
            } else {
                errorMessageForAge.text = "Blint is to be used by people over the age of 15."
                return false
            }
            
        } else {
            errorMessageForAge.text = "Please enter a valid age."
            return false
        }
    }
    @IBAction func backBtnTapped(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func sendBackInfo() {
    }
}
