//
//  DriverPickedViewController.swift
//  BRIDGE
//
//  Created by Bharat Kathi on 3/19/18.
//  Copyright © 2018 Bharat Kathi. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import CoreLocation

class DriverPickedViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var notificationView: UIView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var progressLabel: UILabel!
    
    @IBOutlet weak var endRideButton: UIButton!
    
    let locationManager = CLLocationManager()
    var driverLocation:CLLocationCoordinate2D?
    
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?
    
    var destLat = 0.0
    var destLong = 0.0
    
    var arrived = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationView.layer.cornerRadius = 10
        endRideButton.layer.cornerRadius = 10
        progressLabel.text = "Ride is in progress. The ride will automatically end once you arrive at " + destination + "."
        
        mapView.delegate = self
        mapView.showsScale = true
        mapView.showsPointsOfInterest = true
        mapView.showsUserLocation = true
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        else {
            progressLabel.text = "Location Services are not Enabled. Please do so in settings. Wait, if they aren't enabled, how did you even request a ride?"
        }
        
        if destination == "Home" {
            destLat = homeLat
            destLong = homeLong
        }
        else {
            destLat = schoolLat
            destLong = schoolLong
        }
        
        let sourceCoordinates = locationManager.location?.coordinate
        let destCoordinates = CLLocationCoordinate2DMake(destLat, destLong)
        
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
                    print("Something Went WRONG: \(error)")
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
        annotation.title = destination
        annotation.subtitle = "This is where you will be dropped off."
        mapView.addAnnotation(annotation)
        
        let geoFenceRegion:CLCircularRegion = CLCircularRegion(center: destCoordinates, radius: 10, identifier: "Destination")
        
        locationManager.startMonitoring(for: geoFenceRegion)
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor =  UIColor.blue
        renderer.lineWidth = 5.0
        
        return renderer
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Rider Arrived at Destination!")
        arrived = true
        endRideButton.setTitle("Done", for: .normal)
        progressLabel.text = "You have arrived at \(destination). Thank you for using BRIDGE!"
    }
    
    @IBAction func endRide(_ sender: UIButton) {
        if arrived == false {
            let alert = UIAlertController(title: "Confirm Arrival", message: "Are you sure you have arrived at your destination? It looks like your ride is still in progress according to your device location.", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            let end = UIAlertAction(title: "End Ride", style: .destructive, handler: { (action) in
                self.performSegue(withIdentifier: "riderPicked", sender: self)
            })
            alert.addAction(cancel)
            alert.addAction(end)
            present(alert, animated: true, completion: nil)
        }
        else {
            destination = ""
            performSegue(withIdentifier: "rideFinish", sender: self)
        }
    }
    

}
