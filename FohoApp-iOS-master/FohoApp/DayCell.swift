//
//  DayCell.swift
//  FohoApp
//
//  Created by AaronR on 4/29/17.
//  Copyright © 2017 Aaron Renfroe. All rights reserved.
//

import UIKit

class DayCell: UITableViewCell {
    
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var iconView: UIView!
    

    @IBOutlet weak var lowTemp: UILabel!
    @IBOutlet weak var highTemp: UILabel!
    var precipProb: Double = -0.01
    var summary: String = ""
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func setIcon(icon: String){
        iconView.subviews.forEach({ $0.removeFromSuperview() })
        
        let frame = CGRect(x: iconView.frame.width/2, y: (iconView.frame.height/2)-8, width: iconView.frame.width, height: iconView.frame.height)
        let iconView2 = SKYIconView(frame: frame)
        if let iconEnum = Skycons(rawValue: icon){
            iconView2.setType = iconEnum
            iconView2.setColor = UIColor.white
            iconView2.backgroundColor = UIColor.clear
            //iconView2.pause()
            iconView.addSubview(iconView2)
            
            
        }
    }

}
