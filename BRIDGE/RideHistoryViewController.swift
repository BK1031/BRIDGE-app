//
//  RideHistoryViewController.swift
//  BRIDGE
//
//  Created by Bharat Kathi on 1/11/18.
//  Copyright © 2018 Bharat Kathi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class RideHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?
    
    var driversList = [String]()
    var dateList = [String]()
    var destinationList = [String]()
    
    var driverName = ""
    var date = ""
    var destination = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        ref = Database.database().reference()
        
        databaseHandle = ref?.child("users").child(userID).child("rideHistory").observe(.value, with: { (snapshot) in
            if snapshot.childrenCount > 0 {
                self.driversList.removeAll()
                self.dateList.removeAll()
                self.destinationList.removeAll()
                
                for ride in snapshot.children.allObjects as! [DataSnapshot] {
                    let history = ride.value as? [String: AnyObject]
                    self.driverName = history!["driverName"] as! String
                    self.date = history!["date"] as! String
                    self.destination = history!["destination"] as! String
                    
                    self.driversList.append(self.driverName)
                    self.dateList.append(self.date)
                    self.destinationList.append(self.destination)
                }
                self.tableView.reloadData()
            }
            
            else {
                self.driversList.removeAll()
                self.dateList.removeAll()
                self.destinationList.removeAll()
                
            }
            
        })
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return driversList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell") as! RideHistoryTableViewCell
        
        cell.driverNameLabel.text = driversList[indexPath.row]
        cell.dateLabel.text = dateList[indexPath.row]
        cell.destinationLabel.text = destinationList[indexPath.row]
        
        return cell
    }
    
}

