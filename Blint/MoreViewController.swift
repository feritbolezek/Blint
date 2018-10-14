//
//  MoreViewController.swift
//  Blint
//
//  Created by Ferit Bölezek on 12/05/17.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import FBAudienceNetwork

class MoreViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, FBAdViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var viewForAd: UIView!
    
    @IBOutlet weak var moreCollectionView: UICollectionView!
    
    let moreOptions = MoreOptions.standard.moreOptions
    
    var currentUser: BlintUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let bottomBanner = FBAdView(placementID: "284776838629978_310979742676354", adSize: kFBAdSizeHeight50Banner, rootViewController: self)
        bottomBanner.frame = CGRect(x: 0, y: 0, width: bottomBanner.bounds.width, height: bottomBanner.bounds.height)
        bottomBanner.delegate = self
        bottomBanner.loadAd()
        self.viewForAd.addSubview(bottomBanner)
    }
    
    func adView(_ adView: FBAdView, didFailWithError error: Error) {
        adView.isHidden = true
    }
    func adViewDidLoad(_ adView: FBAdView) {
        adView.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return CGSize(width: 500, height: 70)
        } else {
            return CGSize(width: 343, height: 40)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moreOptions.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "moreCell", for: indexPath) as! MoreCell
        
        cell.setupView(moreOption: moreOptions[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let optionsIdentifier = (collectionView.cellForItem(at: indexPath) as! MoreCell).theOption.identifier!
        optionTapped(identifier: optionsIdentifier)
    }
    
    
    
    func optionTapped(identifier: String) {
    
        switch identifier {
        case "editInfo":
            performSegue(withIdentifier: "editInfo", sender: nil)
            break
        case "privacy":
            performSegue(withIdentifier: "privacy", sender: nil)
            break
        case "terms":
            performSegue(withIdentifier: "terms", sender: nil)
            break
        case "accSettings":
            performSegue(withIdentifier: "accountSettings", sender: nil)
            break
        case "logOut":
            KeychainWrapper.standard.removeAllKeys()
            performSegue(withIdentifier: "backToVC1", sender: nil)
            break
        default:
            print("Should not happen, incorrect identifier from more options.")
            break
        }
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? ChangeUserInfoViewController {
            dest.currentUser = self.currentUser
        }
        if let dest = segue.destination as? AccountSettingsViewController {
            dest.currentUser = self.currentUser
        }
    }
    
}
