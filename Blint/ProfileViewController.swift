//
//  ProfileViewController.swift
//  Blint
//
//  Created by Ferit Bölezek on 12/05/17.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import UIKit

// Animations for the top view is kept in the extension for the Profile viewcontroller.

class ProfileViewController: UIViewController, UICollisionBehaviorDelegate, UITextViewDelegate {

    @IBOutlet weak var matchView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var scrollViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var bioTextView: UITextView!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var preferencesTextView: UITextView!
    
    @IBOutlet weak var interestsTextView: UITextView!
    
    @IBOutlet weak var educationAndWorkTextView: UITextView!
    
    @IBOutlet weak var relationshipStatusTextView: UITextView!
    
    var snapBehaviour: UISnapBehavior?
    var collisionBehaviour: UICollisionBehavior?
    var gravityBehaviour: UIGravityBehavior?
    
    var dynamicAnimator: UIDynamicAnimator?
    
    var startingPos: CGFloat!
    
    let generator = UIImpactFeedbackGenerator(style: .light)
    
    var currentUser: BlintUser!
    
    var dataStatusDownloaded = false
    
    var notifViewForPreferences: NotificationView!
    var notifViewForInterests: NotificationView!
    var notifViewForEducation: NotificationView!
    
    weak var delegate: DataInformationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentUser = BlintUser()
        currentUser.fetchData(userID: currentUser.userKeychainID, dataToFetch: .fetchAllData) {
            self.dataStatusDownloaded = true
            self.delegate?.fetchedAllData!(user: self.currentUser)
            DataContainer.sharedInstance.currentUser = self.currentUser
            self.currentUser.loadInPreferences { (userPrefTexts) in
                if !userPrefTexts.isEmpty {

                self.setText(texts: userPrefTexts, forType: .preferences)
                self.delegate?.fetchedInformationFor!(type: "preferences")
                    if self.notifViewForPreferences != nil {
                self.specificsNotEmptyAnymore(subviewTo: self.preferencesTextView, notificationView: self.notifViewForPreferences)
                    }
                } else {
                    self.notificationForEmptyUserSpecifics(subviewTo: self.preferencesTextView, notificationMessage: "preferences", typeOfNotification: "preferences")
                }
            }
            self.currentUser.loadInInterests(completion: { (userInterestsTexts) in
                if !userInterestsTexts.isEmpty {
                self.setText(texts: userInterestsTexts, forType: .interests)
                self.delegate?.fetchedInformationFor!(type: "interests")
                    if self.notifViewForInterests != nil {
                self.specificsNotEmptyAnymore(subviewTo: self.interestsTextView, notificationView: self.notifViewForInterests)
                    }
                } else {
                    self.notificationForEmptyUserSpecifics(subviewTo: self.interestsTextView, notificationMessage: "interests", typeOfNotification: "interests")
                }
            })
            self.currentUser.loadInEducationAndWork(completion: { (userEducationAndWorkTexts) in
                if !userEducationAndWorkTexts.isEmpty {
                self.setText(texts: userEducationAndWorkTexts, forType: .educationAndWork)
                self.delegate?.fetchedInformationFor!(type: "educationAndWork")
                    if self.notifViewForEducation != nil {
                self.specificsNotEmptyAnymore(subviewTo: self.educationAndWorkTextView, notificationView: self.notifViewForEducation)
                    }
                } else {
                    self.notificationForEmptyUserSpecifics(subviewTo: self.educationAndWorkTextView, notificationMessage: "education and work", typeOfNotification: "education")
                }
            })
            self.setUserData()
            
        }
        
        startingPos = matchView.frame.maxY
        
        matchView.frame = CGRect(x: 0, y: -view.bounds.height + 222, width: view.bounds.width, height: view.bounds.height)
        
        dynamicAnimator = UIDynamicAnimator(referenceView: self.view)
        
        
        let dragDownMenu = UIPanGestureRecognizer(target: self, action: #selector(dragDown(sender:)))
        matchView.addGestureRecognizer(dragDownMenu)
        matchView.isUserInteractionEnabled = true
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    func notificationForEmptyUserSpecifics(subviewTo: UITextView, notificationMessage: String, typeOfNotification: String) {
        if typeOfNotification == "preferences" {
         notifViewForPreferences = NotificationView(frame: CGRect(x: 0, y: 0, width: subviewTo.frame.width - 50, height: subviewTo.frame.height))
        notifViewForPreferences.notificationMessage = "Whoops it seems to be empty in here, add your \(notificationMessage) to get matched with other users now!"
        subviewTo.addSubview(notifViewForPreferences)
        } else if typeOfNotification == "interests" {
            notifViewForInterests = NotificationView(frame: CGRect(x: 0, y: 0, width: subviewTo.frame.width - 50, height: subviewTo.frame.height))
            notifViewForInterests.notificationMessage = "Whoops it seems to be empty in here, add your \(notificationMessage) to get matched with other users now!"
            subviewTo.addSubview(notifViewForInterests)
        } else {
            notifViewForEducation = NotificationView(frame: CGRect(x: 0, y: 0, width: subviewTo.frame.width - 50, height: subviewTo.frame.height))
            notifViewForEducation.notificationMessage = "Whoops it seems to be empty in here, add your \(notificationMessage) to get matched with other users now!"
            subviewTo.addSubview(notifViewForEducation)
        }
    }
    func specificsNotEmptyAnymore(subviewTo: UITextView, notificationView: NotificationView) {
           notificationView.removeFromSuperview()
    }
    
    func setUserData() {
        
        bioTextView.text = currentUser.userInformation["aboutMe"] as? String
        
        if bioTextView.text == "empty" || bioTextView.text == nil {
            bioTextView.text = "You currently have no bio. Adding a bio makes your profile look way more appealing!"
            bioTextView.textColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 0.54)
            bioTextView.font = UIFont(name: "Avenir", size: 15)
        }
        
        relationshipStatusTextView.text = currentUser.userInformation["relationshipStatus"] as? String
        if relationshipStatusTextView.text == "" || relationshipStatusTextView.text == nil {
            bioTextView.text = "You currently have no relationship status set."
            bioTextView.textColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 0.54)
        }
    }
    
    func setText(texts: [String], forType: UserInformationType) {
        let length = texts.count - 1
       
        if forType == .preferences {
            preferencesTextView.text = ""
        for index in 0...length {
            if index != length {
            preferencesTextView.text.append(texts[index] + ", ")
            } else {
                preferencesTextView.text.append(texts[index] + ".")
            }
         }
        } else if forType == .interests {
            interestsTextView.text = ""
            for index in 0...length {
                if index != length {
                    interestsTextView.text.append(texts[index] + ", ")
                } else {
                    interestsTextView.text.append(texts[index] + ".")
                }
            }
        } else if forType == .educationAndWork {
            educationAndWorkTextView.text = ""
            for index in 0...length {
                if index != length {
                    educationAndWorkTextView.text.append(texts[index] + ", ")
                } else {
                    educationAndWorkTextView.text.append(texts[index] + ".")
                }
            }
        }
        
    }
    
    // Functions for editing profile information
    @IBAction func editBioTapped(_ sender: UITapGestureRecognizer) {
        if dataStatusDownloaded {
            performSegue(withIdentifier: "toInformationChanging", sender: "infoChanging")
        }
    }
    @IBAction func editPreferencesTapped(_ sender: UITapGestureRecognizer) {
        if dataStatusDownloaded {
            performSegue(withIdentifier: "changeUserInfo", sender: "preferences")
        }
    }
    @IBAction func editInterestsTapped(_ sender: UITapGestureRecognizer) {
        if dataStatusDownloaded {
            performSegue(withIdentifier: "changeUserInfo", sender: "interests")
        }
    }
    @IBAction func editEducationAndWorkTapped(_ sender: UITapGestureRecognizer) {
        if dataStatusDownloaded {
            performSegue(withIdentifier: "changeUserInfo", sender: "educationAndWork")
        }
    }
    @IBAction func editRelationshipStatusTapped(_ sender: UITapGestureRecognizer) {
        if dataStatusDownloaded {
            performSegue(withIdentifier: "toInformationChanging", sender: "infoChanging")
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? InformationChangeViewController {
            
            dest.user = self.currentUser
            
        if let currSender = sender as? String {
            
            switch currSender {
            case "preferences":
                dest.selectedSpecifics = currentUser.userPreferencesLabels
                dest.currentlyEditing = UserInformationType.preferences
                break
            case "interests":
                dest.selectedSpecifics = currentUser.userInterestsLabels
                dest.currentlyEditing = UserInformationType.interests
                break
            case "educationAndWork":
                dest.selectedSpecifics = currentUser.userEducationAndWorkLabels
                dest.currentlyEditing = UserInformationType.educationAndWork
                break
            default:
                print("error. Where are you segueing?")
            }
            
         }
        }
        if segue.identifier == "showProfileDetails" {
            let dest = segue.destination as! profileDetailsViewController
            dest.currentUser = self.currentUser
            dest.profileVC = self
            delegate?.segueCalledForInformation!()
        }
        if segue.identifier == "toInformationChanging" {
            let dest = segue.destination as! ChangeUserInfoViewController
            dest.currentUser = self.currentUser
        }
    }
    
    

}
