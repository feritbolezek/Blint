//
//  ViewController.swift
//  Blint
//
//  Created by Ferit Bölezek on 10/04/17.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import SwiftKeychainWrapper

class ViewController: UIViewController, UITextFieldDelegate, SignUpChoiceDelegate, LoginDelegate, FirstTimeDelegate {

    @IBOutlet weak var nextButton: ButtonStylings!
    @IBOutlet weak var nameTextField: SignUpScreenTextFieldStylings!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var welcomeText: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    
    
    var userEmailAddressView: UserEmailAddressView? = nil
    var ageView: userAgeView? = nil
    var genderView: GenderSelection? = nil
    var passwordView: userPassword? = nil
    var currentView = CurrentViewVisible.nameView
    
    var usersEnteredPassword: String!
    var usersEnteredEmail: String!
    var usersEnteredName: String!
    var usersEnteredGender: String!
    var usersEnteredAge: String!
    
    var notifView: NotificationView?
    var loadingView: FullScreenLoadingView?
    
    var firebaseNodesSetup: FirebaseDatabaseNodesSetup?
    var userDataFacebook: UserDataFacebook?
    
    var currentUser: BlintUser?
    
    var amountOfTimeWithNoConnectivity = 0
    
    var timerToCheckConnectivity: Timer?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layoutIfNeeded()
       //  KeychainWrapper.standard.removeAllKeys()
        
        checkLoginStatus()
        nameTextField.delegate = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    func privacyTapped() {
        performSegue(withIdentifier: "privacyPolicy", sender: nil)
    }
    
    func termsTapped() {
        performSegue(withIdentifier: "terms", sender: nil)
    }
    
    func checkLoginStatus() {
        showLoading()
        
        if (AuthenticationService.standard.checkIfUserIsLoggedIn()) {
            currentUser = BlintUser()
            checkConnectivity()
            timerToCheckConnectivity = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(checkConnectivity), userInfo: nil, repeats: true)
            currentUser?.fetchData(userID: currentUser!.userKeychainID, dataToFetch: .fetchAllData, completion: {
                self.dismiss(animated: true, completion: nil)
                self.performSegue(withIdentifier: "mainApp", sender: nil)
                self.loadingView!.removeFromSuperview()
            })
        } else {
            UIView.animate(withDuration: 2.0, animations: {
                self.loadingView!.alpha = 0.0
            }, completion: { (completed) in
                self.loadingView!.removeFromSuperview()
            })
        }
    }
    
    func checkConnectivity() {
        currentUser!.checkConnection { (receivedResponse) in
            if receivedResponse {
                self.amountOfTimeWithNoConnectivity = 0
                self.loadingView?.internetConnetionLabel.text = "Received connection, retrying..."

            } else {
                self.amountOfTimeWithNoConnectivity += 1
            }
            if self.amountOfTimeWithNoConnectivity > 4 {
                self.amountOfTimeWithNoConnectivity = 0
            self.loadingView?.internetConnetionLabel.text = "We are having trouble loading in the information, please make sure you have an active internet connection."
                self.loadingView?.failedConnetion()
            }
        }
    }
    
    
    func showLoading() {
        loadingView = FullScreenLoadingView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        self.view.addSubview(loadingView!)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        nextButton.isHidden = false
        
        
        textField.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        textField.layer.shadowColor = UIColor.gray.cgColor
        textField.layer.shadowOffset = CGSize(width: 0, height: 0)
        textField.layer.shadowRadius = 2.0
        textField.layer.shadowOpacity = 1.0
        
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }

    @IBAction func signInTapped(_ sender: Any) {
        performSegue(withIdentifier: "LoginScreen", sender: nil)
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        
        nameTextField.resignFirstResponder()
        
        if let userName = nameTextField.text {
            if userName.characters.count > 0 {
                
                welcomeText.alpha = 0.0
                welcomeText.text = "Hello \(userName), please enter your email address below."
                usersEnteredName = userName
                
                transitionAwayFromName()
                
            }
        }

    }
    @IBAction func facebookLoginBtnTapped(_ sender: Any) {
        AuthenticationService.standard.authenticateWithFacebook(from: self) { (error, user) in
            
            if error != nil {
                self.addNotificationView(notificationMessage: "\(error!)")
                self.notifView!.removeMe(timeUntilDeletion: 10, completion: {
                    self.notifView = nil
                })
            } else {
                self.addNotificationView(notificationMessage: "Signing you in, please wait...")
                self.firebaseNodesSetup = FirebaseDatabaseNodesSetup()
                self.userDataFacebook = UserDataFacebook()
                
                self.userDataFacebook?.getGraphAPIData(completion: { (facebookDataDict) in
                    let userID = user as! User
                    self.firebaseNodesSetup?.setupNodesForNewUser(WithID: userID.uid, userInformation: facebookDataDict, completion: { (alreadyUser) in
                        if alreadyUser {
                            self.checkLoginStatus()
                            self.notifView?.notifView?.removeFromSuperview()
                            self.notifView?.removeFromSuperview()
                            self.notifView = nil
                        } else {
                            self.notifView?.notifView?.removeFromSuperview()
                            self.notifView?.removeFromSuperview()
                            self.notifView = nil
                            self.performSegue(withIdentifier: "FirstTime", sender: facebookDataDict["usersName"])
                        }
                        
                    })
                    
                })
                
//                self.firebaseNodesSetup?.setupNodesForNewUser(WithID: userID.uid, userInformation: self.setupData(theUser: userID))
            }
        }
    }


    func emailFilledIn(emailAddress: String) {
        
        if emailAddress.contains("@") && emailAddress.contains(".") && emailAddress.characters.last != "."{
        usersEnteredEmail = emailAddress
        transitionToAge()
        
        } else {
            userEmailAddressView?.incorrectInput()
        }
        
    }
    func ageFilledIn(age: String) {

        let userAge = Int(age)
        
        if let ageExists = userAge {
            if ageExists < 16 {
                ageView?.incorrectInput()
            } else {
                usersEnteredAge = String(ageExists)
            transitionToGender()
            }
        } else {
            ageView?.incorrectInput()
        }
    }
    func genderFilledIn(gender: String) {
        usersEnteredGender = gender
        transitionToPassword()
    }
    
    func passwordFilledIn(password: String) {
        
        usersEnteredPassword = password
        
        AuthenticationService.standard.signupUserWith(email: usersEnteredEmail, password: usersEnteredPassword) { (error, user) in
            
            if error != nil {
                if let passwordViewExists = self.passwordView {
                    passwordViewExists.incorrectInput(withError: error!)
                }
            } else {
                self.firebaseNodesSetup = FirebaseDatabaseNodesSetup()
                let userID = user as! User
               // let userInfo = [self.usersEnteredName, self.usersEnteredEmail, self.usersEnteredAge]
                let userInfo: Dictionary<String,String> = ["usersName" : self.usersEnteredName, "usersEmail" : self.usersEnteredEmail, "usersAge" : self.usersEnteredAge, "gender" : self.usersEnteredGender]
                self.firebaseNodesSetup?.setupNodesForNewUser(WithID: userID.uid, userInformation: userInfo, completion: { (alreadyUser) in
                    if alreadyUser {
                    self.checkLoginStatus()
                    } else {
                        self.performSegue(withIdentifier: "FirstTime", sender: self.usersEnteredName)
                    }
                })
            }
            
        }
        
    }
    func userWishesToContinue() {
        self.checkLoginStatus()
    }
    
    @IBAction func mainViewSwiped(_ sender: Any) {
        
        if nameTextField.isFirstResponder {
            nameTextField.resignFirstResponder()
        }
        if let emailViewActive = userEmailAddressView {
            emailViewActive.emailTextField.resignFirstResponder()
        }
        if let ageViewActive = ageView {
            ageViewActive.ageTextField.resignFirstResponder()
        }
        if let passwordViewActive = passwordView {
            passwordViewActive.passwordTextField.resignFirstResponder()
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.timerToCheckConnectivity?.invalidate()
        self.timerToCheckConnectivity = nil
        
        if segue.identifier == "mainApp" {
         let dest = segue.destination as! TabViewController
             dest.currentUser = self.currentUser!
        } else if segue.identifier == "LoginScreen" {
            let dest = segue.destination as! loginViewController
            dest.delegate = self
        } else if segue.identifier == "FirstTime" {
            let dest = segue.destination as! FirstTimeViewController
            dest.usersName = sender! as! String
            dest.delegate = self
        }
    }
    
    func userSignsIn() {
        checkLoginStatus()
    }
    
    
    @IBAction func backBtnTapped(_ sender: Any) {
        
        switch currentView {
        case .emailView:
            transitionToSignUpChoice()
            break
        case .passwordView:
            transitionAwayFromPassword()
            break
        case .ageView:
            transitionAwayFromAge(sender: "back")
        case .genderView:
            transitionAwayFromGender(sender: "back")
        default:
            break
            
        }
        
        
       // transitionAwayFromName() // Animations are kept in the LoginExtention
        
    }
    
    @IBAction func unwindToStartVC(segue: UIStoryboardSegue) {
    
    }
    
    
    func addNotificationView(notificationMessage: String) {
        
        let notifMidX = (UIScreen.main.bounds.width / 2) - 140
        let notifMidY = (UIScreen.main.bounds.height / 6)
         notifView = NotificationView(frame: CGRect(x: notifMidX, y: notifMidY, width: 280, height: 200))
        view.addSubview(notifView!)
        notifView?.notificationMessage = notificationMessage
    }

    
}

