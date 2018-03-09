//
//  DriverInfoViewController.swift
//  BRIDGE
//
//  Created by Bharat Kathi on 2/8/18.
//  Copyright © 2018 Bharat Kathi. All rights reserved.
//

import UIKit

class DriverInfoViewController: UIViewController {

    @IBOutlet weak var driverImageView: UIImageView!
    
    @IBOutlet weak var driverNameLabel: UILabel!
    
    @IBOutlet weak var driverPhoneLabel: UILabel!
    
    @IBOutlet weak var driverCarColor: UILabel!
    
    @IBOutlet weak var driverCarMakeModel: UILabel!
    
    @IBOutlet weak var driverLicencePlate: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "My BRIDGE"
        
    }
    
}
