//
//  medCellTableViewCell.swift
//  FohoApp
//
//  Created by AaronR on 1/5/17.
//  Copyright © 2017 Aaron Renfroe. All rights reserved.
//
//  Used in FeedViewControler
// Camper Meds
// Storecard transactions

import UIKit

class FeedItemCellTableViewCell: UITableViewCell {


    @IBOutlet weak var header: UILabel!

    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var detailsTextView: UITextView!
    
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var viewWidthConstraint:
        NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.current.userInterfaceIdiom == .pad{
            NSLayoutConstraint.deactivate([viewWidthConstraint])
            NSLayoutConstraint(item: secondView, attribute: .width, relatedBy: .equal, toItem: self.contentView, attribute: .width, multiplier: 0.75, constant: 0.0).isActive = true
        }else{
            backgroundColor = .white
            secondView.backgroundColor = .white
        }
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
