//
//  SettingsCarInfoViewController.swift
//  BRIDGE
//
//  Created by Bharat Kathi on 3/18/18.
//  Copyright © 2018 Bharat Kathi. All rights reserved.
//

import UIKit
import Firebase

class SettingsCarInfoViewController: UITableViewController {
    
    @IBOutlet weak var makeLabel: UITextField!
    
    @IBOutlet weak var modelLabel: UITextField!
    
    @IBOutlet weak var colorLabel: UITextField!
    
    @IBOutlet weak var yearLabel: UITextField!
    
    @IBOutlet weak var plateLabel: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        
        if carMake != "" {
            makeLabel.text = carMake
        }
        if carModel != "" {
            modelLabel.text = carModel
        }
        if carColor != "" {
            colorLabel.text = carColor
        }
        if carYear != "" {
            yearLabel.text = carYear
        }
        if carLicencePlate != "" {
            plateLabel.text = carLicencePlate
        }
        
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        carMake = makeLabel.text!
        carModel = modelLabel.text!
        carColor = colorLabel.text!
        carYear = yearLabel.text!
        carLicencePlate = plateLabel.text!
        let reqest = ["carMake": makeLabel.text, "carModel": modelLabel.text, "carColor": colorLabel.text, "carYear": yearLabel.text, "carPlate": plateLabel.text] as [String: AnyObject]
        self.ref?.child("users").child(userID).updateChildValues(reqest)
        let alert = UIAlertController(title: "Vehicle Information Updated", message: "Your vehicle information has been updated!", preferredStyle: .alert)
        let action = UIAlertAction(title: "Got it", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    

}
