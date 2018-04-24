//
//  OutlineButton.swift
//  FohoApp
//
//  Created by AaronR on 4/5/17.
//  Copyright © 2017 Aaron Renfroe. All rights reserved.
//

import UIKit

class OutlineButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setTitleColor(UIColor.white, for: .normal)
        layer.borderColor = UIColor.white.cgColor
        backgroundColor = UIColor.clear
        
        layer.borderWidth = 1.5
        
        layer.cornerRadius = 5

    }

}
