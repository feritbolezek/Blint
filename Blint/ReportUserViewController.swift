//
//  ReportUserViewController.swift
//  Blint
//
//  Created by Ferit Bölezek on 2017-06-22.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import UIKit

class ReportUserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    @IBOutlet weak var tblViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var reportingUserLabel: UILabel!
    
    @IBOutlet weak var reportingOptionsTableView: UITableView!
    
    @IBOutlet weak var reportingDecriptionTextView: UITextView!
    
    @IBOutlet weak var reportButton: UIButton!
    
    @IBOutlet weak var cancelBackButton: UIButton!
    
    var reportingFromChat = false
    
    var chatID: String?
    
    let reportingOptions = ["Inappropriate photos","Inappropriate bio", "Inappropriate preferences/interests", "Harassment","Underage", "Other"]
    
    var selectedReportOptions = [String]()
    
    var notifView: NotificationView?
    
    var reportedUsersName: String!
    var reportedUsersID: String!
    
    var userReportingName: String!
    var userReportingID: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reportingOptionsTableView.delegate = self
        reportingOptionsTableView.dataSource = self
        reportingDecriptionTextView.delegate = self
        reportButton.isEnabled = false
        reportButton.setTitleColor(UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5), for: .disabled)
        if reportedUsersName != nil {
        reportingUserLabel.text = "Reporting \(reportedUsersName!)"
        } else {
            reportingUserLabel.text = "Report user"
        }
        
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        keyboardToolbar.isTranslucent = false
        keyboardToolbar.barTintColor = UIColor.white
        
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(finishedInput)
        )
        addButton.tintColor = UIColor(red: 0, green: 122/255, blue: 255/255, alpha: 1)
        keyboardToolbar.items = [addButton]
        reportingDecriptionTextView.inputAccessoryView = keyboardToolbar
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        let userInformation = ["matchedWithUserToken" : "dHqOA1VkloM:APA91bH7vGhoIbUw-BecHs8oBKTsrW8DbCofI0OyF6oky4FtWo5rWwvpDJTBT-wo7xNhje-CNp49V5NfLWK_ixwPsY0LEw9_KTMYedGMRwTrWElT7QWwSw-DjamF0EqXTuh1E1AjxfGF", "matchedWithUserGender" : "Male", "usersName" : "Ferit"]
//        let jsonData = try? JSONSerialization.data(withJSONObject: userInformation)
//
//        let functionURL = URL(string: "https://us-central1-blint-fc74b.cloudfunctions.net/date")!
//        var request = URLRequest(url: functionURL)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = jsonData
//        let task = URLSession.shared.dataTask(with: request)
//        task.resume()
//        let task = URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
//
//        }
    }
    
    func finishedInput() {
        reportingDecriptionTextView.resignFirstResponder()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reportOption", for: indexPath) as! ReportingCell
        cell.reportingLabelText = reportingOptions[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reportingOptions.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellSelected = reportingOptionsTableView.cellForRow(at: indexPath) as! ReportingCell
        selectedReportOptions.append(cellSelected.reportingLabelText)
        reportButton.isEnabled = true
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cellSelected = reportingOptionsTableView.cellForRow(at: indexPath) as! ReportingCell
        let index = selectedReportOptions.index(of: cellSelected.reportingLabelText)
        selectedReportOptions.remove(at: index!)
        if selectedReportOptions.isEmpty {
            reportButton.isEnabled = false
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 80
        } else {
            return 50
        }
    }
    
    
    @IBAction func cancelTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func sendReportTapped(_ sender: Any) {
        if !reportingOptions.isEmpty {
            self.reportButton.isEnabled = false
            self.reportingOptionsTableView.allowsSelection = false
            if self.chatID == nil {
                self.chatID = "Non-Chat report"
            }
            
            DataService.standard.REPORTS_REF.childByAutoId().updateChildValues(["ReportedFor" : selectedReportOptions, "AdditionalInformation" : reportingDecriptionTextView.text, "TheUserBeingReportedName" : reportedUsersName, "TheUserBeingReportedID" : reportedUsersID, "userFilingTheReportName" : userReportingName, "userReportingID" : userReportingID, "reportingFromChat": self.reportingFromChat, "ChatID" : self.chatID!, "timestamp" : String(describing: Date.init())], withCompletionBlock: { (error, reference) in
                if error != nil {
                    self.reportButton.isEnabled = true
                    self.reportingOptionsTableView.allowsSelection = true
                    self.notifView = NotificationView()
                    self.notifView?.addMeToView(notificationMessage: "Reporting user failed, please try again.", subviewMeTo: self.view)
                    self.notifView?.removeMe(timeUntilDeletion: 3, completion: {
                        self.notifView = nil
                    })
                } else {
                    self.notifView = NotificationView()
                    self.notifView?.addMeToView(notificationMessage: "User has been reported.", subviewMeTo: self.view)
                    self.notifView?.removeMe(timeUntilDeletion: 3, completion: {
                        self.notifView = nil
                        self.navigationController?.popViewController(animated: true)
                    })
                }
            })
        }
    }
    
    
    
}
