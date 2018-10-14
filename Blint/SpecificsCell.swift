//
//  SpecificsCell.swift
//  Blint
//
//  Created by Ferit Bölezek on 22/05/17.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import UIKit

class SpecificsCell: UITableViewCell {
    
    @IBOutlet weak var specificsLabel: UILabel!

    
    func setupView(text: String) {
        
        specificsLabel.text = text
    }
    
}
