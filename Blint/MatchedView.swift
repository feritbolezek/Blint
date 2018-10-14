//
//  MatchedView.swift
//  Blint
//
//  Created by Ferit Bölezek on 2017-06-16.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import UIKit

class MatchedView: UIView {

    @IBOutlet private weak var matchedSubLabel: UILabel!
    
    @IBOutlet weak var matchersAvatar: avatarView!
    
    @IBOutlet weak var matchedsAvatar: avatarView!
    
    private var nameOfMatch = ""
    
    var matchedWith: String {
        get {
            return nameOfMatch
        } set {
            nameOfMatch = newValue
            matchedSubLabel.text = "\(newValue) has been added to your chat list, Happy chattings!"
        }
        
    }
    
    weak var delegate: MatchedViewDelegate?
    
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
        self.alpha = 0.0
        let view = Bundle.main.loadNibNamed("MatchedView", owner: self, options: nil)?.first as! UIView
        
        view.frame = self.bounds
        
        self.addSubview(view)
        
        UIView.animate(withDuration: 0.10, animations: { 
            self.alpha = 1.0
        }) { (completed) in
            
        }
    }

    @IBAction func dismissTapped(_ sender: Any) {
        delegate?.userDismissedMatchedView()
        UIView.animate(withDuration: 0.10, animations: {
            self.alpha = 0.0
        }) { (completed) in
            self.removeFromSuperview()
        }
    }

}
