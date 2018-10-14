//
//  ChangeUserInfoViewController.swift
//  Blint
//
//  Created by Ferit Bölezek on 02/06/17.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class ChangeUserInfoViewController: UIViewController, UITextViewDelegate, DataInformationDelegate, CameraMoreViewDelegate, CameraViewDelegate {
    
    @IBOutlet weak var bioTextView: TextViewStylings!
    
    @IBOutlet weak var nameAndAgeBtn: ButtonStylings!
    
    @IBOutlet weak var genderBtn: ButtonStylings!
    
    @IBOutlet weak var relationshipBtn: ButtonStylings!
    
    @IBOutlet weak var profileImage: avatarView!
    
    @IBOutlet weak var saveBtn: UIButton!
    
    var currentUser: BlintUser?
    
    var photoChoiceView: PhotoChoices?
    
    var notificationView: NotificationView?
    
    var userDefaults = UserDefaults.standard
    
    var aboutMe: String!
    var name: String!
    var age: String!
    var gender: String!
    var relationshipStatus: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bioTextView.delegate = self
            if let keychainID = KeychainWrapper.standard.string(forKey: USER_UID) {
                if userDefaults.object(forKey: "currentProfilePhoto_\(keychainID)") != nil {
                    let imageSaved = UIImage(data: userDefaults.data(forKey: "currentProfilePhoto_\(keychainID)")!)
                    profileImage.image = imageSaved
                } else {
                    currentUser!.downloadCurrentUsersImageIfExists(completion: { (profileImage) in
                        self.profileImage.image = profileImage
                        
                    })
                }
            }
            
        if currentUser == nil {
            // TODO: Download user information only if the user has segued here from the More tab.
        } else {
            setupView()
        }
        saveBtn.isEnabled = false
        saveBtn.setTitleColor(UIColor(white: 0.5, alpha: 0.5), for: .normal)
        // Do any additional setup after loading the view.
    }
    
    private func setupView() {
        
        aboutMe = currentUser!.userInformation["aboutMe"] as! String
        name = currentUser!.userInformation["name"] as! String
        age = currentUser!.userInformation["age"] as! String
        gender = currentUser!.userInformation["gender"] as! String
        relationshipStatus = currentUser!.userInformation["relationshipStatus"] as! String
        
        bioTextView.text = aboutMe
        nameAndAgeBtn.setTitle(name + ", " + age, for: .normal) // TODO: SET GENDER AT START OF APP!!!!!!!!!!!!!
        genderBtn.setTitle(gender, for: .normal)
        relationshipBtn.setTitle(relationshipStatus, for: .normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func changeInfoBtnTapped(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            performSegue(withIdentifier: "changeUserInfo", sender: "nameAge")
        case 2:
            performSegue(withIdentifier: "changeUserInfo", sender: "gender")
        case 3:
            performSegue(withIdentifier: "changeUserInfo", sender: "relationship")
        default:
            break
            // What?
        }
    }
    @IBAction func generalViewTapped(_ sender: Any) {
        bioTextView.resignFirstResponder()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        saveBtn.isEnabled = true
        saveBtn.setTitleColor(UIColor(red: 52/255, green: 73/255, blue: 94/255, alpha: 1.0), for: .normal)
    }
    
    @IBAction func changeAvatarTapped(_ sender: Any) {
        if photoChoiceView == nil {
        if UIDevice.current.userInterfaceIdiom == .pad {
            photoChoiceView = PhotoChoices(frame: CGRect(x: (UIScreen.main.bounds.width / 2) - 250, y: UIScreen.main.bounds.height, width: 500, height: 320))
        } else {
            photoChoiceView = PhotoChoices(frame: CGRect(x: (UIScreen.main.bounds.width / 2) - 150, y: UIScreen.main.bounds.height, width: 300, height: 240))
        }
        photoChoiceView?.delegate = self
        self.view.addSubview(photoChoiceView!)
        UIView.animate(withDuration: 0.25) {
            if UIDevice.current.userInterfaceIdiom == .pad {
            self.photoChoiceView?.center.y -= 380
            } else {
                self.photoChoiceView?.center.y -= 300
            }
        }
    }
    }
    
    func cameraTapped() {
        performSegue(withIdentifier: "cameraView", sender: "camera")
        if photoChoiceView != nil {
            photoChoiceView?.removeFromSuperview()
            photoChoiceView = nil
        }
    }
    func libraryTapped() {
        performSegue(withIdentifier: "cameraView", sender: "library")
        if photoChoiceView != nil {
            photoChoiceView?.removeFromSuperview()
            photoChoiceView = nil
        }
    }
    func cancelTapped() {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseOut, animations: {
            if UIDevice.current.userInterfaceIdiom == .pad {
                self.photoChoiceView?.center.y += 380
            } else {
                self.photoChoiceView?.center.y += 300
            }
        }) { (completed) in
            self.photoChoiceView?.removeFromSuperview()
            self.photoChoiceView = nil
        }
    }
    
    func newPhotoChosen(theImage: UIImage) {
        profileImage.image = theImage
        
        currentUser!.updateUsersProfileimage(theImage: theImage) { (response) in
            if response == .failed {
                self.notificationView = NotificationView()
                self.notificationView?.addMeToView(notificationMessage: "Uploading the image failed, this is a possible network error. Please try again.", subviewMeTo: self.view)
                self.notificationView?.removeMe(timeUntilDeletion: 4.0, completion: {
                    self.notificationView?.removeFromSuperview()
                    self.notificationView = nil
                })
            } else {
                let imageAsData = UIImageJPEGRepresentation(theImage, 0.1)
                self.userDefaults.set(imageAsData!, forKey: "currentProfilePhoto_\(self.currentUser!.userKeychainID)")
            }
            
        }
        
        
    }
    
    func addLoading() {
        let loadingView = UIView()
        loadingView.frame = profileImage.bounds
        loadingView.backgroundColor = UIColor.clear
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = loadingView.bounds
        loadingView.addSubview(blurEffectView)
        
        let activitySpinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        activitySpinner.startAnimating()
        activitySpinner.frame = loadingView.bounds
        loadingView.addSubview(activitySpinner)
        
        profileImage.addSubview(loadingView)
        
        
    }
    
    @IBAction func saveBtnTapped(_ sender: Any) {
        if bioTextView.text == "" {
            DataService.standard.CURRENT_USER_REF.child("userInformation").updateChildValues(["aboutMe" : "empty"])
            bioTextView.resignFirstResponder()
        } else {
            DataService.standard.CURRENT_USER_REF.child("userInformation").updateChildValues(["aboutMe" : bioTextView.text])
            bioTextView.resignFirstResponder()
        }
    }
    func userInfoWasChanged(dataChanged: String, theData: String, secondaryData: String?) {
        switch dataChanged {
        case "name":
            if let secData = secondaryData {
                nameAndAgeBtn.setTitle("\(theData), \(secData)", for: .normal)
            } else {
                nameAndAgeBtn.setTitle("\(theData), \(age)", for: .normal)
            }
        case "gender":
            genderBtn.setTitle("\(theData)", for: .normal)
        case "relationshipStatus":
            relationshipBtn.setTitle("\(theData)", for: .normal)
        default:
            print("Not possible if new data information is implemented.")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let dest = segue.destination as? ChangingUserInformationViewController {
            dest.delegate = self
            dest.currentUser = self.currentUser!   // TODO: MAKE SURE USER SPECIFIC STUFF IS DOWNLOADED
            
            switch sender as! String {
            case "nameAge":
                dest.infoChanging = ChangingTypeOfInformation.nameAge
            case "gender":
                dest.infoChanging = ChangingTypeOfInformation.gender
            case "relationship":
                dest.infoChanging = ChangingTypeOfInformation.relationship
            default:
                print("error: Possible wrong identifier in ChangeUserInfoViewcontroller /prepare for segue/")
            }
        }
        if let dest = segue.destination as? CameraAndGalleryViewController {
            dest.sender = sender as! String
            dest.delegate = self
        }
        
    }
    
    
    
}
