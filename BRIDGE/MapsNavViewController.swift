//
//  MapsNavViewController.swift
//  BRIDGE
//
//  Created by Bharat Kathi on 2/12/18.
//  Copyright © 2018 Bharat Kathi. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import FirebaseDatabase

class MapsNavViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager:CLLocationManager = CLLocationManager()
    
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        ref = Database.database().reference()
        
        let regionDistance:CLLocationDistance = 1000
        let riderCoordinates = CLLocationCoordinate2DMake(myRiderLat, myRiderLong)
        let regionSpan = MKCoordinateRegionMakeWithDistance(riderCoordinates, regionDistance, regionDistance)
        let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
        
        let geoFenceRegion:CLCircularRegion = CLCircularRegion(center: riderCoordinates, radius: 50, identifier: "Rider")
        
        locationManager.startMonitoring(for: geoFenceRegion)
        
        let placemark = MKPlacemark(coordinate: riderCoordinates)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "Rider Location"
        mapItem.openInMaps(launchOptions: options)
    }

    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Arrived at Rider")
        let usersReference = self.ref?.child("acceptedRides").child(myRiderID)
        let values = ["driverArrived": "true"] as [String : Any?]
        usersReference?.updateChildValues(values)
        performSegue(withIdentifier: "arrivedAtRider", sender: self)
    }
    
}
