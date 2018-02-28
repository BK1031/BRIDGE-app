//
//  RideHistoryTableViewCell.swift
//  BRIDGE
//
//  Created by Bharat Kathi on 2/28/18.
//  Copyright © 2018 Bharat Kathi. All rights reserved.
//

import UIKit

class RideHistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var driverNameLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var destinationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
