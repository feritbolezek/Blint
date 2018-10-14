//
//  Taggy.swift
//  Blint
//
//  Created by Ferit Bölezek on 12/05/17.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import UIKit

class Taggy: UIView {

    @IBOutlet weak var taggyLabel: UILabel!
    var labelSize: CGSize!
    var labelText: String?
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
    func labelSizing(taggyLabel: String) {
        
        labelSize = self.calculateSize(labelSizeToCalculate: taggyLabel)
    }
    
    func calculateSize(labelSizeToCalculate: String) -> CGSize {
        
        let arbSize = CGSize(width: 500, height: 50)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        let estimatedFrame = NSString(string: labelSizeToCalculate).boundingRect(with: arbSize, options: options, attributes: [NSFontAttributeName: UIFont.init(name: "Avenir", size: 18)], context: nil)
        
        let sizeOfFrame = CGSize(width: estimatedFrame.width, height: estimatedFrame.height)
        
        defer {
            labelText = labelSizeToCalculate
        }
        
        return sizeOfFrame
    }
    
    func setupView() {
        
        
        let view = Bundle.main.loadNibNamed("Taggy", owner: self, options: nil)?.first as! UIView
        
        view.layer.cornerRadius = 10.0
        view.layer.masksToBounds = true
        view.frame = self.bounds
        
        
        self.addSubview(view)
    }

}
