//
//  UserTableViewCell.swift
//  Divvy Marathon
//
//  Created by Jack Cable on 7/15/15.
//  Copyright © 2015 Jack Cable. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet var usernameLabel: UILabel!
    
    @IBOutlet var scoreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
