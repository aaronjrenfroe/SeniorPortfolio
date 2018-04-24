//
//  File.swift
//  AlamoFireTests
//
//  Created by Aaron Renfroeon 12/16/16.
//  Copyright © 2016 Aaron Renfroe. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration
import Kingfisher
import CoreData

class Person {
    
    let firstName, lastName, entityId : String
    let familyID : Array<String>
    
    
    
    init(first: String, last: String, id: String, familyID: Array<String>) {
        firstName = first
        lastName = last
        self.entityId = id
        self.familyID = familyID
    }
    
    public var description: String {
        return ("\(firstName), \(lastName), entityID: \(entityId), FamilyID: \(familyID)")
        
    }
    
}

class User: Person {
    
    var apiToken : String
    
    init(user: Person, apiToken: String) {
        
        self.apiToken = apiToken
        super.init(first: user.firstName, last: user.lastName, id: user.entityId, familyID: user.familyID)
        
    }
    
    override public var description: String {
        return "\(super.description), APIToken: \(apiToken)"
    
    }
}

class CampCenter{

    
    class func getAbrv(id2: String)-> String{
        
        let Abrvs = ["6":"TV","7":"AM","8":"CS","9":"LV","10":"FC","11":"WL","12":"Ojai","13":"CR","1006":"NDC"]
        
        if Abrvs[id2] != nil{
            return Abrvs[id2]!
        }
        else { return "FH" } // if key is not found return Generic
    }
    
    class func getFullName(id2: String)-> String{
        let FullNames = ["6":"The Village","7":"Adventure Mountain","8":"Creekside","9":"Lakeview","10":"Forest Center","11":"Woodlands","12":"Ojai","13":"Cedar Ridge","1006":"Neighborhood Day Camp"]
        
        if FullNames[id2] != nil{
            return FullNames[id2]!
        }
        else { return "Forest Home" } // if key is not found return Generic
    }
    class func getMapLink(id: String)-> String{
        let baseLink = "http://maps.apple.com/?daddr="
        let tailLink = "&dirflg=d&t=h"
        let campCenterXY = [
            "9":["x":"34.0929","y":"-116.9285"],
            "10":["x": "34.0877","y":"-116.92902"],
            "8":["x": "34.0903","y":"-116.9271"]] as [String : Any]
        
        guard let xy = campCenterXY["\(id)"] as? Dictionary<String,String> else{
            return "http://maps.apple.com/?daddr=40000,+Valley+of+the+Falls+Drive,+Forest+Falls,+California&dirflg=d&t=h"
        }
        
        if xy["x"] != nil{
            
            return("\(baseLink)\(xy["x"]!),\(xy["y"]!)\(tailLink)")
        }else {
            return "http://maps.apple.com/?daddr=40000,+Valley+of+the+Falls+Drive,+Forest+Falls,+California&dirflg=d&t=h"
            
        }
    }
    
}


class MyDateTime{
    
    class func getNextMidnight()->Date{
        var cmpDate = Calendar(identifier: .gregorian).startOfDay(for: Date())
        cmpDate = Calendar.current.date(byAdding: .day, value:1, to: cmpDate)!
        return cmpDate
    }
    
    class func stringToDate(string: String)-> Date{
        let formatter  = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd'T'HH:mm:s"
        formatter.timeZone = TimeZone(abbreviation: "GMT")
        let cleanString = string.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "T")
        if let myDate = formatter.date(from: cleanString) {
            return myDate
        }else{
            return stringToDateWithoutT(string: string)
        }
        
    }
    
    class func stringToDateWithoutT(string: String)-> Date{
        let formatter  = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd HH:mm:s"
        formatter.timeZone = TimeZone(abbreviation: "GMT")
        let cleanString = string.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "T", with: " ")
        return formatter.date(from: cleanString)!
    }
    
    class func getDayOfWeek(dateString:String)->String {
        
        let formatter  = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd'T'HH:mm:s"
        let dateDate = formatter.date(from: dateString)!
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let myComponents = myCalendar.components(.weekday, from: dateDate)
        let weekDay = myComponents.weekday
        switch weekDay as Int! {
        case 1:
            return "Sunday"
        case 2:
            return "Monday"
        case 3:
            return "Tuesday"
        case 4:
            return "Wednesday"
        case 5:
            return "Thursday"
        case 6:
            return "Friday"
        default:
            return "Saturday"
            
        }
       
    }
    
    class func getDayOfWeek(date: Date)->String {
        
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let myComponents = myCalendar.components(.weekday, from: date)
        let weekDay = myComponents.weekday
        switch weekDay as Int! {
        case 1:
            return "Sunday"
        case 2:
            return "Monday"
        case 3:
            return "Tuesday"
        case 4:
            return "Wednesday"
        case 5:
            return "Thursday"
        case 6:
            return "Friday"
        default:
            return "Saturday"
            
        }
        
    }
    
    class func dateStringToYear(timeString: String) -> Int{

        return Int((convertString(timeString: timeString, displayFormat: "YYYY")as NSString).intValue) //"2017"
    }
    
    class func dateToPrettyString(timeString: String, offsetHours: Double = 0 ) -> String{
        
        //return convertString(timeString: timeString, displayFormat: "MMMM d, YYYY 'at' h:mm a", offsetHours: offsetHours) // March 12, at 4:00 PM
        return convertString(timeString: timeString, displayFormat: "MMMM d, YYYY", offsetHours: offsetHours) // March 12, at 4:00 PM
    }
    class func dateToPrettyStringNoTime(timeString: String) -> String{
        
        return convertString(timeString: timeString, displayFormat: "MMMM d, YYYY") // March 12, at 4:00 PM
    }
    
    class func dateToMonthDayYear(timeString: String) -> String{
        
        return convertString(timeString: timeString, displayFormat: "MMMM d, YYYY") // March 12, 2017
    }
    class func hourForTime(timeString: String)-> String{
        
        return convertString12HR(timeString: timeString, displayFormat: "h a") // hour am/pm
    }
    
    class func time(timeString: String) -> String{
        
        return convertString(timeString: timeString, displayFormat: "h:mm a") // 4:00 PM
    }
    class func dateOnly(timeString: String) -> String{
        return convertString(timeString: timeString, displayFormat: "MMM d, YYYY") // Mar 12, 2017
    }
    class func monthAndDay(timeString: String) -> String{
        return convertString(timeString: timeString, displayFormat: "MMM d") // Mar 12
    }
    class func month(timeString: String) -> String{
        return convertString(timeString: timeString, displayFormat: "MMM") // Mar 12
    }
    
    class func day(timeString: String) -> String{
        let day = convertString(timeString: timeString, displayFormat: "d") // Mar 12
        switch day {
            case "1": return "1st"
            case "2": return "2nd"
            case "3": return "3rd"
            case "21": return "21st"
            case "22": return "22nd"
            case "23": return "23rd"
            case "31": return "31st"
            default: return ("\(day)th")
        }
    }
    
    class func dateRange(startString: String, endString: String) -> String{
        
        let startMonth = convertString(timeString: startString, displayFormat: "MMM.")
        let endMonth = convertString(timeString: endString, displayFormat: "MMM.")
        let startDay = convertString(timeString: startString, displayFormat: "d")
        let endDay = convertString(timeString: endString, displayFormat: "d")
        var formatedStart = convertString(timeString: startString, displayFormat: "MMM. d")
        if startDay == endDay && startMonth == endMonth {
            formatedStart.append(convertString(timeString: endString, displayFormat: ", YYYY"))
        }else{
            if (startMonth != endMonth){
                
                formatedStart.append(convertString(timeString: endString, displayFormat: "-MMM. d, YYYY"))
                
            }else{
                formatedStart.append(convertString(timeString: endString, displayFormat: "-d, YYYY"))
            }
        }
        return formatedStart
    }
    private class func convertString12HR(timeString: String, displayFormat: String)-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd'T'HH:mm:s"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let showDate = dateFormatter.date(from: timeString){
            
            dateFormatter.dateFormat = displayFormat
            return dateFormatter.string(from: showDate)
            
        }
        else {
            return ""
        }
    }
    
    private class func convertString(timeString: String, displayFormat: String, offsetHours: Double = 0)-> String{
        let dateFormatter = DateFormatter()
        if timeString.contains("T"){
            dateFormatter.dateFormat = "YYYY-MM-dd'T'HH:mm:s"
        }else{
            dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:s"
        }
        
        //dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let showDate = dateFormatter.date(from: timeString){
            
            dateFormatter.dateFormat = displayFormat
            
            let modDate = showDate.addingTimeInterval(3600.0 * offsetHours)
            
            
            return dateFormatter.string(from: modDate)
            
        }
        else {
            return ""
        }
    }

    private class func convertStringNoT(timeString: String, displayFormat: String)-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:s"
        print(timeString)
        if let showDate = dateFormatter.date(from: timeString){
            
            dateFormatter.dateFormat = displayFormat
            return dateFormatter.string(from: showDate)
            
        }
        else {
            return ""
        }
    }
    
    public class func NowPDT()-> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "America/Los_Angeles")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter.string(from: Date())
    }
    
    public class func NowPDTInterval(){
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "America/Los_Angeles")
        
    }
}
class Reachability {
    class func isConnected() -> Bool{
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    
}

extension String {
    
    func CapitaliseFirstLetterOfEveryWord() -> String{
        if self.characters.count < 1 {
            return ""
        }
        var charOld = Array(self.characters)
        var charNew = Array(self.capitalized.characters)
        
        for i in 0...charNew.count-1 {
            
            if (String(charNew[i]).lowercased() != String(charOld[i])){
                charNew[i] = charOld[i]
            }
        }
            
        return String(charNew)
    }
    
}


