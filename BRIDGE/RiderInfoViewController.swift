//
//  RiderInfoViewController.swift
//  BRIDGE
//
//  Created by Bharat Kathi on 3/4/18.
//  Copyright © 2018 Bharat Kathi. All rights reserved.
//

import UIKit
import Firebase

class RiderInfoViewController: UIViewController {
    
    @IBOutlet weak var riderImageView: UIImageView!
    
    @IBOutlet weak var riderNameLabel: UILabel!
    
    @IBOutlet weak var riderPhone: UILabel!
    
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "My Rider"
        riderImageView.image = UIImage(named: "profile")
        riderImageView.layer.cornerRadius = riderImageView.frame.height / 2
        
        ref = Database.database().reference()
        
        databaseHandle = ref?.child("acceptedRides").child(myRiderID).observe(.value, with: { (snaphot) in
            if let riderDetails = snaphot.value as? [String: AnyObject] {
                self.riderNameLabel.text = riderDetails["riderName"] as? String
                self.riderPhone.text = riderDetails["riderPhone"] as? String
            }
        })
    }

}
