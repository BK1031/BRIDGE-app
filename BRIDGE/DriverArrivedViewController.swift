//
//  DriverArrivedViewController.swift
//  BRIDGE
//
//  Created by Bharat Kathi on 3/1/18.
//  Copyright © 2018 Bharat Kathi. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase
import FirebaseDatabase

class DriverArrivedViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var myRiderButton: UIButton!
    
    @IBOutlet weak var pickedRiderButton: UIButton!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var notificationView: UIView!
    
    var riderLat = 0.0
    var riderLong = 0.0
    
    var riderCoordinates = CLLocationCoordinate2DMake(0.0, 0.0)
    
    let locationManager = CLLocationManager()
    
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myRiderButton.layer.cornerRadius = 10
        pickedRiderButton.layer.cornerRadius = 10
        notificationView.layer.cornerRadius = 10
        
        ref = Database.database().reference()
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        self.databaseHandle = self.ref?.child("acceptedRides").child(myRiderID).observe(.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                self.riderLat = dictionary["riderLat"] as! Double
                self.riderLong = dictionary["riderLong"] as! Double
                self.riderCoordinates = CLLocationCoordinate2DMake(self.riderLat, self.riderLong)
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = self.riderCoordinates
                annotation.title = "Rider"
                annotation.subtitle = "This is the location of your Rider."
                self.mapView.addAnnotation(annotation)
            }
        })
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let center = location.coordinate
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
    }
    
    @IBAction func pickedUpRiderButton(_ sender: UIButton) {
        locationManager.stopUpdatingLocation()
        let value = ["riderPickedUp": "true"] as [String : Any]
        let rideReference = self.ref?.child("acceptedRides").child(myRiderID)
        rideReference?.updateChildValues(value)
        performSegue(withIdentifier: "riderPickedUp", sender: self)
    }
    
}
