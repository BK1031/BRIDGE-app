//
//  DriverNavViewController.swift
//  BRIDGE
//
//  Created by Bharat Kathi on 1/22/18.
//  Copyright © 2018 Bharat Kathi. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase
import FirebaseDatabase

class DriverNavViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var navigationLabel: UILabel!
    
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBOutlet weak var directionsView: UIView!
    
    var confirm = false
    
    let locationManager = CLLocationManager()
    var driverLocation:CLLocationCoordinate2D?
    
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        directionsView.layer.cornerRadius = 10
        
        confirmButton.layer.cornerRadius = 10
        
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
        
        let sourceCoordinates = locationManager.location?.coordinate
        let destCoordinates = CLLocationCoordinate2DMake(Double(myRiderLat), Double(myRiderLong))
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinates!)
        let destPlacemark = MKPlacemark(coordinate: destCoordinates)
        
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
            self.mapView.add(route.polyline, level: .aboveRoads)
            
            let rekt = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegionForMapRect(rekt), animated: true)
        }
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = destCoordinates
        annotation.title = "Rider"
        annotation.subtitle = "This is the location of your rider."
        mapView.addAnnotation(annotation)
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor =  UIColor.blue
        renderer.lineWidth = 5.0
        
        return renderer
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locationManager.location?.coordinate {
            driverLocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            if confirm {
                let value = ["riderName": myRiderName, "riderLat": myRiderLat, "riderLong": myRiderLong, "driverLat": driverLocation?.latitude, "driverLong": driverLocation?.longitude] as [String : Any]
                let rideReference = self.ref?.child("acceptedRides").child(myRiderID)
                rideReference?.updateChildValues(value)
            }
        }
        
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        performSegue(withIdentifier: "cancelRider", sender: self)
    }
    
    @IBAction func confirmButton(_ sender: UIButton) {
        confirm = true
        let value = ["riderName": myRiderName, "riderLat": myRiderLat, "riderLong": myRiderLong, "driverLat": driverLocation?.latitude, "driverLong": driverLocation?.longitude, "driverArrived": "false"] as [String : Any]
        let rideReference = self.ref?.child("acceptedRides").child(myRiderID)
        rideReference?.updateChildValues(value)
        
        let values = ["rideAccepted": "true"] as [String : Any?]
        let usersReference = self.ref?.child("rideRequests").child(myRiderID)
        usersReference?.updateChildValues(values)
        
        let alert = UIAlertController(title: "Rider Confirmed", message: "Don't forget to return back to the BRIDGE app after you arrive at the rider's location!", preferredStyle: .alert)
        let action = UIAlertAction(title: "Got it", style: .default, handler: { (action) in
            self.performSegue(withIdentifier: "toNavMaps", sender: self)
        })
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
}
