//
//  AccountSettingsViewController.swift
//  Blint
//
//  Created by Ferit Bölezek on 2017-07-02.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import UIKit

class AccountSettingsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, NotificationViewDelegate {
    
    
    @IBOutlet weak var accountSettingsTableView: UICollectionView!
    
    var interactableNotifView: InteractableNotificationView?
    
    var notifView: NotificationView?
    
    var currentUser: BlintUser!
    
    var accountHasBeenDeletedNotification = Notification(name: Notification.Name(rawValue: "accountDeleted"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accountSettingsTableView.delegate = self
        accountSettingsTableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "accountSetting", for: indexPath) as! AccountSettingCell
        cell.setupView(accountSetting: "Delete account")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let accountSettingIdentifier = (collectionView.cellForItem(at: indexPath) as! AccountSettingCell).theSetting
        settingTapped(identifier: accountSettingIdentifier)
    }
    
    func settingTapped(identifier: String) {
        switch identifier {
        case "Delete account":
            addInteractableNotifView()
            break
        default:
            print("Should not happen, incorrect identifier from more settings.")
            break
        }
        
    }
    
    func addInteractableNotifView() {
        interactableNotifView = InteractableNotificationView()
        let notifMidX = (UIScreen.main.bounds.width / 2) - 140
        let notifMidY = (UIScreen.main.bounds.height / 6)
        interactableNotifView = InteractableNotificationView(frame: CGRect(x: notifMidX, y: notifMidY, width: 280, height: 200))
        interactableNotifView?.notificationMessage.text = "Are you sure you would like to delete your account? Your information will be deleted forever and will not be recoverable."
        self.view.addSubview(interactableNotifView!)
        interactableNotifView?.delegate = self
    }
    
    func interactableStandardTapped() {
        
    }
    func interactableDestructiveTapped() {
        notifView = NotificationView()
        notifView?.addMeToView(notificationMessage: "Deleting user...", subviewMeTo: self.view)
        currentUser.removeUserPermanently { (error) in
            if error {
                self.notifView?.notificationMessage = "Deleting failed, please try again."
                self.notifView?.removeMe(timeUntilDeletion: 3.0, completion: {
                
                })
            } else {
                self.notifView?.notificationMessage = "User deleted, signing out."
                self.notifView?.removeMe(timeUntilDeletion: 3.0, completion: {
                    self.performSegue(withIdentifier: "backToVC1", sender: nil)
                })
            }
        }
        
        
    }
    
    
    @IBAction func backBtnTapped(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
}
