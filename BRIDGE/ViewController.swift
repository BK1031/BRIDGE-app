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
        
        if carLicencePlate == "" {
            let alert = UIAlertController(title: "Set Car Details", message: "Don't forget to go to the settings page and set your vehicle information.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Got it", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
        
        if riderDropped {
            let value = ["riderLat": nil, "riderLong": nil, "riderPickedUp": nil, "driverArrived": nil, "driverLat": nil, "driverLong": nil, "riderName": nil, "carMake": nil, "carModel": nil, "carColor": nil, "carYear": nil, "carPlate": nil, "driverName": nil, "driverPhone": nil, "riderPhone": nil] as [String : Any?]
            let rideReference = self.ref?.child("acceptedRides").child(myRiderID)
            rideReference?.updateChildValues(value)
            
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yy"
            let rideDate = formatter.string(from: date)
            let usersReference = ref?.child("users").child(userID).child("driveHistory").childByAutoId()
            let values = ["destination": myRiderDest, "riderName": myRiderName, "date": rideDate] as [String : Any?]
            usersReference?.updateChildValues(values)
            myRiderName = ""
            myRiderID = ""
            myRiderLat = 0.0
            myRiderLong = 0.0
            myRiderDest = ""
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
        let alert = UIAlertController(title: "Select Destination", message: "Select whether you want to be dropped off at home or at school. You can configure these locations in settings.", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "School", style: .default) { (action) in
            destination = "School"
            self.performSegue(withIdentifier: "requestRide", sender: self)
        }
        let action2 = UIAlertAction(title: "Home", style: .default) { (alert) in
            destination = "Home"
            self.performSegue(withIdentifier: "requestRide", sender: self)
        }
        let action3 = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(action1)
        alert.addAction(action2)
//        alert.addAction(action3)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func driveButton(_ sender: UIButton) {
        if driverStatus == "Verified" {
            if carLicencePlate == "" {
                let alert = UIAlertController(title: "Set Car Details", message: "You have to go to the settings page and set your vehicle information before you can be a driver.", preferredStyle: .alert)
                let action = UIAlertAction(title: "Got it", style: .default, handler: nil)
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
            }
            else {
                performSegue(withIdentifier: "drive", sender: self)
            }
        }
        else if driverStatus == "Pending" {
            let alert = UIAlertController(title: "Verification Pending", message: "Your driver verification pending. Please allow 5-7 days to process your request.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Got it", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        else {
            let alert = UIAlertController(title: "Not Verified", message: "You are not verified as a BRIDGE driver. Please go to the settings page to file a verification request.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Got it", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func accountButton(_ sender: UIButton) {
        performSegue(withIdentifier: "showAccount", sender: self)
    }
    
}

