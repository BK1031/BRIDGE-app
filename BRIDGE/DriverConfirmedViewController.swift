//
//  DriverConfirmedViewController.swift
//  BRIDGE
//
//  Created by Bharat Kathi on 2/8/18.
//  Copyright © 2018 Bharat Kathi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import MapKit
import CoreLocation

class DriverConfirmedViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var myBRIDGEButton: UIButton!
    
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?
    
    var driverLat = 0.0
    var driverLong = 0.0
    var driverCoordinates = CLLocationCoordinate2DMake(0.0, 0.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myBRIDGEButton.layer.cornerRadius = 10
        
        ref = Database.database().reference()
        
        ref?.child("acceptedRides").child(userID).observe(.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                self.driverLat = dictionary["driverLat"] as! Double
                self.driverLong = dictionary["driverLong"] as! Double
                self.driverCoordinates = CLLocationCoordinate2DMake(self.driverLat, self.driverLong)
            }
        })
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = driverCoordinates
        annotation.title = "Driver"
        annotation.subtitle = "This is the location of your BRIDGE."
        mapView.addAnnotation(annotation)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func driverInfoButton(_ sender: UIButton) {
        performSegue(withIdentifier: "driverInfo", sender: self)
    }
    
}
