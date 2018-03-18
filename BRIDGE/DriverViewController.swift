//
//  DriverViewController.swift
//  BRIDGE
//
//  Created by Bharat Kathi on 1/16/18.
//  Copyright © 2018 Bharat Kathi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import MapKit
import CoreLocation

class DriverViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var tableView: UITableView!
    
    let locationManager = CLLocationManager()
    var userLocation:CLLocationCoordinate2D?
    
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?
    
    var riderID = ""
    var riderName = ""
    var riderLat = 0.0
    var riderLong = 0.0
    var riderCoordinates = ""
    var riderAddress = ""
    var riderDest = ""
    
    var riderIDs = [String]()
    var rideRequests = [String]()
    var rideLat = [Double]()
    var rideLong = [Double]()
    var rideDests = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        ref = Database.database().reference()
        
        databaseHandle = ref?.child("rideRequests").observe(.value, with: { (snapshot) in
            if snapshot.childrenCount > 0 {
                self.rideRequests.removeAll()
                self.riderIDs.removeAll()
                self.rideLat.removeAll()
                self.rideLong.removeAll()
                self.rideDests.removeAll()
                
                for rider in snapshot.children.allObjects as! [DataSnapshot] {
                    let request = rider.value as? [String: AnyObject]
                    self.riderName = request!["riderName"] as! String
                    self.riderID = request!["riderID"] as! String
                    self.riderLat = request!["lat"] as! Double
                    self.riderLong = request!["long"] as! Double
                    self.riderDest = request!["dest"] as! String
                    
                    self.rideRequests.append(self.riderName)
                    self.riderIDs.append(self.riderID)
                    self.rideLat.append(self.riderLat)
                    self.rideLong.append(self.riderLong)
                    self.rideDests.append(self.riderDest)
                }
                self.tableView.reloadData()
            }
            
            else {
                self.rideLat.removeAll()
                self.rideLong.removeAll()
                self.riderIDs.removeAll()
                self.rideRequests.removeAll()
                self.rideDests.removeAll()
                self.tableView.reloadData()
            }
            
        })
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let center = location.coordinate
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: false)
        mapView.showsUserLocation = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rideRequests.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell") as! RideRequestsTableViewCell
        
        cell.cellView.layer.cornerRadius = cell.cellView.frame.height / 2
        
        cell.riderName.text = rideRequests[indexPath.row]
        if rideDests[indexPath.row] == "School" {
            cell.riderLocation.text = "Valley Christian High School"
        }
        else {
            cell.riderLocation.text = "Home"
        }
        
        cell.riderPic.layer.cornerRadius = cell.riderPic.frame.height / 2
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myRiderName = self.rideRequests[indexPath.row]
        myRiderID = self.riderIDs[indexPath.row]
        myRiderLat = self.rideLat[indexPath.row]
        myRiderLong = self.rideLong[indexPath.row]
        myRiderDest = self.rideDests[indexPath.row]
        
        performSegue(withIdentifier: "driverNav", sender: nil)
    }

}
