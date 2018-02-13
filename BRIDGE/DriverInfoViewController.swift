//
//  DriverInfoViewController.swift
//  BRIDGE
//
//  Created by Bharat Kathi on 2/8/18.
//  Copyright © 2018 Bharat Kathi. All rights reserved.
//

import UIKit

class DriverInfoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
