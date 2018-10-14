//
//  AccountSettingCell.swift
//  Blint
//
//  Created by Ferit Bölezek on 2017-07-02.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import UIKit

class AccountSettingCell: UICollectionViewCell {
    
    @IBOutlet weak var accountSettingLabel: UILabel!
    
    var theSetting: String {
        return accountSettingLabel.text!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0).cgColor
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
    }
    
    func setupView(accountSetting: String) {
        accountSettingLabel.text = accountSetting
    }
    
    
}
