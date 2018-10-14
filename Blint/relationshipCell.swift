//
//  relationshipCell.swift
//  Blint
//
//  Created by Ferit Bölezek on 03/06/17.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import UIKit

class relationshipCell: UITableViewCell {
    @IBOutlet weak var choiceLabel: UILabel!
    
    @IBOutlet weak var selectedIndicator: UIImageView!

    var relationshipLabelText: String {
        get {
            return choiceLabel.text!
        }
        set {
            choiceLabel.text = newValue
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
        selectedIndicator.image = UIImage(named: "CheckmarkSelected")
        } else {
        selectedIndicator.image = UIImage(named: "CheckmarkNotSelected")
        }
    }
    
    
    

}
