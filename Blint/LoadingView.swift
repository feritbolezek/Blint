//
//  LoadingView.swift
//  Blint
//
//  Created by Ferit Bölezek on 17/05/17.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import UIKit

class LoadingView: UIView {

    @IBOutlet weak var loadingImage: UIImageView!
    
    @IBOutlet weak var loadingText: UILabel!
    
    
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
        
        let view = Bundle.main.loadNibNamed("LoadingView", owner: self, options: nil)?.first as! UIView
        
        view.frame = self.bounds
        
        self.addSubview(view)
        
        animateImage()
    }
    
    func animateImage() {
        
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveLinear, animations: {
            
            self.loadingImage.transform = self.loadingImage.transform.rotated(by: CGFloat(M_PI))
            
        }) { (completed) in
            self.animateImage()
        }
        
    }
    
}
