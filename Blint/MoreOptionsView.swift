//
//  MoreOptionsView.swift
//  Blint
//
//  Created by Ferit Bölezek on 2017-06-22.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import UIKit

class MoreOptionsView: UIView {
    
    weak var delegate: MoreViewDelegate?
    
    @IBOutlet weak var blockButton: UIButton!
    
    @IBOutlet weak var moreOptionsNameTitle: UILabel!
    
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
        
        let view = Bundle.main.loadNibNamed("moreOptions", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        
        self.addSubview(view)
    }
    
    @IBAction func reportThisUserTapped(_ sender: Any) {
        delegate?.reportUserTapped()
    }
    
    @IBAction func blockThisUserTapped(_ sender: Any) {
        delegate?.blockUserTapped()
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        delegate?.cancelTapped()
    }
    
    

}
