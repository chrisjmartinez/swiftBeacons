//
//  BeaconTableViewCell.swift
//  BlueBeak Admin
//
//  Created by Chris Martinez on 7/20/14.
//  Copyright (c) 2014 Stoked Software, LLC. All rights reserved.
//

import UIKit

class BeaconTableViewCell: UITableViewCell {

    @IBOutlet var name: UILabel
    @IBOutlet var uuid: UILabel
    @IBOutlet var major: UILabel
    @IBOutlet var minor: UILabel
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: UITableViewCellStyle.Value1, reuseIdentifier: reuseIdentifier)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
