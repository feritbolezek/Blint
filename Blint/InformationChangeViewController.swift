//
//  InformationChangeViewController.swift
//  Blint
//
//  Created by Ferit Bölezek on 21/05/17.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import UIKit

class InformationChangeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DataInformationDelegate {


    @IBOutlet weak var informationChangeTableView: UITableView!
    
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var navigationTitle: UILabel!
    
    
    var selectedSpecifics = [String]()
    
    var currentlyEditing: UserInformationType!
    var imageName = ""
    var user: BlintUser?
    
    let rematchingPossible = Notification.Name("rematch")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        if UIDevice.current.userInterfaceIdiom == .pad {
        informationChangeTableView.contentInset = UIEdgeInsetsMake(55, 0, 0, 0)
        } else {
            informationChangeTableView.contentInset = UIEdgeInsetsMake(40, 0, 0, 0)
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        informationChangeTableView.cellForRow(at: IndexPath(row: 0, section: 0))?.isSelected = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupView() {
        switch currentlyEditing! {
        case .preferences :
            navigationTitle.text = "Preferences"
            imageName = "PreferencesEdit"
            break
        case .interests :
            navigationTitle.text = "Interests"
            imageName = "Interests"
            break
        case .educationAndWork :
            navigationTitle.text = "Edu and work"
            imageName = "Book"
            break
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 80
        } else {
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SpecificsCell", for: indexPath) as? SpecificsCell {
            cell.setupView(text: selectedSpecifics[indexPath.row])
            cell.selectionStyle = .none
            return cell
        } else {
            return UITableViewCell()
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "AddMore", for: indexPath) as? AddMoreCell {
                cell.setupCell(labelText: navigationTitle.text!, imageForLabel: UIImage(named: imageName)!)
                return cell
            } else {
                return UITableViewCell()
            }
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
        return selectedSpecifics.count
        } else {
            return 1
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            user!.deleteUserSpecifics(data: selectedSpecifics[indexPath.row], typeOfData: currentlyEditing, completion: { (error) in
                if error != nil {
                    // whoopsie
                } else {
                    NotificationCenter.default.post(name: self.rematchingPossible, object: nil)
                }
            })
            selectedSpecifics.remove(at: indexPath.row)
           informationChangeTableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            performSegue(withIdentifier: "AddMore", sender: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            return false
        } else {
            return true
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    @IBAction func editButtonTapped(_ sender: Any) {
        if informationChangeTableView.isEditing {
            informationChangeTableView.isEditing = false
            editButton.setTitle("Edit", for: .normal)
            
        } else {
            informationChangeTableView.isEditing = true
            editButton.setTitle("Done", for: .normal)
        }
        
        
    }
    
    func newDataAdded(data: Any) {
        
        let updatedSpecifics = data as! [String]
        
        if updatedSpecifics == selectedSpecifics {
            // No changes was made.
        } else {
            selectedSpecifics = data as! [String]
            informationChangeTableView.reloadData()
        }
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? AddMoreViewController {
            dest.currentlyEditing = self.currentlyEditing!
            dest.selectedSpecifics = self.selectedSpecifics
            dest.delegate = self
            dest.currentUser = user!
        }
    }

}


