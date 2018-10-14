//
//  FullScreenLoadingView.swift
//  Blint
//
//  Created by Ferit Bölezek on 15/05/17.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import UIKit

class FullScreenLoadingView: UIView {

    
    
    @IBOutlet weak var internetConnetionLabel: UILabel!
    
    
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
        
        let view = Bundle.main.loadNibNamed("FullScreenLoadingView", owner: self, options: nil)?.first as! UIView
        
        view.frame = self.bounds
        
        self.addSubview(view)
        
    }
    
    func failedConnetion() {
        internetConnetionLabel.isHidden = false
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseIn, animations: { 
            self.internetConnetionLabel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseIn, animations: {
            self.internetConnetionLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 1.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseIn, animations: {
            self.internetConnetionLabel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 1.5, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseIn, animations: {
            self.internetConnetionLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: nil)

    }
}
