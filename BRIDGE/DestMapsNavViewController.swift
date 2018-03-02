//
//  DestMapsNavViewController.swift
//  BRIDGE
//
//  Created by Bharat Kathi on 3/1/18.
//  Copyright © 2018 Bharat Kathi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import MapKit
import CoreLocation

class DestMapsNavViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager:CLLocationManager = CLLocationManager()
    
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        ref = Database.database().reference()
        
        let value = ["riderLat": nil, "riderLong": nil, "riderPickedUp": nil, "driverArrived": nil, "driverLat": nil, "driverLong": nil, "riderName": nil] as [String : Any?]
        let rideReference = self.ref?.child("acceptedRides").child(myRiderID)
        rideReference?.updateChildValues(value)
        
        let regionDistance:CLLocationDistance = 1000
        let riderCoordinates = CLLocationCoordinate2DMake(schoolLat, schoolLong)
        let regionSpan = MKCoordinateRegionMakeWithDistance(riderCoordinates, regionDistance, regionDistance)
        let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
        
        let geoFenceRegion:CLCircularRegion = CLCircularRegion(center: riderCoordinates, radius: 50, identifier: "Destination")
        
        locationManager.startMonitoring(for: geoFenceRegion)
        
        let placemark = MKPlacemark(coordinate: riderCoordinates)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "Drop-Off Location"
        mapItem.openInMaps(launchOptions: options)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Arrived at Rider Drop-Off Point")
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        let rideDate = formatter.string(from: date)
        let usersReference = self.ref?.child("users").child(myRiderID).child("rideHistory").childByAutoId()
        let values = ["destination": "School", "driverName": name, "date": rideDate] as [String : Any?]
        usersReference?.updateChildValues(values)
        riderDropped = true
        performSegue(withIdentifier: "driverFinishRide", sender: self)
        
    }

}
