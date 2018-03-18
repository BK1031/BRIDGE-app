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
    
    var destLat = 0.0
    var destLong = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        ref = Database.database().reference()
        
        if myRiderDest == "School" {
            destLat = schoolLat
            destLong = schoolLong
        }
        
        else if myRiderDest == "Home" {
            databaseHandle = ref?.child("users").child(myRiderID).observe(.value, with: { (snapshot) in
                if let destDictionary = snapshot.value as? [String: AnyObject] {
                    self.destLat = destDictionary["homeLat"] as! Double
                    self.destLong = destDictionary["homeLong"] as! Double
                }
            })
        }
        
        let regionDistance:CLLocationDistance = 1000
        let riderCoordinates = CLLocationCoordinate2DMake(destLat, destLong)
        let regionSpan = MKCoordinateRegionMakeWithDistance(riderCoordinates, regionDistance, regionDistance)
        let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
        
        let geoFenceRegion:CLCircularRegion = CLCircularRegion(center: riderCoordinates, radius: 10, identifier: "Destination")
        
        locationManager.startMonitoring(for: geoFenceRegion)
        
        let placemark = MKPlacemark(coordinate: riderCoordinates)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "Drop-Off Location"
        mapItem.openInMaps(launchOptions: options)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Arrived at Rider Drop-Off Point")
        
        let value = ["riderLat": nil, "riderLong": nil, "riderPickedUp": nil, "driverArrived": nil, "driverLat": nil, "driverLong": nil, "riderName": nil] as [String : Any?]
        let rideReference = self.ref?.child("acceptedRides").child(myRiderID)
        rideReference?.updateChildValues(value)
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        let rideDate = formatter.string(from: date)
        let usersReference = self.ref?.child("users").child(myRiderID).child("rideHistory").childByAutoId()
        let values = ["destination": myRiderDest, "driverName": name, "date": rideDate] as [String : Any?]
        usersReference?.updateChildValues(values)
        riderDropped = true
        performSegue(withIdentifier: "driverFinishRide", sender: self)
        
    }

}
