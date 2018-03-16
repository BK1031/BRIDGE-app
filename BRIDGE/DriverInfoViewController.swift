//
//  DriverInfoViewController.swift
//  BRIDGE
//
//  Created by Bharat Kathi on 2/8/18.
//  Copyright © 2018 Bharat Kathi. All rights reserved.
//

import UIKit
import Firebase

class DriverInfoViewController: UIViewController {

    @IBOutlet weak var driverImageView: UIImageView!
    
    @IBOutlet weak var driverNameLabel: UILabel!
    
    @IBOutlet weak var driverPhoneLabel: UILabel!
    
    @IBOutlet weak var driverCarColor: UILabel!
    
    @IBOutlet weak var driverCarMakeModel: UILabel!
    
    @IBOutlet weak var driverLicencePlate: UILabel!
    
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "My BRIDGE"
        driverImageView.image = UIImage(named: "profile")
        driverImageView.layer.cornerRadius = driverImageView.frame.height / 2
        
        ref = Database.database().reference()
        
        databaseHandle = ref?.child("acceptedRides").child(userID).observe(.value, with: { (snapshot) in
            if let driverDetails = snapshot.value as? [String: AnyObject] {
                self.driverNameLabel.text = driverDetails["driverName"] as? String
                self.driverPhoneLabel.text = driverDetails["driverPhone"] as? String
                self.driverCarColor.text = (driverDetails["carColor"] as? String)! + " " + (driverDetails["carYear"] as? String)!
                self.driverCarMakeModel.text = (driverDetails["carMake"] as? String)! + " " + (driverDetails["carModel"] as? String)!
                self.driverLicencePlate.text = driverDetails["carPlate"] as? String
            }
        })
    }
    
}
