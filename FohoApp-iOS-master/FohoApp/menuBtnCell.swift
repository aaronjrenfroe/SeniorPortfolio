//
//  menuBtnCell.swift
//  FohoApp
//
//  Created by Aaron Renfroeon 12/19/16.
//  Copyright © 2016 Aaron Renfroe. All rights reserved.
//

import UIKit

class menuBtnCell: UITableViewCell {
    // Drawer Menu is a tableView this is the generic Cell for a Menu Button

    @IBOutlet weak var iconImg: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        title.tintColor = UIColor.lightGray
        // Configure the view for the selected state
    }

}
