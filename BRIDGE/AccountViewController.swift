//
//  AccountViewController.swift
//  BRIDGE
//
//  Created by Bharat Kathi on 1/11/18.
//  Copyright © 2018 Bharat Kathi. All rights reserved.
//

import UIKit
import Firebase

class AccountViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var accountBalanceLabel: UILabel!
    
    @IBOutlet weak var studentLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var schoolLabel: UILabel!
    
    @IBOutlet weak var schoolAddressLabel: UILabel!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var driverStatusLabel: UILabel!
    
    @IBOutlet weak var signOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        signOutButton.layer.cornerRadius = 10
        nameLabel.text = name
        emailLabel.text = email
        studentLabel.text = kidName
        addressLabel.text = addressFull
        schoolLabel.text = "Valley Christian High School"
        schoolAddressLabel.text = "100 Skyway Drive, San Jose, CA 95111"
        accountBalanceLabel.text = accountBalance
        profileImageView.image = profilePic
        profileImageView.layer.cornerRadius = (profileImageView.frame.height) / 2
        if driverStatus == "verified" {
            driverStatusLabel.textColor = UIColor.green
            driverStatusLabel.text = "Verified"
        }
        else if driverStatus == "Pending" {
            driverStatusLabel.textColor = UIColor.orange
            driverStatusLabel.text = "Pending"
        }
        else {
            driverStatusLabel.textColor = UIColor.red
            driverStatusLabel.text = "Not Registered"
        }
    }
    

    @IBAction func doneButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addFundsButton(_ sender: UIButton) {
        //TODO: Add apple pay shit here
    }
    
    @IBAction func editAccountButton(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "editAccount" , sender: self)
    }
    
    @IBAction func signOutButton(_ sender: UIButton) {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let signOutAction = UIAlertAction(title: "Sign Out", style: .destructive) { (action) in
            name = ""
            kidName = ""
            email = ""
            userID = ""
            profilePic = #imageLiteral(resourceName: "profile")
            addressLine1 = ""
            addressCity = ""
            addressState = ""
            addressZIP = ""
            addressFull = ""
            accountBalance = "$0.00"
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                self.performSegue(withIdentifier: "logOut", sender: self)
            } catch let signOutError as NSError {
                //Sign-Out error occured
            }
        }
        
        sheet.addAction(cancelAction)
        sheet.addAction(signOutAction)
        
        present(sheet, animated: true, completion: nil)
        
    }
    
}
