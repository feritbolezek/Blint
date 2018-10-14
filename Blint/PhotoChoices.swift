//
//  PhotoChoices.swift
//  Blint
//
//  Created by Ferit Bölezek on 2017-06-23.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import UIKit

class PhotoChoices: UIView {
    
    weak var delegate: CameraMoreViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layoutView()
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutView()
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layoutView()
    }
    
    func layoutView() {
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        
        let view = Bundle.main.loadNibNamed("PhotoChoices", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        
        self.addSubview(view)
    }
    
    @IBAction func cameraTapped(_ sender: Any) {
        delegate?.cameraTapped()
    }
    
    @IBAction func libraryTapped(_ sender: Any) {
        delegate?.libraryTapped()
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        delegate?.cancelTapped()
    }
    
    
    
    
}
