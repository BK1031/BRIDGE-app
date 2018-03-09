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
    
    var confirm = false
    
    let locationManager = CLLocationManager()
    var riderLocation:CLLocationCoordinate2D?
    
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?
    
    var driverLat = 0.0
    var driverLong = 0.0
    var driverCoordinates = CLLocationCoordinate2DMake(0.0, 0.0)
    
    var firstMapView = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myBRIDGEButton.layer.cornerRadius = 10
        
        ref = Database.database().reference()
        
        mapView.delegate = self
        mapView.showsScale = true
        mapView.showsPointsOfInterest = true
        mapView.showsUserLocation = true
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        let riderCoordinates = locationManager.location?.coordinate
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = driverCoordinates
        annotation.title = "Driver"
        annotation.subtitle = "This is the location of your BRIDGE."
        self.mapView.addAnnotation(annotation)
        
        databaseHandle = ref?.child("acceptedRides").child(userID).observe(.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                self.mapView.removeAnnotation(annotation)
                self.driverLat = dictionary["driverLat"] as! Double
                self.driverLong = dictionary["driverLong"] as! Double
                self.driverCoordinates = CLLocationCoordinate2DMake(self.driverLat, self.driverLong)
                
                annotation.coordinate = self.driverCoordinates
                annotation.title = "Driver"
                annotation.subtitle = "This is the location of your BRIDGE."
                self.mapView.addAnnotation(annotation)
                
                if self.firstMapView {
                    let sourcePlacemark = MKPlacemark(coordinate: riderCoordinates!)
                    let destPlacemark = MKPlacemark(coordinate: self.driverCoordinates)
                    
                    let sourceItem = MKMapItem(placemark: sourcePlacemark)
                    let destItem = MKMapItem(placemark: destPlacemark)
                    
                    let directionRequest = MKDirectionsRequest()
                    directionRequest.source = sourceItem
                    directionRequest.destination = destItem
                    directionRequest.transportType = .automobile
                    
                    let directions = MKDirections(request: directionRequest)
                    directions.calculate { (response, error) in
                        guard let response = response else {
                            if let error = error {
                                print("Something Went WRONG!!! WHAAA!!!!")
                            }
                            return
                        }
                        let route = response.routes[0]
                        
                        let rekt = route.polyline.boundingMapRect
                        self.mapView.setRegion(MKCoordinateRegionForMapRect(rekt), animated: true)
                    }
                    self.firstMapView = false
                }
                
            }
        })
        
        databaseHandle = ref?.child("acceptedRides").child(userID).child("driverArrived").observe(.value, with: { (snapshot) in
            if let driverStatus = snapshot.value as? String {
                if driverStatus == "true" {
                    let alert = UIAlertController(title: "Driver Arrived", message: "Your BRIDGE has arrived! Keep an eye out for your driver.", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Got it", style: .default, handler: { (action) in
                        self.confirm = true
                    })
                    
                    alert.addAction(action)
                    
                    self.present(alert, animated: true, completion: nil)
                }
            }
        })
        
        databaseHandle = ref?.child("acceptedRides").child(userID).child("riderPickedUp").observe(.value, with: { (snapshot) in
            if let riderPickedStatus = snapshot.value as? String {
                if riderPickedStatus == "true" {
                    self.confirm = false
                    self.locationManager.stopUpdatingLocation()
                    
                    let value = ["riderLat": nil, "riderLong": nil, "riderPickedUp": nil, "driverArrived": nil, "driverLat": nil, "driverLong": nil, "riderName": nil] as [String : Any?]
                    let rideReference = self.ref?.child("acceptedRides").child(userID)
                    rideReference?.updateChildValues(value)
                    
                    self.performSegue(withIdentifier: "riderPicked", sender: self)
                }
            }
        })
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locationManager.location?.coordinate {
            riderLocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            if confirm {
                let value = ["riderLat": riderLocation?.latitude, "riderLong": riderLocation?.longitude, "riderPickedUp": "false"] as [String : Any]
                let rideReference = self.ref?.child("acceptedRides").child(userID)
                rideReference?.updateChildValues(value)
            }
        }
        
    }
    
}
