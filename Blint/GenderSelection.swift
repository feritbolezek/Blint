//
//  GenderSelection.swift
//  Blint
//
//  Created by Ferit Bölezek on 2017-06-20.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import UIKit

class GenderSelection: UIView {
    
    @IBOutlet weak var femaleIcon: UIImageView!
    
    @IBOutlet weak var maleIcon: UIImageView!
    
    @IBOutlet weak var femaleButton: UIButton!
    
    @IBOutlet weak var maleButton: UIButton!
    
    weak var delegate: SignUpChoiceDelegate?
    
    var selectedGender = ""
    
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
        
        let view = Bundle.main.loadNibNamed("genderSelection", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
        
    }
    
    @IBAction func continueTapped(_ sender: Any) {
        if selectedGender != "" {
            delegate?.genderFilledIn!(gender: selectedGender)
        }
    }
    
    @IBAction func maleIconTapped(_ sender: Any) {
        maleIcon.alpha = 1.0
        maleButton.alpha = 1.0
        femaleIcon.alpha = 0.5
        femaleButton.alpha = 0.5
        selectedGender = "male"
    }
    
    @IBAction func femaleIconTapped(_ sender: Any) {
        maleIcon.alpha = 0.5
        maleButton.alpha = 0.5
        femaleIcon.alpha = 1.0
        femaleButton.alpha = 1.0
        selectedGender = "female"
    }
    
    @IBAction func femaleButtonTapped(_ sender: Any) {
        maleIcon.alpha = 0.5
        maleButton.alpha = 0.5
        femaleIcon.alpha = 1.0
        femaleButton.alpha = 1.0
        selectedGender = "female"
    }
    
    @IBAction func maleButtonTapped(_ sender: Any) {
        maleIcon.alpha = 1.0
        maleButton.alpha = 1.0
        femaleIcon.alpha = 0.5
        femaleButton.alpha = 0.5
        selectedGender = "male"
    }
    
}
