//
//  matchDetailsViewController.swift
//  Blint
//
//  Created by Ferit Bölezek on 05/05/17.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import UIKit

class matchDetailsViewController: UIViewController, HomeViewDelegate, TaggyViewDelegate {
    
    func userWishesToSeeMore(informationType: UserInformationType) {
        
    }

    @IBOutlet weak var relationshipLabel: UILabel!
    
    
    @IBOutlet weak var nameAndAgeLabel: UILabel!
    
    @IBOutlet weak var commonInterestsLabel: UILabel!
    
    @IBOutlet weak var aboutMeTextView: UITextView!
    
    @IBOutlet weak var preferencesTaggyView: TaggyView!
    
    @IBOutlet weak var interestsTaggyView: TaggyView!
    
    @IBOutlet weak var educationTaggyView: TaggyView!
    
    @IBOutlet weak var profilePhotoView: avatarView!
    
    @IBOutlet weak var preferencesHeight: NSLayoutConstraint!
    
    @IBOutlet weak var interestsHeight: NSLayoutConstraint!
    
    @IBOutlet weak var educationHeight: NSLayoutConstraint!
    
    @IBOutlet weak var matchDetailsScrollView: UIScrollView!
    
    
    var homeVC: HomeViewController!
    
    var matchedUser: BlintUser?
    
    var userPreferencesSet = false
    var userInterestsSet = false
    var userEducationSet = false
    
    var matchToShow = 0
    
    var matchableUsers = [Matches]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taggyViewsSetup()
        matchViewStylings()
        homeVC.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(flashIndicator), name: NSNotification.Name("matchContainerAtBottom"), object: nil)
    }
    func taggyViewsSetup() {
        preferencesTaggyView.delegate = self
        interestsTaggyView.delegate = self
        educationTaggyView.delegate = self
        
        preferencesTaggyView.typeOfData = .preferences
        interestsTaggyView.typeOfData = .interests
        educationTaggyView.typeOfData = .educationAndWork
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
        
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
        self.view.layer.shadowColor = UIColor.black.cgColor
        self.view.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.view.layer.shadowRadius = 3.0
        self.view.layer.shadowOpacity = 0.8
    }
    
    func displayUserInfo(matches: [Matches]) {
        matchableUsers = matches
        matchedUser = matches[0].theUser
        if matches[0].usersProfileImage != nil {
            profilePhotoView.image = matches[0].usersProfileImage
        } else {
            profilePhotoView.image = UIImage(named: "NoPhoto")
        }
        nameAndAgeLabel.text = "\(matches[0].usersName!), \(matches[0].usersAge!)"
        commonInterestsLabel.text = "\(matches[0].matchedInterests.count) common interests, swipe me down!"
        aboutMeTextView.text = "\(matches[0].theUser.userInformation["aboutMe"] as! String)"
        relationshipLabel.text = "\(matches[0].theUser.userInformation["relationshipStatus"] as! String)"
        
        displayData(type: "preferences")
        displayData(type: "interests")
        displayData(type: "educationAndWork")
        
    }
    func fetchedInformationFor(type: String) {
        displayData(type: type)
        
    }
    func displayData(type: String) {
        if type == "preferences" {
            if let preferences = matchedUser?.userPreferencesLabels {
                
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
            if let interests = matchedUser?.userInterestsLabels {
                if !interestsTaggyView.taggies.isEmpty {
                    
                    let res = compareData(arr1: interests, arr2: interestsTaggyView.taggies)
                    for tag in res {
                        interestsTaggyView.taggies.append(tag)
                    }
                }
                if !userInterestsSet {
                    if interests.count > 0 {
                    for interest in interests {
                        interestsTaggyView.taggies.append(interest)
                    }
                    interestsTaggyView.addTaggies()
                    interestsHeight.constant = interestsTaggyView.frame.size.height + 10
                    
                    userInterestsSet = true
                    }
                }
            }
        } else if type == "educationAndWork" {
            if let educationAndWork = matchedUser?.userEducationAndWorkLabels {
                if !educationTaggyView.taggies.isEmpty {
                    
                    let res = compareData(arr1: educationAndWork, arr2: educationTaggyView.taggies)
                    for tag in res {
                        educationTaggyView.taggies.append(tag)
                    }
                }
                if !userEducationSet {
                    if educationAndWork.count > 0 {
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
    }
    func compareData(arr1: [String], arr2: [String]) -> [String] {
        
        let difference = arr1.filter({!arr2.contains($0)})
        
        return difference
    }
    
    func likeTapped() {
        matchableUsers.remove(at: 0)
        if matchableUsers.count == 0 {
            
        } else {
            displayUserInfo(matches: matchableUsers)
        }
    }
    
    func nopeTapped() {
        matchableUsers.remove(at: 0)
        if matchableUsers.count == 0 {
            
        } else {
            displayUserInfo(matches: matchableUsers)
        }
    }
    
    
    func noMatches() {
        nameAndAgeLabel.text = "Ouch... :("
        commonInterestsLabel.text = "No matches found."
        profilePhotoView.image = UIImage(named: "NoPhoto")
    }
    
    func profileImageReadyToDisplay(match: Matches, theImage: UIImage) {
        profilePhotoView.image = theImage
    }
    
    
    func flashIndicator(notification: NSNotification) {
        matchDetailsScrollView.flashScrollIndicators()
    }
    

}
