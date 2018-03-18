//
//  SettingsViewController.swift
//  BRIDGE
//
//  Created by Bharat Kathi on 1/11/18.
//  Copyright © 2018 Bharat Kathi. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }

}
