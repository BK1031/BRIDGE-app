//
//  ConnectionErrorViewController.swift
//  BRIDGE
//
//  Created by Bharat Kathi on 3/10/18.
//  Copyright © 2018 Bharat Kathi. All rights reserved.
//

import UIKit
import Firebase

class ConnectionErrorViewController: UIViewController {
    
    var connected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let connectedRef = Database.database().reference(withPath: ".info/connected")
        connectedRef.observe(.value, with: { snapshot in
            if snapshot.value as? Bool ?? false {
                print("Connected")
                self.performSegue(withIdentifier: "retryConnection", sender: self)
            } else {
                print("Not connected")
                self.performSegue(withIdentifier: "toChecker", sender: self)
            }
        })
    }

    @IBAction func retryButton(_ sender: UIButton) {
        performSegue(withIdentifier: "retryConnection", sender: self)
    }
    
}
