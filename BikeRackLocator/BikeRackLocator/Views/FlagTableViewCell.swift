//
//  FlagTableViewCell.swift
//  BikeRackLocator
//
//  Created by Kevin Li on 8/13/15.
//  Copyright (c) 2015 Kevin Li. All rights reserved.
//

import UIKit

class FlagTableViewCell: UITableViewCell {

    @IBOutlet weak var flagDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
