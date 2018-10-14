//
//  NoMatchesFoundView.swift
//  Blint
//
//  Created by Ferit Bölezek on 2017-06-15.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import UIKit

class NoMatchesFoundView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
        
    }
    
    func setupView() {
        
        let view = Bundle.main.loadNibNamed("NoMatchesFoundView", owner: self, options: nil)?.first as! UIView
        
        view.frame = self.bounds
        
        self.addSubview(view)
        
    }

}
