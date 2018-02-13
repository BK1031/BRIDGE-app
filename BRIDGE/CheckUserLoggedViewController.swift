//
//  CheckUserLoggedViewController.swift
//  BRIDGE
//
//  Created by Bharat Kathi on 2/5/18.
//  Copyright © 2018 Bharat Kathi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class CheckUserLoggedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                
                let user = Auth.auth().currentUser
                if let user = user {
                    userID = user.uid
                    email = user.email!
                    // ...
                }
                Database.database().reference().child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if let dictionary = snapshot.value as? [String: AnyObject] {
                        name = dictionary["name"] as! String
                        kidName = dictionary["studentName"] as! String
                        addressFull = dictionary["address"] as! String
                        accountBalance = dictionary["accountBalance"] as! String
                    }
                    
                }, withCancel: nil)
                
                self.performSegue(withIdentifier: "userLogged", sender: self)
            }
                
            else {
                self.performSegue(withIdentifier: "toLog", sender: self)
            }
        }
    }

}
