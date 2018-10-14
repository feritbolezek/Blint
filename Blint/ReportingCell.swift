//
//  ReportingCell.swift
//  Blint
//
//  Created by Ferit Bölezek on 2017-06-22.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import UIKit

class ReportingCell: UITableViewCell {

    @IBOutlet weak var reportingLabel: UILabel!
    
    @IBOutlet weak var reportingCheckMarkView: UIImageView!
    
    var reportingLabelText: String {
        get {
            return reportingLabel.text!
        }
        set {
            reportingLabel.text = newValue
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            reportingCheckMarkView.image = UIImage(named: "CheckmarkSelected")
            self.selectedBackgroundView?.backgroundColor = washedOutOrangeColor
            self.selectedBackgroundView?.alpha = 0.4
        } else {
            reportingCheckMarkView.image = UIImage(named: "CheckmarkNotSelected")
        }
    }

}
