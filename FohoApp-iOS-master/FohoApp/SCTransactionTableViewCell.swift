//
//  SCTransactionTableViewCell.swift
//  FohoApp
//
//  Created by AaronR on 7/11/17.
//  Copyright © 2017 Aaron Renfroe. All rights reserved.
//

import UIKit

class SCTransactionTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var detailTextView: UITextView!
    
    @IBOutlet weak var icon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        

        // Configure the view for the selected state
    }
    
}
