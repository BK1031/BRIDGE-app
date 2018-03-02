//
//  FinishRideViewController.swift
//  BRIDGE
//
//  Created by Bharat Kathi on 3/1/18.
//  Copyright © 2018 Bharat Kathi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class FinishRideViewController: UIViewController {
    
    @IBOutlet weak var finishRideButton: UIButton!
    
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?

    override func viewDidLoad() {
        super.viewDidLoad()
        finishRideButton.layer.cornerRadius = 10
        
        ref = Database.database().reference()
        
    }
    
    @IBAction func finishRideButton(_ sender: UIButton) {
        let value = ["riderLat": nil, "riderLong": nil, "riderPickedUp": nil, "driverArrived": nil, "driverLat": nil, "driverLong": nil, "riderName": nil] as [String : Any?]
        let rideReference = self.ref?.child("acceptedRides").child(userID)
        rideReference?.updateChildValues(value)
        performSegue(withIdentifier: "finishRide", sender: self)
    }
}
