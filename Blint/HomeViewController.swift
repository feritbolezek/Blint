//
//  HomeViewController.swift
//  Blint
//
//  Created by Ferit Bölezek on 04/05/17.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import UIKit
import AudioToolbox
import Firebase

class HomeViewController: UIViewController, UICollisionBehaviorDelegate, MatchingSystemDelegate, DataInformationDelegate, MatchedViewDelegate {

    @IBOutlet weak var matchView: UIView!
    
    @IBOutlet weak var quickBioTextView: UITextView!
    
    @IBOutlet weak var commonInterestsTextView: UITextView!
    
    @IBOutlet weak var matchedPreferencesTextView: UITextView!

    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var nopeButton: UIButton!
    
    @IBOutlet weak var noMatchesView: UIView!
    
    
    var snapBehaviour: UISnapBehavior?
    var collisionBehaviour: UICollisionBehavior?
    var gravityBehaviour: UIGravityBehavior?
    
    var dynamicAnimator: UIDynamicAnimator?
    
    var matchedView: MatchedView?
    
    var startingPos: CGFloat!
    
    let generator = UIImpactFeedbackGenerator(style: .light)
    
    var loaded = false
    
    var matchToShow = 0
    
    var matchableUsers = [Matches]()
    
    var latestMatch = Matches()
    
    var noMatchesFoundView: NoMatchesFoundView?
    
    weak var delegate: HomeViewDelegate?

    let rematching = Notification.Name("rematch") // Called if changes to the users information/specifics are made.
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
     var currentUser: BlintUser!
    let matching = MatchingSystem()
    override func viewDidLoad() {
        super.viewDidLoad()
        
            matching.delegate = self
            setupDetailsView()
        NotificationCenter.default.addObserver(self, selector: #selector(rematchingPossible), name: rematching, object: nil)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !loaded {
            matching.startMatching(forUser: currentUser)
            loaded = true
        }
    }
    func rematchingPossible(notification: NSNotification) {
        matching.firstSearch = true
        loaded = false
    }
    
    func setupDetailsView() {
    
        startingPos = matchView.frame.maxY
        
        matchView.frame = CGRect(x: 0, y: -view.bounds.height + 222, width: view.bounds.width, height: view.bounds.height)
        
        dynamicAnimator = UIDynamicAnimator(referenceView: self.view)
        
        
        let dragDownMenu = UIPanGestureRecognizer(target: self, action: #selector(dragDown(sender:)))
        view.addGestureRecognizer(dragDownMenu)
        matchView.isUserInteractionEnabled = true
    }

    func readyToDisplayMatches(matches: [Matches]) {
        if noMatchesFoundView != nil {
            noMatchesFoundView?.removeFromSuperview()
            noMatchesFoundView = nil
        }
        latestMatch = matches[0]
        nopeButton.isEnabled = true
        likeButton.isEnabled = true
        matchableUsers = matches
        quickBioTextView.text = matches[0].usersBio
        
        commonInterestsTextView.text = ""
        matchedPreferencesTextView.text = ""
        
        let lengthInt = matches[0].matchedInterests.count - 1
        let lengthPref = matches[0].matchedPreferences.count - 1
        if lengthInt >= 0 {
        for index in 0...lengthInt {
            if index != lengthInt {
                commonInterestsTextView.text.append(matches[0].matchedInterests[index].capitalized + ", ")
            } else {
                commonInterestsTextView.text.append(matches[0].matchedInterests[index].capitalized + ".")
            }
        }
        }
        for index in 0...lengthPref {
            if index != lengthPref {
                matchedPreferencesTextView.text.append(matches[0].matchedPreferences[index].capitalized + ", ")
            } else {
                matchedPreferencesTextView.text.append(matches[0].matchedPreferences[index].capitalized + ".")
            }
        }

        delegate?.displayUserInfo(matches: matches)
    }
    
    func readyToDisplayProfilePhotoFor(match: Matches, profilePhoto: UIImage) {
        if match.theUser.userID == matchableUsers[0].theUser.userID {
            delegate?.profileImageReadyToDisplay(match: match, theImage: profilePhoto)
        }
    }
    
    func noMatchesFound() {
         noMatchesFoundView = NoMatchesFoundView(frame: CGRect(x: 0, y: 0, width: noMatchesView.frame.width, height: noMatchesView.frame.height))
        noMatchesView.addSubview(noMatchesFoundView!)
        delegate?.noMatches()
        
    }
    
    @IBAction func likeTapped(_ sender: Any) {
        let timeOfLike = NSDate().timeIntervalSince1970
        matching.addToLikedList(likedUsersID: matchableUsers[0].theUser.userID, timeOfLike: timeOfLike)
        matching.checkIfMatchHasLikedMe(matchedUsersID: matchableUsers[0].theUser.userID) { (result) in
            if result == "notLiked" {
                self.delegate?.likeTapped()
                self.matchableUsers.remove(at: 0)
                if self.matchableUsers.count == 0 {
                    self.likeButton.isEnabled = false
                    self.matching.nextMatching(latestMatch: self.latestMatch)
                    
                } else {
                    self.readyToDisplayMatches(matches: self.matchableUsers)
                }
                
            } else if result == "liked" {
                self.matching.saveToMatches(user: self.matchableUsers[0].theUser)
                self.triggerDynamicPushNotification(matchedWith: self.matchableUsers[0])
                self.matchedView = MatchedView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
                self.matchedView?.matchedWith = self.matchableUsers[0].usersName
                self.matchedView?.delegate = self
                self.view.addSubview(self.matchedView!)
                
                
            }
        }
        
    }
    func userDismissedMatchedView() {
        self.delegate?.likeTapped()
        self.matchableUsers.remove(at: 0)
        if self.matchableUsers.count == 0 {
            self.likeButton.isEnabled = false
            self.matching.nextMatching(latestMatch: self.latestMatch)
            
        } else {
            self.readyToDisplayMatches(matches: self.matchableUsers)
        }
    }

    @IBAction func nopeTapped(_ sender: Any) {
        
        delegate?.nopeTapped()
        
        let timeOfReject = NSDate().timeIntervalSince1970
        matching.addToRejectList(rejectedUsersID: matchableUsers[0].theUser.userID, timeOfRejection: timeOfReject)
        
        matchableUsers.remove(at: 0)

            if matchableUsers.count == 0 {
                nopeButton.isEnabled = false
                matching.nextMatching(latestMatch: latestMatch)
                
            } else {
                readyToDisplayMatches(matches: matchableUsers)
            }
    }
    
    func triggerDynamicPushNotification(matchedWith: Matches) {
        if let matchedWithFCMToken = matchedWith.FCMToken {
            let userInformation = ["matchedWithUserToken" : matchedWithFCMToken, "matchedWithUserGender" : (self.currentUser.userInformation["gender"] as! String).capitalized, "usersName" : (self.currentUser.userInformation["name"] as! String).capitalized]
            let jsonData = try? JSONSerialization.data(withJSONObject: userInformation)
            
            let functionURL = URL(string: "https://us-central1-blint-fc74b.cloudfunctions.net/DoesNotExistAnymoreForSafetyReasons")!
            var request = URLRequest(url: functionURL)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            let task = URLSession.shared.dataTask(with: request)
            task.resume()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! == "showMatchDetails" {
            let dest = segue.destination as! matchDetailsViewController
            dest.homeVC = self
        } else if segue.identifier! == "reportUser" {
            let dest = segue.destination as! ReportUserViewController
            let reportedUserID = matchableUsers[0].theUser.userID
            let currentUsersName = currentUser.userInformation["name"] as! String
            dest.reportedUsersID = reportedUserID
            dest.reportedUsersName = matchableUsers[0].usersName
            dest.userReportingID = currentUser.userKeychainID
            dest.userReportingName = currentUsersName
        }
    }
    @IBAction func reportUserTapped(_ sender: Any) {
        performSegue(withIdentifier: "reportUser", sender: nil)
    }
    
    func dragDown(sender: UIPanGestureRecognizer) {
        matchView.frame.origin.y = matchView.frame.origin.y + sender.velocity(in: self.view).y * 0.02
        if sender.state == .ended {
            if sender.location(in: self.view).y > UIScreen.main.bounds.height / 2 {
                if matchView.frame.origin.y >= UIScreen.main.bounds.height / 2 {
                    animateUp()
                } else {
                animateDown()
                }
                
            } else {
                animateUp()
                
            }
        }

    }
    
    func animateDown() {
        if dynamicAnimator?.behaviors != nil {
            dynamicAnimator?.removeAllBehaviors()
        }
        gravityBehaviour = UIGravityBehavior(items: [matchView])
        gravityBehaviour?.gravityDirection = CGVector(dx: 0, dy: 10.0)
        gravityBehaviour?.magnitude = 1
        
        collisionBehaviour = UICollisionBehavior(items: [matchView])
        collisionBehaviour?.removeAllBoundaries()
        collisionBehaviour?.addBoundary(withIdentifier: "bottomBoundry" as NSCopying, from: CGPoint(x:0, y:self.view.frame.maxY + 2), to: CGPoint(x:UIScreen.main.bounds.width, y:self.view.frame.maxY + 2))
        collisionBehaviour?.collisionDelegate = self
        
        dynamicAnimator?.addBehavior(collisionBehaviour!)
        dynamicAnimator?.addBehavior(gravityBehaviour!)
        
    }
    func animateUp() {
        if dynamicAnimator?.behaviors != nil {
            dynamicAnimator?.removeAllBehaviors()
        }
        gravityBehaviour = UIGravityBehavior(items: [matchView])
        gravityBehaviour?.gravityDirection = CGVector(dx: 0, dy: -10.0)
        gravityBehaviour?.magnitude = 1
        
        
        collisionBehaviour = UICollisionBehavior(items: [matchView])
        collisionBehaviour?.removeAllBoundaries()
        collisionBehaviour?.addBoundary(withIdentifier: "topBoundary" as NSCopying, from: CGPoint(x:0, y:startingPos - matchView.bounds.height), to: CGPoint(x:UIScreen.main.bounds.width, y: startingPos - matchView.bounds.height))
        collisionBehaviour?.collisionDelegate = self
        
        dynamicAnimator?.addBehavior(collisionBehaviour!)
        dynamicAnimator?.addBehavior(gravityBehaviour!)
    }
    func collisionBehavior(_ behavior: UICollisionBehavior, endedContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?) {
        if let ident = identifier as? String {
            if ident == "bottomBoundry" {
                NotificationCenter.default.post(name: NSNotification.Name("matchContainerAtBottom"), object: nil)
                generator.impactOccurred()
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
