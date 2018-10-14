//
//  AddMoreCell.swift
//  Blint
//
//  Created by Ferit Bölezek on 23/05/17.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import UIKit

class AddMoreCell: UITableViewCell {

    
    
    @IBOutlet weak var addMoreImage: UIImageView!
    
    @IBOutlet weak var addMoreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(labelText: String, imageForLabel: UIImage) {
        addMoreLabel.text = "Add more " + labelText.lowercased()
        addMoreImage.image = imageForLabel
    }

}
