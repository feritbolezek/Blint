//
//  MatchingSystem.swift
//  Blint
//
//  Created by Ferit Bölezek on 05/06/17.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import Foundation
import Firebase

class MatchingSystem {
    
    
    private var userBeingMatched: BlintUser!
    
    /* the current users preferences,interests and education. */
    private var userBeingMatchedPreferences = [String]()
    private var userBeingMatchedInterests = [String]()
    private var userBeingMatchedEducation = [String]()
    
    private var firstUserID: String!
    private var amountofUsersInFB: Int!
    
    private var usersToMatch = [BlintUser]()
    
    private var worthyMatches = [Matches]()
    
    private var randomUsers = [String]()
    
    /* common stuff found */
    private var matchingPreferencesFound = [String]()
    private var matchingInterestsFound = [String]()
    private var matchingEducationFound = [String]()
    
    weak var delegate: MatchingSystemDelegate?
    
    var firstSearch = true
    
    var blocksWorkedThrough = 1
    
    var usersWorkedThrough = -1
    
    var lastUserOfEverySearch = ""  // This is the ID of the last person of every search, no matter if the user was a match or not.
    
    func startMatching(forUser: BlintUser) {
        userBeingMatched = forUser
        blocksWorkedThrough = 1
        usersWorkedThrough = -1
        worthyMatches = [Matches]()
        matchingPreferencesFound = [String]()
        matchingEducationFound = [String]()
        matchingInterestsFound = [String]()
        setupComparables()
        
    }
    
    func nextMatching(latestMatch: Matches) {
        worthyMatches = [Matches]()
        usersToMatch = [BlintUser]()
        matchingPreferencesFound = [String]()
        matchingEducationFound = [String]()
        matchingInterestsFound = [String]()
        loadInMatchables(latestMatch: latestMatch.theUser)
        if (latestMatch.theUser.accessibilityViewIsModal) {
            latestMatch.theUser.assignValues()
        }
    }

    private func setupComparables() {
        
            self.userBeingMatched.loadInPreferences { (preferences) in
                self.userBeingMatchedPreferences = preferences
            }
            self.userBeingMatched.loadInInterests { (interests) in
                self.userBeingMatchedInterests = interests
            }
            self.userBeingMatched.loadInEducationAndWork { (education) in
                self.userBeingMatchedEducation = education
                if self.firstSearch {
                    self.firstUser {
                        self.amountOfUsers()
                    }
                    self.firstSearch = false
                }
            }
     

    }
    
    private func loadInMatchables(latestMatch: BlintUser? = nil) {
        let dispatchGroup = DispatchGroup()
    
        if amountofUsersInFB > 50 && blocksWorkedThrough == 1 {
            if randomUsers.count > 0 {
            let randomPick = arc4random_uniform(UInt32(randomUsers.count - 1))
            firstUserID = randomUsers[Int(randomPick)]
            }
        }
        DataService.standard.USERS_REF.queryStarting(atValue: nil, childKey: firstUserID).queryLimited(toFirst: 11).observeSingleEvent(of: .value, with: { (snapshot) in
            let snap = snapshot.children.allObjects as! [DataSnapshot]
            for user in snap {
                dispatchGroup.enter()
                if let userDict = user.value as? Dictionary<String,Any> {
                    let matchAttemptUser = BlintUser(matchAttemptUserID: user.key, userDict: userDict)
                    self.checkIfRejected(potentiallyRejectedUsersID: user.key, completion: { (status) in
                        self.checkIfLiked(potentiallyLikedUsersID: user.key, completion: { (liked) in
                            
                            if liked == "notLiked" && matchAttemptUser.userInformation["name"] != nil {
                                
                                if status == "rejected" {
                                    
                                } else {
                                    if let matched = latestMatch?.userID {
                                        if matched == matchAttemptUser.userID {     // checks if it's the same user
                                            // not added
                                        } else {    // adds the user
                                            if user.key != self.userBeingMatched.userKeychainID {
                                                self.usersToMatch.append(matchAttemptUser)
                                            }
                                        }
                                        
                                    } else {
                                        if user.key != self.userBeingMatched.userKeychainID {
                                            self.usersToMatch.append(matchAttemptUser)
                                        }
                                    }
                                }
                            }
                            dispatchGroup.leave()
                        })
                    })
                    
                    
                   self.lastUserOfEverySearch = user.key
                }
               self.usersWorkedThrough += 1
            }
            if self.usersWorkedThrough > self.amountofUsersInFB {
                self.delegate?.noMatchesFound()
                return
            }
            
            dispatchGroup.notify(queue: .main, execute: { 
                if self.usersToMatch.count == 0 {
                    self.blocksWorkedThrough += 1
                    self.firstUserID = self.lastUserOfEverySearch
                    
                    if (self.blocksWorkedThrough * 11) > self.amountofUsersInFB + 11 {
                        self.firstUser { }
                    }
                    if self.blocksWorkedThrough >= 15 {
                        self.delegate?.noMatchesFound()
                        return
                    }
                    self.loadInMatchables()
                    return
                }
                self.firstUserID = self.usersToMatch.last!.userID
                self.loadInUsersMatchableUsersData { self.findMatch() }
            })
            
        })

    }
    
    private func loadInUsersMatchableUsersData(completion: @escaping () -> ()) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            let dispatchGroup = DispatchGroup()
            
            
            for user in self.usersToMatch {
                dispatchGroup.enter()
                user.fetchUserData(dataToFetch: .fetchUserSpecifics, forUserID: user.userID, completion: {
                    if (user.userInformation["name"] != nil) {
                    user.downloadAllComparableData {
                        dispatchGroup.leave()
                        }
                    } else {
                        let removeAt = self.usersToMatch.index(of: user)
                        self.usersToMatch.remove(at: removeAt!)
                    }
                })
            }

            dispatchGroup.notify(queue: .main, execute: {
                completion()
            })
        }
    }
    
    private func findMatch() {
        
        for user in usersToMatch {
            var matchingUsersInformation = [String]()
            var matchingInterests = [String]()
            var matchingEducation = [String]()
            
            matchingInterestsFound = [String]()
            matchingEducationFound = [String]()
            matchingPreferencesFound = [String]()
            
            for (key,val) in user.userInformation {
                if key != "aboutMe" {
                    if let receivedNum = val as? Int {
                        matchingUsersInformation.append(String(receivedNum))
                    } else {
                        matchingUsersInformation.append(val as! String)
                    }
                    
                }
            }
            for interest in user.userInterestsLabels {
                matchingInterests.append(interest)
            }
            for education in user.userEducationAndWorkLabels {
                matchingEducation.append(education)
            }
            compareData(user: user, data1: [matchingUsersInformation, matchingInterests, matchingEducation], data2: [self.userBeingMatchedPreferences, self.userBeingMatchedInterests, self.userBeingMatchedEducation])
        }
        if worthyMatches.count != 0 {
        delegate?.readyToDisplayMatches(matches: self.worthyMatches)
        } else {
            delegate?.noMatchesFound()
        }
    }
    
    private func compareData(user: BlintUser, data1: [[String]], data2: [[String]]) {
        for lhs in data1[0] {
            for rhs in data2[0] {
                if lhs.lowercased() == rhs.lowercased() {
                    matchingPreferencesFound.append(lhs)
                }
            }
        }
        for lhs in data1[1] {
            for rhs in data2[1] {
                if lhs.lowercased() == rhs.lowercased() {
                    matchingInterestsFound.append(lhs)
                }
            }
        }
        for lhs in data1[2] {
            for rhs in data2[2] {
                if lhs.lowercased() == rhs.lowercased() {
                    matchingEducationFound.append(lhs)
                }
            }
        }
        
        
        
        if !matchingPreferencesFound.isEmpty {
            addToMatches(user: user, matchingPreferences: matchingPreferencesFound, commonInterests: matchingInterestsFound, matchingEducation: matchingEducationFound)
            matchingPreferencesFound.removeAll()
        }
    }
    
    private func addToMatches(user: BlintUser, matchingPreferences: [String], commonInterests: [String], matchingEducation: [String]) {
        
        let match = Matches(user: user, matchPrefs: matchingPreferences, matchInts: commonInterests, matchEdu: matchingEducation)
        if let userHasProfilePhoto = user.userInformation["profilePhotoID"] as? String {
            downloadProfilePhotosForWorthyMatches(match: match, profilePhotoID: userHasProfilePhoto)
        }
        worthyMatches.append(match)
    }
    
    private func downloadProfilePhotosForWorthyMatches(match: Matches, profilePhotoID: String) {
        DataService.standard.PROFILE_PHOTOS_REF.child(profilePhotoID).getData(maxSize: 1024 * 1000) { (data, error) in
            if error != nil {
                // Display standard photo, downloading image failed.
            } else {
                let profileImage = UIImage(data: data!)
                match.usersProfileImage = profileImage!
                self.delegate?.readyToDisplayProfilePhotoFor(match: match, profilePhoto: profileImage!)
            }
        }
    }
    
    private func firstUser(completion: @escaping () -> ()) {
        DataService.standard.USERS_REF.queryLimited(toFirst: 1).observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapKey = snapshot.value as? Dictionary<String,Any> {
                self.firstUserID = snapKey.keys.first!
                completion()
            }
        })
    }
    private func amountOfUsers() {
        DataService.standard.UTILITIES_REF.child("amountOfUsers").observeSingleEvent(of: .value, with: { (snapshot) in
            self.amountofUsersInFB = snapshot.value as! Int
            self.loadInMatchables()
        })
    }
    
    
    private func checkIfRejected(potentiallyRejectedUsersID: String, completion: @escaping (_ status: String) -> ()) {
        DataService.standard.USERS_REJECTED_REF.child(userBeingMatched.userKeychainID).child(potentiallyRejectedUsersID).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.value is NSNull {
                completion("notRejected")
            } else {
                completion("rejected")
            }
        })
    }
    
    private func checkIfLiked(potentiallyLikedUsersID: String, completion: @escaping (_ status: String) -> ()) {
        DataService.standard.USERS_LIKED_REF.child(userBeingMatched.userKeychainID).child(potentiallyLikedUsersID).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.value is NSNull {
                completion("notLiked")
            } else {
                completion("liked")
            }
        })
    }
    
    func checkIfMatchHasLikedMe(matchedUsersID: String, completion: @escaping (_ status: String) -> ()) {
        DataService.standard.USERS_LIKED_REF.child(matchedUsersID).child(userBeingMatched.userKeychainID).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.value is NSNull {
                completion("notLiked")
            } else {
                completion("liked") // It's a match!!!
            }
        })
    }
    /// The paramater is the user that THE CURRENT USER was matched with.
    func saveToMatches(user: BlintUser) {
        let matchingReference = userBeingMatched.userInformation["matchesReference"] as! String
        let matchingReferenceForMatchedUser = user.userInformation["matchesReference"] as! String
        let UUIDForChat = NSUUID().uuidString
        DataService.standard.MATCHES_REF.child(matchingReference).updateChildValues([user.userID : UUIDForChat])
        DataService.standard.MATCHES_REF.child(matchingReferenceForMatchedUser).updateChildValues([userBeingMatched.userKeychainID : UUIDForChat]) { (error, reference) in
            self.createNewChat(underID: UUIDForChat, userMatchedWith: user)
        }
        
    }
    
    private func createNewChat(underID: String, userMatchedWith: BlintUser) {
        let currentUsersName = userBeingMatched.userInformation["name"] as! String
        let userMatchedWithName = userMatchedWith.userInformation["name"] as! String
        DataService.standard.CHATS_REF.child(underID).child("chatDetails").child("chatters").updateChildValues([currentUsersName : userBeingMatched.userKeychainID, userMatchedWithName : userMatchedWith.userID])
        DataService.standard.CHATS_REF.child(underID).child("chatDetails").updateChildValues(["timestamp" : String(describing: Date.init())])
        
    }
    
    func addToRejectList(rejectedUsersID: String, timeOfRejection: TimeInterval) {
        DataService.standard.USERS_REJECTED_REF.child(userBeingMatched.userKeychainID).updateChildValues([rejectedUsersID : "\(timeOfRejection)"])
    }
    
    func addToLikedList(likedUsersID: String, timeOfLike: TimeInterval) {
        DataService.standard.USERS_LIKED_REF.child(userBeingMatched.userKeychainID).updateChildValues([likedUsersID : "\(timeOfLike)"])
    }
    
    func loadInRandomizedUsersIndex() {
        DataService.standard.RANDOM_USERS_REF.child("randomizedSelection").observeSingleEvent(of: .value, with: { (snapshot) in
            
             self.randomUsers = (snapshot.value as! String).components(separatedBy: ",")
            
        })
        
    }
    
}
