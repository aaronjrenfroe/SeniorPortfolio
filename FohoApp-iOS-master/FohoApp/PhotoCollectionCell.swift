//
//  PhotoCollectionCell.swift
//  FohoApp
//
//  Created by AaronR on 2/27/17.
//  Copyright © 2017 Aaron Renfroe. All rights reserved.
//
// Used to show mediaLinks on FeedView

import UIKit

class PhotoCollectionCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var thumbnailWidthConstraint: NSLayoutConstraint!
    var link: String!
    var eventTitle: String!
    //var photoSetId = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if UIDevice.current.userInterfaceIdiom == .pad{
            NSLayoutConstraint.deactivate([thumbnailWidthConstraint])
            NSLayoutConstraint(item: thumbnail, attribute: .width, relatedBy: .equal, toItem: self.contentView, attribute: .width, multiplier: 0.75, constant: 0.0).isActive = true
        }else{
            backgroundColor = .white
            
        }
       
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
