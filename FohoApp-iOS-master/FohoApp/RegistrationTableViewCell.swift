//
//  RegistrationCell.swift
//  FohoApp
//
//  Created by AaronR on 1/5/17.
//  Copyright © 2017 Aaron Renfroe. All rights reserved.
//

import UIKit

class RegistrationCell: UITableViewCell {
    
    var calenderDate : Date = Date()
    var endDate : Date = Date()
    var campCenterID : String = ""
    var locationID : String = ""
    
    // the following is needed for rebooking
    var registrationID : String = ""
    var eventDevisionID: String = ""
    var entityID: String = ""
    var eventID: String = ""
    var eventTypeID: String = ""
    
    @IBOutlet weak var eNameLabel: UILabel!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var remainingBalanceLabel: UILabel!
    @IBOutlet weak var dollarAmountLabel: UILabel!
    
    @IBOutlet weak var checkinInfo: UILabel!

    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //optionsBtn.setImage(#imageLiteral(resourceName: "optionsButtn_lightGrey"), for: .normal)
        //optionsBtn.imageView!.tintColor = UIColor.lightGray
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
