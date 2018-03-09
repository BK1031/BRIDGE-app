//
//  ViewController.swift
//  BRIDGE
//
//  Created by Bharat Kathi on 1/9/18.
//  Copyright © 2018 Bharat Kathi. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase
import FirebaseDatabase

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var accountButton: UIButton!

    @IBOutlet weak var requestRideButton: UIButton!
    
    @IBOutlet weak var driverButton: UIButton!
    
    let locationManager = CLLocationManager()
    
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accountButton.setImage(profilePic, for: .normal)
        accountButton.imageView?.layer.cornerRadius = (accountButton.imageView?.frame.height)! / 2
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        requestRideButton.layer.cornerRadius = 10
        driverButton.layer.cornerRadius = 10
        
        ref = Database.database().reference()
        
        if riderDropped {
            let value = ["riderLat": nil, "riderLong": nil, "riderPickedUp": nil, "driverArrived": nil, "driverLat": nil, "driverLong": nil, "riderName": nil] as [String : Any?]
            let rideReference = self.ref?.child("acceptedRides").child(myRiderID)
            rideReference?.updateChildValues(value)
            
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yy"
            let rideDate = formatter.string(from: date)
            let usersReference = ref?.child("users").child(userID).child("driveHistory").childByAutoId()
            let values = ["destination": "School", "riderName": myRiderName, "date": rideDate] as [String : Any?]
            usersReference?.updateChildValues(values)
            myRiderName = ""
            myRiderID = ""
            myRiderLat = 0.0
            myRiderLong = 0.0
            let alert = UIAlertController(title: "Ride Finished", message: "Your Rider has been dropped off. Thank you for driving with BRIGDE!", preferredStyle: .alert)
            let action = UIAlertAction(title: "Got it", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            riderDropped = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let center = location.coordinate
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func requestRideButton(_ sender: UIButton) {
        performSegue(withIdentifier: "requestRide", sender: self)
    }
    
    @IBAction func driveButton(_ sender: UIButton) {
        performSegue(withIdentifier: "drive", sender: self)
    }
    
    @IBAction func accountButton(_ sender: UIButton) {
        performSegue(withIdentifier: "showAccount", sender: self)
    }
    
}

