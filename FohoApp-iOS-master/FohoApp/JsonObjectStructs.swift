//
//  File.swift
//  FohoApp
//
//  Created by AaronR on 1/16/17.
//  Copyright © 2017 Aaron Renfroe. All rights reserved.
//

import Foundation
import CoreData

enum feedItemType{
    case VIDEO
    case IMAGES
    case MED_RECORD
    case CARD_TRANSACTION
    case POST
}
struct CamperMed {
    let dosageStatus: String
    let dosageTimeOfDay: String
    let entityFullName : String
    let entityID: String
    let entryDate: String
    let logDate: String
    let logID : String
    let medName: String
    let type = feedItemType.MED_RECORD
    
}

struct CardTransaction{
    let entityID : String
    let invoiceNumber: String
    let name: String
    let time: String
    let totalCharged: String
    let transactionType: String
    let itemsPurchased: Dictionary<String, AnyObject>
    let type = feedItemType.CARD_TRANSACTION
    
}

struct feedItemStruct {
    
    let type : feedItemType
    let item : AnyObject
    let time : String
    
}

