//
//  SettingsAboutViewController.swift
//  BRIDGE
//
//  Created by Bharat Kathi on 3/16/18.
//  Copyright © 2018 Bharat Kathi. All rights reserved.
//

import UIKit
import Firebase

class SettingsAboutViewController: UITableViewController {
    
    @IBOutlet weak var userIDLabel: UILabel!
    
    @IBOutlet weak var driverStatusLabel: UILabel!
    
    @IBOutlet weak var driverVerificationButton: UIButton!
    
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        userIDLabel.text = userID
        driverStatusLabel.text = driverStatus
        
        if driverStatus != "Not Registered" {
            driverVerificationButton.isEnabled = false
        }
        else {
            driverVerificationButton.isEnabled = true
        }
    }
    
    @IBAction func driverVerificationClicked(_ sender: UIButton) {
        let reqest = ["driverName": name, "kidName": kidName, "schoolLat": schoolLat, "schoolLong": schoolLong] as [String: AnyObject]
        self.ref?.child("driverVerificationRequests").child(userID).updateChildValues(reqest)
        driverVerificationButton.isEnabled = false
        driverStatus = "Pending"
        let statusUpdate = ["driverStatus": driverStatus]
        self.ref?.child("users").child(userID).updateChildValues(statusUpdate)
        driverStatusLabel.text = driverStatus
        
        let alert = UIAlertController(title: "Verification Requested", message: "You have successfully requested a BRIDGE driver verification check. Please give us 5-7 days to process your request and we will get back to you for further steps.", preferredStyle: .alert)
        let gotItAction = UIAlertAction(title: "Got it", style: .default, handler: nil)
        let cancelRequest = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            let reqest = ["driverName": nil, "kidName": nil, "schoolLat": nil, "schoolLong": nil] as [String: AnyObject]
            self.ref?.child("driverVerificationRequests").child(userID).updateChildValues(reqest)
            self.driverVerificationButton.isEnabled = true
            
            driverStatus = "Not Registered"
            let statusUpdate = ["driverStatus": driverStatus]
            self.ref?.child("users").child(userID).updateChildValues(statusUpdate)
            self.driverStatusLabel.text = driverStatus
        }
        alert.addAction(gotItAction)
        alert.addAction(cancelRequest)
        present(alert, animated: true, completion: nil)
    }
    

}
