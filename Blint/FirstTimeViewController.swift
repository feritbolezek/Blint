//
//  FirstTimeViewController.swift
//  Blint
//
//  Created by Ferit Bölezek on 2017-06-20.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import UIKit

class FirstTimeViewController: UIViewController {
    
    weak var delegate: FirstTimeDelegate?
    
    @IBOutlet weak var welcomeLabel: UILabel!
    var usersName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        welcomeLabel.text = "Welcome to Blint, \(usersName!)."
        // Do any additional setup after loading the view.
    }
    @IBAction func continueTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        delegate?.userWishesToContinue()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
