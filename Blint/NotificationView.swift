//
//  NotificationView.swift
//  Blint
//
//  Created by Ferit Bölezek on 21/04/17.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import UIKit

class NotificationView: UIView {

    @IBOutlet weak private var messageLabel: UILabel!
    
    var notifView: NotificationView?
    /// Set the label message that appears on the Notification View.
    
    var notificationMessage: String? {
        set{
            messageLabel.text = newValue
        }
        get{
            return messageLabel.text
        }
    }
    
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
        
       let view = Bundle.main.loadNibNamed("NotificationView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(blurEffectView, at: 0)
        
        self.addSubview(view)
    }
    
    func removeMe(timeUntilDeletion: Double, completion: @escaping () -> ()) {
        var timer = Timer()
        
        timer = Timer.scheduledTimer(withTimeInterval: timeUntilDeletion, repeats: false, block: { (timer) in
            self.removeFromSuperview()
            self.notifView?.removeFromSuperview()
            timer.invalidate()
            completion()
        })
    }
    func addMeToView(notificationMessage: String, subviewMeTo: UIView) {
        
        let notifMidX = (UIScreen.main.bounds.width / 2) - 140
        let notifMidY = (UIScreen.main.bounds.height / 6)
         notifView = NotificationView(frame: CGRect(x: notifMidX, y: notifMidY, width: 280, height: 200))
        subviewMeTo.addSubview(notifView!)
        notifView!.notificationMessage = notificationMessage
    }
    
    

}
