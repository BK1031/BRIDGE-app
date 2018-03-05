//
//  HelpViewController.swift
//  BRIDGE
//
//  Created by Bharat Kathi on 3/4/18.
//  Copyright © 2018 Bharat Kathi. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var helpItemsList = ["Frequently Asked Questions", "Setup Help", "Customer Support"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return helpItemsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell") as! UITableViewCell
        cell.textLabel = helpItemsList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if helpItemsList[indexPath.row] == "Customer Support" {
            performSegue(withIdentifier: "toCustomerSupport", sender: self)
        }
    }

}
