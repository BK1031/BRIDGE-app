//
//  DestPickerViewController.swift
//  BRIDGE
//
//  Created by Bharat Kathi on 3/10/18.
//  Copyright © 2018 Bharat Kathi. All rights reserved.
//

import UIKit

class DestPickerViewController: UIViewController {

    @IBOutlet weak var selectionView: UIView!
    
    @IBOutlet weak var schoolButton: UIView!
    
    @IBOutlet weak var homeButton: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectionView.layer.cornerRadius = 10
        schoolButton.layer.cornerRadius = 10
        homeButton.layer.cornerRadius = 10
        
        
    }
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func schoolPicked(_ sender: UIButton) {
        destination = "school"
        performSegue(withIdentifier: "destSelected", sender: self)
    }
    
    @IBAction func homePicked(_ sender: UIButton) {
        destination = "home"
        performSegue(withIdentifier: "destSelected", sender: self)
    }
    
}
