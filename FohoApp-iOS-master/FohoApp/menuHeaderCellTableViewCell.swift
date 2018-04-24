//
//  menuHeaderCellTableViewCell.swift
//  FohoApp
//
//  Created by Aaron Renfroeon 12/19/16.
//  Copyright © 2016 Aaron Renfroe. All rights reserved.
//

// Drawer Menu is a tableView this is the generic Cell for the header aka the colored part

import UIKit

class menuHeaderCellTableViewCell: UITableViewCell {


    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
        // Configure the view for the selected state
        
    }

}
