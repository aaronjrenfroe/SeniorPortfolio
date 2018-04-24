//
//  TableViewCell.swift
//  FohoApp
//
//  Created by AaronR on 3/23/17.
//  Copyright © 2017 Aaron Renfroe. All rights reserved.
//

import UIKit

class BlogCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var authorImage: UIImageView!
    @IBOutlet weak var exceprt: UITextView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var author: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
