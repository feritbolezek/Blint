//
//  InteractableNotificationView.swift
//  Blint
//
//  Created by Ferit Bölezek on 2017-07-06.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import UIKit

class InteractableNotificationView: UIView {

    @IBOutlet weak var notificationMessage: UILabel!
    
    var notifView: InteractableNotificationView?
    
    weak var delegate: NotificationViewDelegate?
    
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
        
        let view = Bundle.main.loadNibNamed("interactableNotificationView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        
//        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = view.bounds
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        view.insertSubview(blurEffectView, at: 0)
        
        self.addSubview(view)
    }
    
    
    func addMeToView(notificationMessage: String, subviewMeTo: UIView) {
        
        let notifMidX = (UIScreen.main.bounds.width / 2) - 125
        let notifMidY = (UIScreen.main.bounds.height / 6)
        notifView = InteractableNotificationView(frame: CGRect(x: notifMidX, y: notifMidY, width: 280, height: 200))
        subviewMeTo.addSubview(notifView!)
        notifView!.notificationMessage.text = notificationMessage
    }
    
    @IBAction func deleteBtnTapped(_ sender: Any) {
        delegate?.interactableDestructiveTapped()
        self.removeFromSuperview()
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        delegate?.interactableStandardTapped()
        self.removeFromSuperview()
    }
    
    
    
}
