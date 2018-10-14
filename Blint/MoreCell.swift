//
//  MoreCell.swift
//  Blint
//
//  Created by Ferit Bölezek on 12/05/17.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import UIKit

class MoreCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var theOption: MoreOption!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0).cgColor
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
    }
    
    func setupView(moreOption: MoreOption) {
        theOption = moreOption
        
        if let imageExists = moreOption.optionImagePath {
            imageView.image = UIImage(named: imageExists)
        }
        
        titleLabel.text = moreOption.optionName
    }
    
    
}
