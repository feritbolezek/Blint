//
//  TaggyItemCell.swift
//  Blint
//
//  Created by Ferit Bölezek on 20/05/17.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import UIKit

class TaggyItemCell: UICollectionViewCell {
    
    var cellWidth: CGFloat!
    
    func setupView(taggyToShow: Taggy) {
        print("THE SIZE \(taggyToShow.frame.size.width)")
        self.cellWidth = taggyToShow.frame.size.width
        
        self.frame.size = taggyToShow.frame.size
        
        addSubview(taggyToShow)
        
        self.sizeToFit()
    }
    
    
    
    
}
