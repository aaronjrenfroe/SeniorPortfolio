//
//  photoViewCell.swift
//  FohoApp
//
//  Created by AaronR on 3/5/17.
//  Copyright © 2017 Aaron Renfroe. All rights reserved.
//

import UIKit

class PhotoViewCell: UICollectionViewCell {
    var url = String()
    var hqURL = String()
    
    @IBOutlet weak var campImage: UIImageView!
    
    override func awakeFromNib() {
        print("cell was awaken")
        campImage.contentMode = .scaleAspectFill
        
    }
}
