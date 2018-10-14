//
//  profileDetailsViewController.swift
//  Blint
//
//  Created by Ferit Bölezek on 30/05/17.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class profileDetailsViewController: UIViewController, DataInformationDelegate, TaggyViewDelegate {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: avatarView!
    @IBOutlet weak var profileDetailsContainer: UIView!
    
    @IBOutlet weak var profileDetailsScrollView: UIScrollView!
    
    @IBOutlet weak var aboutMeTextView: UITextView!
    @IBOutlet weak var preferencesTaggyView: TaggyView!
    @IBOutlet weak var interestsTaggyView: TaggyView!
    @IBOutlet weak var educationTaggyView: TaggyView!
    @IBOutlet weak var relationshipLabel: UILabel!
    
    @IBOutlet weak var selfProfileDetailsScrollView: UIScrollView!
    
    
    @IBOutlet weak var preferencesHeight: NSLayoutConstraint!

    @IBOutlet weak var interestsHeight: NSLayoutConstraint!

    @IBOutlet weak var educationHeight: NSLayoutConstraint!
    
    var userDefaults = UserDefaults.standard
    var currentUser: BlintUser?
    var profileVC: ProfileViewController?
    var userPreferencesSet = false
    var userInterestsSet = false
    var userEducationSet = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return UIStatusBarStyle.lightContent }
    override func viewDidLoad() {
        super.viewDidLoad()
        profileVC!.delegate = self
        taggyViewsSetup()
        matchViewStylings()
        NotificationCenter.default.addObserver(self, selector: #selector(flashIndicator), name: NSNotification.Name("containerAtBottom"), object: nil)
        self.view.layer.shadowColor = UIColor.black.cgColor
        self.view.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.view.layer.shadowRadius = 3.0
        self.view.layer.shadowOpacity = 0.8
        // Do any additional setup after loading the view.
    }
    
    func segueCalledForInformation() {
        // Calling segue for images
    }
    func taggyViewsSetup() {
        preferencesTaggyView.delegate = self
        interestsTaggyView.delegate = self
        educationTaggyView.delegate = self
        
        preferencesTaggyView.typeOfData = .preferences
        interestsTaggyView.typeOfData = .interests
        educationTaggyView.typeOfData = .educationAndWork
    }

    func fetchedAllData(user: BlintUser) {
        currentUser = user
        if let username = user.userInformation["name"] as? String, let age = user.userInformation["age"] as? String, let relationship = user.userInformation["relationshipStatus"] as? String {
            nameLabel.text = username + ", " + age
            relationshipLabel.text = relationship
            aboutMeTextView.text = user.userInformation["aboutMe"] as? String
            if aboutMeTextView.text == "empty" {
                aboutMeTextView.text = "This user has not setup a bio yet."
            
            }
        }
        
        if let keychainID = KeychainWrapper.standard.string(forKey: USER_UID) {
            if userDefaults.object(forKey: "currentProfilePhoto_\(keychainID)") != nil {
                let imageSaved = UIImage(data: userDefaults.data(forKey: "currentProfilePhoto_\(keychainID)")!)
                profileImageView.image = imageSaved
            } else {
                currentUser!.downloadCurrentUsersImageIfExists(completion: { (profileImage) in
                    self.profileImageView.image = profileImage
                    
                })
            }
        }
        
    }
    func fetchedInformationFor(type: String) {
            displayData(type: type)
        
    }
    func displayData(type: String) {
        if type == "preferences" {
        if let preferences = currentUser?.userPreferencesLabels {
            
            if !preferencesTaggyView.taggies.isEmpty {
                
            let res = compareData(arr1: preferences, arr2: preferencesTaggyView.taggies)
            for tag in res {
                preferencesTaggyView.taggies.append(tag)
            }
            }
            if !userPreferencesSet {
        for preference in preferences {
            preferencesTaggyView.taggies.append(preference)
        }
                preferencesTaggyView.addTaggies()
                preferencesHeight.constant = preferencesTaggyView.frame.size.height + 10

                userPreferencesSet = true
            }
        }
        }  else if type == "interests" {
            if let interests = currentUser?.userInterestsLabels {
                if !interestsTaggyView.taggies.isEmpty {
                    
                    let res = compareData(arr1: interests, arr2: interestsTaggyView.taggies)
                    for tag in res {
                        interestsTaggyView.taggies.append(tag)
                    }
                }
                if !userInterestsSet {
                    for interest in interests {
                        interestsTaggyView.taggies.append(interest)
                    }
                    interestsTaggyView.addTaggies()
                interestsHeight.constant = interestsTaggyView.frame.size.height + 10
                    
                    userInterestsSet = true
                }
            }
        } else if type == "educationAndWork" {
            if let educationAndWork = currentUser?.userEducationAndWorkLabels {
                if !educationTaggyView.taggies.isEmpty {
                    
                    let res = compareData(arr1: educationAndWork, arr2: educationTaggyView.taggies)
                    for tag in res {
                        educationTaggyView.taggies.append(tag)
                    }
                }
                if !userEducationSet {
                    for education in educationAndWork {
                        educationTaggyView.taggies.append(education)
                    }
                    educationTaggyView.addTaggies()
                    educationHeight.constant = educationTaggyView.frame.size.height + 10
                    
                    userEducationSet = true

                }
            }
        }
    }

    func compareData(arr1: [String], arr2: [String]) -> [String] {
        
        let difference = arr1.filter({!arr2.contains($0)})
        
        return difference
    }
    func userWishesToSeeMore(informationType: UserInformationType) {
        switch informationType {
        case .preferences:
            preferencesHeight.constant = preferencesTaggyView.frame.size.height + 40
            selfProfileDetailsScrollView.contentSize.height += 45
            break;
        case .interests:
            interestsHeight.constant = interestsTaggyView.frame.size.height
            self.view.layoutIfNeeded()
            break;
        case .educationAndWork:
            educationHeight.constant = educationTaggyView.frame.size.height
            self.view.layoutIfNeeded()
            break;
        }
    }
    
    @IBAction func refreshTapped(_ sender: Any) {
        preferencesTaggyView.removeEveryting()
        interestsTaggyView.removeEveryting()
        educationTaggyView.removeEveryting()
        
        preferencesHeight.constant = 128
//        interestsHeight.constant = 128
//        educationHeight.constant = 128
        currentUser!.loadInPreferences { (loadedInPreferences) in
            for tag in loadedInPreferences {
                self.preferencesTaggyView.taggies.append(tag)
            }
            self.preferencesTaggyView.addTaggies()
        }
        currentUser!.loadInInterests { (loadedInInterests) in
            for tag in loadedInInterests {
                self.interestsTaggyView.taggies.append(tag)
            }
            self.interestsTaggyView.addTaggies()
        }
        currentUser!.loadInEducationAndWork { (loadedInEducation) in
            for tag in loadedInEducation {
                self.educationTaggyView.taggies.append(tag)
            }
            self.educationTaggyView.addTaggies()
        }
        
    }
    

    func flashIndicator(notification: NSNotification) {
        selfProfileDetailsScrollView.flashScrollIndicators()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func matchViewStylings() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [redColor.cgColor, washedOutOrangeColor.cgColor]
        gradientLayer.locations = [0.0,1.0]
        gradientLayer.frame = self.view.bounds
        profileDetailsContainer.alpha = 1.0
        
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }

}
