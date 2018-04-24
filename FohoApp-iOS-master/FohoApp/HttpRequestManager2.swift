//
//  UpdateRefresh.swift
//  FohoApp
//
//  Created by AaronR on 1/9/17.
//  Copyright © 2017 Aaron Renfroe. All rights reserved.

import Foundation
import UIKit
import CoreData

enum RequestType {
    case AUTH
    case MEDS_UPDATE
    case ITINERARY_UPDATE
    case STORE_CARD_UPDATE
    case STORE_CARD_BALANCES
    case MEDIA_LINKS
    case PICTURES_UPDATE
    case VIDEO_UPDATE
    case BLOG_UPDATE
    case SCHEDULED_POST_UPDATE
    case WEATHER
}
enum Campus{
    case FOREST_FALLS
    case OJAI
}

class HTTPRequestManager2 {
    
    private static var familyMembersData: [FamilyMember] = []
    private static var itineraryData: [Itinerary] = []
    private static var medRecordData : [MedRecord] = []
    private static var storeCardTransactionsData : [StoreCardTransaction] = []
    private static var storeCardData : [StoreCard] = []
    private static var mediaLinkData: [FeedItem] = []
    private static var scheduledPostData: [ScheduledPost] = []
    
    
    class func getStoreCardBalance(completion: @escaping ()-> Void){
        let defaults = UserDefaults.standard
        if let entityID = defaults.string(forKey: "entityID"){
            let url = Settings.Card_Balances_URL
            let requestType = RequestType.STORE_CARD_BALANCES
            let parameters = ["Jesus": "is risen","1": entityID]
            generalRequester(parameters: parameters, url: url, requestType: requestType){
                () in
                completion()
            }
        }
    }
    
    class func fetchMeds(completion: @escaping ()-> Void){
        
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "isAuthed") == true{
            
            if let entityID = defaults.string(forKey: "entityID"){
                let url = Settings.UPDATE_Meds_Test
                let parameters = ["Jesus": "is risen","1": entityID]
                generalRequester(parameters: parameters, url: url, requestType: RequestType.MEDS_UPDATE){
                    () in
                    completion()
                }
            }
        }
    }
    
    class func fetchItineraries(completion: @escaping ()-> Void){
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "isAuthed") == true{
            
            if let entityID = defaults.string(forKey: "entityID"){
                let url = Settings.UPDATE_Family_SERVER
                let parameters = ["Jesus": "is risen","1": entityID]
                generalRequester(parameters: parameters, url: url, requestType: RequestType.ITINERARY_UPDATE){
                    () in
                    completion()
                }
            }
        }
    }
    
    class func fetchStoreCards(completion: @escaping ()-> Void){
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "isAuthed") == true{
            
            if let entityID = defaults.string(forKey: "entityID"){
                //let entityID = "27"//"35251"
                let url = Settings.UPDATE_Store_Cards_Test
                let parameters = ["Jesus": "is risen","1": entityID]
                generalRequester(parameters: parameters, url: url, requestType: RequestType.STORE_CARD_UPDATE){
                    () in
                    completion()
                }
            }
        }
    }
    class func fetchMediaLinks(completion: @escaping ()-> Void){
        
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "isAuthed") == true{
            let url = Settings.Media_Links_URL
            if let entityID = defaults.string(forKey: "entityID"),let apiToken = defaults.string(forKey: "apiToken") {
                let parameters = ["Jesus": "is risen", "2": apiToken,"1": entityID]
                
                generalRequester(parameters: parameters, url: url, requestType: RequestType.MEDIA_LINKS){
                    () in
                    completion()
                }
            }
        }
    }
    class func fetchScheduledPosts(completion: @escaping ()-> Void){
        
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "isAuthed") == true{
            let url = Settings.Scheduled_Posts_URL
            if let entityID = defaults.string(forKey: "entityID"),let apiToken = defaults.string(forKey: "apiToken") {
               let parameters = ["Jesus": "is risen", "2": apiToken,"1": entityID]
                
                generalRequester(parameters: parameters, url: url, requestType: RequestType.SCHEDULED_POST_UPDATE){
                    () in
                    completion()
                }
            }
        }
    }
    
    class func ct_Auth2(email: String, pass: String, completion: @escaping ()-> Void){
        //let requestType = RequestType.AUTH
        let url = Settings.AUTH_SERVER
        let parameters = ["Jesus": "is risen","1": "\(email)", "2": "\(pass)"]
        generalRequester(parameters: parameters, url: url, requestType: RequestType.AUTH){
            () in
            completion()
        }
    }

    class func updateInfo(completion: @escaping (_ good: Bool)-> Void){
        var count = 0
        fetchItineraries(){
            () in
            count += 1
            if count == 5 {
                UserDefaults.standard.set(Date(), forKey: "FeedLastUpdated")
                completion(true)
            }
        }
        fetchMeds(){
            () in
            count += 1
            if count == 5 {
                UserDefaults.standard.set(Date(), forKey: "FeedLastUpdated")
                completion(true)
            }
        }
        fetchScheduledPosts(){
            () in
            count += 1
            if count == 5 {
                UserDefaults.standard.set(Date(), forKey: "FeedLastUpdated")
                completion(true)
            }
        }
        fetchStoreCards(){
            () in
            count += 1
            if count == 5 {
                UserDefaults.standard.set(Date(), forKey: "FeedLastUpdated")
                completion(true)
            }
        }
        fetchMediaLinks(){
            () in
            count += 1
            if count == 5 {
                UserDefaults.standard.set(Date(), forKey: "FeedLastUpdated")
                completion(true)
            }
        }
        
    }
    
    
    class func generalRequester(parameters: [String: Any], url: String, requestType: RequestType, completion: @escaping ()-> Void){
        // Login HTTP Post request
        
//        let boundary = "jesus"
//        let headers = [
//            "content-type": "application/json; boundary=\(boundary)",
//            "cache-control": "no-cache"
//        ]
//
//        var body = ""
//
//        for param in parameters {
//            let paramName = param["name"]!
//            body += "--\(boundary)\r\n"
//            body += "Content-Disposition:form-data; name=\"\(paramName)\""
//            body += "\r\n\r\n\(param["value"]!)\r\n"
//
//        }
//
//        body += "--\(boundary)"
        let headers = [
            "Content-Type": "application/json",
            "Cache-Control": "no-cache"]
        
        let body = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 60.0)
        request.httpMethod = "Post"
        request.allHTTPHeaderFields = headers
        request.httpBody = body as Data//.data(using: .utf8)
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        print("Called: \(requestType)")
        
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            print("Returned: \(requestType)")
            if (error != nil) {
                
                connectionFailure(error:error?.localizedDescription ?? "Connection Failure")
                print("Failed: \(requestType)")
            } else {
                
                DispatchQueue.main.async {
                    
                    do{ // try and see if the server gave us good json -> if good -> processs
                        let dataDict = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, AnyObject>
                        guard let statusCode = ((dataDict["StatusCode"] as? NSNumber)) else {
                            print(dataDict)
                            connectionFailure(error: "Could not connect to server")
                            
                            return
                        }
                        
//                        --------Sends data to another function to be handled-------------
//
//                        let string1 = String(data: data!, encoding: String.Encoding.utf8) ?? "Data could not be printed"
//                        print("************************************RAW JSON*******************************************")
//
//                        print(dataDict)
//                        print("************************************RAW JSON*******************************************")
//                         StatusCode 1 -> Good, Not 1 -> Bad
                        if statusCode == 1 {
                            self.sendToDataProcessor(requestType: requestType, data: dataDict)
                            completion()
                        }else{
                            guard let message = ((dataDict["StatusMessage"] as? String)) else {
                                connectionFailure(error: "Could not Connect")
                                return
                            }
                            connectionFailure(error: "\(message)")
                        }
                        
                    }catch{
                        
                        connectionFailure(error: "The server might be down try again later")
                        NSLog("json error: \(error.localizedDescription)")
                        // error
                        let string1 = String(data: data!, encoding: String.Encoding.utf8) ?? "Data could not be printed"
                        print("************************************RAW JSON*******************************************")
                        print(string1)
                        print("************************************RAW JSON*******************************************")
                        
                    }
                }
            }
        })
        
        dataTask.resume()
        
    }
    
    private class func sendToDataProcessor(requestType:RequestType, data: Dictionary<String, AnyObject>){
        
        switch requestType {
        case .AUTH:
            processAuthData(data: data)
            
        case .MEDS_UPDATE:
            processMeds(data: data)
        case .ITINERARY_UPDATE:
            saveItinerariesFromRefresh(data: data)
            break
            
        case .STORE_CARD_UPDATE:
            saveStoreCardTransactions(data: data)
        case .STORE_CARD_BALANCES:
            saveStoreCardBalances(data: data)
        case .MEDIA_LINKS:
            processMediaLinks(data: data)
            break
        case .SCHEDULED_POST_UPDATE:
            processScheduledPosts(data: data)
            break
            
            //case RequestType.PICTURES_UPDATE: break
            
            //case RequestType.VIDEO_UPDATE: break
            
        default:
            break
        }
        
        let defaults = UserDefaults.standard
        
        if (defaults.bool(forKey: "isAuthed") == false){
            defaults.set(true, forKey: "isAuthed")
        }
        
    }
    /*
     self.deleteAllData(entity: "FamilyMember")
     self.deleteAllData(entity: "Itinerary")
     self.deleteAllData(entity: "MedRecord")
     self.deleteAllData(entity: "StoreCardTransaction")
     self.deleteAllData(entity: "StoreCard")
     */
    
    /**************************************************************************/
    // Initial Login Json Processing
    /**************************************************************************/
    
    private class func processAuthData(data: Dictionary<String, AnyObject>){
        
        
        let defaults = UserDefaults.standard
        
        if let apiToken = data["ApiToken"] as? String{
            defaults.set(apiToken, forKey: "apiToken")
        }
        if let apiURL = data["CompanyAPIURL"] as? String{
            defaults.set(apiURL, forKey: "CompanyAPIURL")
        }
        if let firstName = data["FirstName"] as? String{
            defaults.set(firstName, forKey: "firstName")
        }
        if let lastName = data["LastName"] as? String{
            defaults.set(lastName, forKey: "lastName")
        }
        if let entityIDNumber = data["EntityID"] as? NSNumber{
            let entityID = "\(entityIDNumber)"
            defaults.set(entityID, forKey: "entityID")
        }
        if let familyIDs = data["FamilyIDs"] as? NSMutableArray{
            defaults.set(familyIDs, forKey: "familyIDs")
            
        }
        if let familyMembers = data["FamilyMembers"] as? NSMutableArray{
            saveFamilyMembersInCoreData(familyMembersArray: familyMembers)
        }
        
        if let itineraries = data["Itineraries"] as? NSMutableArray{
            // add function that stores itineraries in CoreData
            
            defaults.setValue(itineraries, forKey:"familyItineries")
            
            saveItinerariesInCoreData(itinerariesArray: itineraries)
        }
    }
    
    /**************************************************************************/
    // Family Members
    /**************************************************************************/
    
    // saves family members to CoreData ----------------------------------
    private class func saveFamilyMembersInCoreData(familyMembersArray: NSMutableArray){
        
        deleteAllData(entity:"FamilyMember")
        
        // for each person downloaded from the server
        
        var counter = 0
        for i in 0...familyMembersArray.count-1 {
            let m = familyMembersArray[i] as! Dictionary<String, AnyObject>
            // check if exist in coreData
            let entityID = "\(m["IndividualsEntityID"] as! NSNumber)"
            updateFamilyMembersData()
            if (!checkIfExistsInFamilyMembers(id: entityID)){
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                let member = FamilyMember(context: context)
                member.firstName = m["IndividualsFirstName"] as? String
                member.lastName = m["IndividualsLastName"] as? String
                member.entityID = entityID
                member.gender = m["Gender"] as? String
                
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                
                counter = counter + 1
            }
            
        }
        
    }
    
    private class func checkIfExistsInFamilyMembers(id: String) -> Bool{
        for i in familyMembersData{
            if(i.entityID == id){
                print("Family Member found: not adding")
                return true
            }
        }
        print("Family Member not found: adding")
        return false
        
    }
    
    private class func updateFamilyMembersData(){
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            familyMembersData = try context.fetch(FamilyMember.fetchRequest())
        } catch{
            print("fetching error")
        }
    }
    /**************************************************************************/
    // Itineraries
    /**************************************************************************/
    // --------------saves Itineraries to CoreData----------------------------------
    private class func saveItinerariesInCoreData(itinerariesArray: NSMutableArray){
        
        deleteAllData(entity: "Itinerary")
        
        var counter = 0
        // for each person downloaded from the server
        if (itinerariesArray.count != 0){
            for i in 0...itinerariesArray.count-1 {
                let m = itinerariesArray[i] as! Dictionary<String, AnyObject>
                // check if exist in coreData
                let entityID = "\(m["EntityID"] as! NSNumber)"
                let eventID = "\(m["EventID"] as! NSNumber)"
                let registrationID = "\(m["RegistrationID"] as! NSNumber)"
                
                updateItineraryData()
                if (!checkIfExistsInItineraries(rID: registrationID)){
                    
                    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                    let itin = Itinerary(context: context)
                    itin.beginDateTime = m["BeginDateTime"] as? String
                    itin.endDateTime = m["EndDate"] as? String
                    itin.eventName = m["EventsName"] as? String
                    itin.itineraryID = "\(m["ItineraryID"] as! NSNumber)"
                    itin.locationID = "\(m["LocationID"] as! NSNumber)"
                    itin.locationName = m["LocationsName"] as? String
                    itin.eventTypeID =  "\(m["EventTypeID"] as! NSNumber)"
                    if let balance = (m["RegistrationBalance"] as? NSNumber){
                        itin.registrationBalance = Int32(balance)
                    }
                    
                    itin.eventID = eventID
                    itin.entityID = entityID
                    itin.registrationID = registrationID
                    itin.eventDivisionID = "\(m["EventDivisionID"] as! NSNumber)"
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    
                    counter = counter + 1
                }
            }
            //updateItineraryData()
             UserDefaults.standard.set(Date(), forKey: "ItinsLastUpdated")
        }
        
    }
    
    private class func saveItinerariesFromRefresh(data: Dictionary<String, AnyObject>){
        let defaults = UserDefaults.standard
        
        if let itineraries = data["Itineraries"] as? NSMutableArray{
            
            defaults.set(itineraries, forKey: "Itineraries")
            saveItinerariesInCoreData(itinerariesArray: itineraries)
            
        }
        
        if let familyMembers = data["FamilyMembers"] as? NSMutableArray{
            if (familyMembers.count > 1 && familyMembersData.count > 1){
                defaults.set(familyMembers, forKey: "familyMembers")
                saveFamilyMembersInCoreData(familyMembersArray: familyMembers)
            }
        }
    }
    
    private class func checkIfExistsInItineraries(rID: String) -> Bool{
        for i in itineraryData{
            if(i.registrationID == rID){
                print("Itinerary found: not adding")
                return true
            }
        }
        print("Itinerary not found: adding")
        return false
        
    }
    
    private class func updateItineraryData(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            itineraryData = try context.fetch(Itinerary.fetchRequest())
        } catch{
            print("fetching error")
        }
    }
    /**************************************************************************/
    // CamperMeds
    /**************************************************************************/
    // processes data from update request
    private class func processMeds(data: Dictionary<String, AnyObject>){
        deleteAllData(entity: "MedRecord")
        let recordsCount = Int(data["RecordsCount"] as! NSNumber)
        if (recordsCount > 0){
            guard let recordsArray = data["Records"] as? Array<Dictionary<String, AnyObject>> else{
                return
            }
            
            for i in 0...(recordsArray.count - 1){
                let medicationRecord = recordsArray[i]
                updateMedRecordData()
                // store campermeds in core data
                if (!existsInMedRecordsData(id: ("\(medicationRecord["LogID"] as! NSNumber)"))){
                    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                    let newMedRecord = MedRecord(context: context)
                    newMedRecord.dosageTimeOfDay = medicationRecord["DosageTimeOfDay"] as? String
                    newMedRecord.logID = ("\(medicationRecord["LogID"] as! NSNumber)")
                    newMedRecord.dosageStatus = medicationRecord["DosageStatus"] as? String
                    newMedRecord.time = medicationRecord["LogDate"] as? String
                    newMedRecord.entryDate = medicationRecord["EntryDate"] as? String
                    newMedRecord.medName = medicationRecord["MedName"] as? String
                    newMedRecord.entityFullName = medicationRecord["EntityName"] as? String
                    newMedRecord.entityID = ("\(medicationRecord["EntityID"] as! NSNumber)")
                    
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    
                }
            }
            
        }else{
            print("No records to check/add")
        }
        
    }
    
    private class func existsInMedRecordsData(id: String) -> Bool{
        for i in medRecordData{
            
            if((i.logID! as String) == id){
                print("Medication record found: Not Adding")
                return true
            }
            
        }
        print("Medication record not found: adding")
        
        return false
        
    }
    
    private class func updateMedRecordData(){
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            let fetR:NSFetchRequest = MedRecord.fetchRequest()
            fetR.sortDescriptors = [NSSortDescriptor(key: "time", ascending: false)]
            medRecordData = try context.fetch(fetR)
        } catch{
            print("fetching error")
        }
        
    }
    
    /**************************************************************************/
    // StoreCards Transactions
    /**************************************************************************/
    private class func saveStoreCardTransactions(data: Dictionary<String, AnyObject>){
        self.deleteAllData(entity: "StoreCardTransaction")
        //let string1 = String(data: data!, encoding: String.Encoding.utf8) ?? "Data could not be printed"
        guard let results = data["Results"] as? Dictionary<String, AnyObject> else{
            return
        }
        if results.count > 0 {
            
            for (_,transaction) in results{
                if let item = (transaction as? NSArray)?[0] as? Dictionary<String, AnyObject>{
                    updatestoreCardTransactionsData()
                    if !checkIfIsNewTransaction(invoiceID: item["invoice"] as! String){
                        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                        let newTransaction = StoreCardTransaction(context: context)
                        
                        newTransaction.entityID = "3709" //"\(String(describing: item["entityID"] as? NSNumber))" // concatinates NSNumber to String
                        newTransaction.invoiceNumber = item["invoice"] as?String
                        newTransaction.name = item["name"] as? String
                        newTransaction.time = item["time"] as? String
                        newTransaction.totalCharged = "\(formatBalance(balance:item["charge"] as! NSNumber as! Double))"
                        newTransaction.transactionType = item["transactionDescription"] as? String
                        newTransaction.itemsPurchased = transaction as? Array<Dictionary<String, AnyObject>> as NSObject?
                        newTransaction.itineraryID = "\(item["itineraryID"] as! NSNumber)"
                        
                        (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    }
                }
            }
        }
    }
    
    private class func checkIfIsNewTransaction(invoiceID: String) -> Bool{
        for i in storeCardTransactionsData{
            let wantedId = i.invoiceNumber
            if (wantedId == invoiceID){
                return true
            }
        }
        return false
    }
    private class func formatBalance(balance: Double) -> String{
        let number = NSDecimalNumber(value: balance) //(string: balance)//(decimal: balance)
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        
        return numberFormatter.string(from: number)!
    }
    
    private class func updatestoreCardTransactionsData(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            let fetR:NSFetchRequest = StoreCardTransaction.fetchRequest()
            fetR.sortDescriptors = [NSSortDescriptor(key: "time", ascending: false)]
            storeCardTransactionsData = try context.fetch(fetR)
        } catch{
            print("fetching error")
        }
    }
    
    /**************************************************************************/
    // StoreCard Balances
    /**************************************************************************/
    private class func saveStoreCardBalances(data: Dictionary<String, AnyObject>){
        
        guard let results = data["Results"] as? NSArray else{
            return
        }
        deleteAllData(entity: "StoreCard")
        if results.count > 0 {
            
            for person in results{
                for card in (person as? NSArray)!{
                    if let item = card as? Dictionary<String, AnyObject>{
                        //TODO: implement saving of storecardBalances
                        guard let status = item["GiftCardStatus"]as? String else {
                            break
                        }
                        if (status != ""){
                            
                            
                            guard let fName = item["FirstName"] as? String else{
                                break
                            }
                            guard let lName = item["LastName"]as? String else {
                                break
                            }
                            guard let entityID = item["CamperID"] as? Int32 else{
                                break
                            }
                            guard let eventName = item["EventName"]as? String else {
                                break
                            }
                            
                            guard let credit = item["Credit"] as? Float else {
                                break
                            }
                            guard let debit = item["Debit"] as? Float else {
                                break
                            }
                            guard let gender = item["Gender"] as? String else {
                                break
                            }
                            guard let willDonate = item["DonateRemainingBalance"] as? String else {
                                break
                            }
                            guard let date = item["BeginDate"] as? String else {
                                break
                            }
                            guard let regid = item["RegistrationID"] as? Int32 else {
                                break
                            }
                            
                            if(!storeCardExists(wantedEvent: eventName,wantedCamper: "\(entityID)")){
                                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                                let newCard = StoreCard(context: context)
                                newCard.credits = Double(credit)
                                newCard.debits = Double(debit)
                                newCard.donateRemainingBalance = (willDonate == "True") ? true : false
                                newCard.entityID = "\(entityID)"
                                newCard.event = eventName
                                newCard.firstName = fName
                                newCard.gender = gender
                                newCard.lastName =  lName
                                newCard.pendingTransactions = 0.0
                                newCard.status = status
                                newCard.date = date
                                newCard.registrationID = String(regid)
                                
                                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                            }
                            
                        }
                    }
                }
            }
        }
        
    }
    
    private class func storeCardExists(wantedEvent: String, wantedCamper: String) -> Bool{
        updateStoreCardData()
        for i in storeCardData{
            let eventName = i.event
            let entityID = i.entityID
            if (eventName == wantedEvent && entityID == wantedCamper){
                return true
            }
        }
        return false
    }
    
    class func updateStoreCardData(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            let fetR:NSFetchRequest = StoreCard.fetchRequest()
            fetR.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            storeCardData = try context.fetch(fetR)
        } catch{
            print("fetching error")
        }
    }
    /**************************************************************************/
    // Media Links
    /**************************************************************************/
    
    private class func processMediaLinks(data: Dictionary<String, AnyObject>){
        guard let results = data["LinkSummaries"] as? Array<Dictionary<String, AnyObject>> else{
            return
        }
        deleteAllData(entity: "FeedItem")
        if results.count > 0 {
            for mediaInfo in results {
                guard let eventName = mediaInfo["Name"] as? String else{
                    continue
                }
                guard let link = mediaInfo["Link"] as? String else{
                    continue
                }
                guard let originalLink = mediaInfo["OriginalLink"] as? String else{
                    continue
                }
                guard let caption = mediaInfo["Caption"] as? String else{
                    continue
                }
                guard let thumbPath = mediaInfo["ThumbPath"] as? String else {
                    continue
                }
                guard let registrationID = mediaInfo["RegistrationID"] as? Int32 else{
                    continue
                }
                updateItineraryData()
                
                guard let endDate = itineraryData.first(where: { $0.registrationID == registrationID.description})?.endDateTime else{
                    continue
                }
                
                print("\(eventName)\n\(link)\n\(caption)\n\(thumbPath)\n\(registrationID)\n\(endDate)")
                updateMediaLinkData()
                if (!mediaLinkExists(url: link)){
                    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                    let newItem = FeedItem(context: context)
                    newItem.title = eventName
                    newItem.url = link
                    newItem.originalUrl = originalLink
                    
                    if link.contains("flickr"){
                        newItem.type = "flickr"
                    }else if link.contains("vimeo"){
                        continue
                        //newItem.type = "vimeo"
                    }else{
                        continue
                        //newItem.type = "unknown"
                    }
                    newItem.thumbPath = thumbPath
                    newItem.time = endDate
                    newItem.caption = caption
                    newItem.registrationID = String(registrationID)
                    print("************\nSaved MediaLink\n****************")
                    
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                }
                
            }
            
        }
        let defaults = UserDefaults.standard
        defaults.setValue(Date(), forKey: "mediaLastUpdateTime")
        NotificationCenter.default.post(name: Notification.Name(rawValue: "MediaLinksFinished"), object: nil)
        
    }
    
    private class func mediaLinkExists(url: String)-> Bool{
        for mediaLink in mediaLinkData{
            if mediaLink.url == url{
                return true
            }
        }
        return false;
    }
    private class func updateMediaLinkData(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            mediaLinkData = try context.fetch(FeedItem.fetchRequest())
        } catch{
            print("fetching error")
        }
    }
    
    /**************************************************************************/
    // Scheduled Posts
    /**************************************************************************/
    
    private class func processScheduledPosts(data: Dictionary<String, AnyObject>){
        print(data)
        guard let results = data["Posts"] as? Array<Dictionary<String, AnyObject>> else{
            return
        }
        deleteAllData(entity: "ScheduledPost")
        if results.count > 0 {
            for post in results {
                
                guard let postId = post["Post_ID"] as? String else{
                    continue
                }
                var eventEventID = ""
                
                if post["Event_ID"] as? String != nil{
                    eventEventID = (post["Event_ID"] as? String)!
                }
                
                updatePostData()
                if (!postExists(postId: postId, eventID: eventEventID)){
                    guard let title = post["Title"] as? String else{
                        print("Broke at title")
                        continue
                    }
                    guard let thumbPath = post["Thumnail_URL"] as? String else {
                        print("Broke at THumbnail")
                        continue
                    }
                    guard let body = post["Body"] as? String else {
                        print("Broke at Body")
                        continue
                    }
                    guard let excerpt = post["Excerpt"] as? String else {
                        print("Broke at Excerpt")
                        continue
                    }
                    guard let expireDate = post["Expire_Date"] as? String else {
                        print("Broke at Expire_Date")
                        continue
                    }
                    guard let visableDate = post["Visable_Date"] as? String else {
                        print("Broke at Show Date")
                        continue
                    }
                    //                guard let hasAttachment = post["Has_Attachmment"] as? Int32 else{
                    //                    continue;
                    //                }
                    
                    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                    let newPost = ScheduledPost(context: context)
                    
                    
                    newPost.event_id = eventEventID
                        
                    
                    if let locationID = post["Location_ID"]as? String{
                        newPost.location_id = locationID
                    }else{
                        newPost.location_id = "0"
                    }
                    if let excerpt = post["Excerpt"] as? String  {
                        newPost.excerpt = excerpt
                    }else {
                        newPost.excerpt = ""
                    }
                    newPost.post_id = postId
                    newPost.title = title
                    newPost.thumbpath = thumbPath
                    newPost.body = body
                    newPost.excerpt = excerpt
                    newPost.expire_date = expireDate
                    newPost.time = visableDate.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "T")
                    
                    /*
                     if (hasAttachment != 0){
                     
                     }
                     */
                    
                    //Do the things with the stuff
                    
                    print("************\nSaved Post\n****************")
                    
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                }
                
            }
            
        }
        
    }
    
    private class func postExists(postId: String, eventID: String)-> Bool{
        for post in scheduledPostData{
            if post.post_id == postId{
                return true
            }
        }
        return false;
    }
    
    private class func updatePostData(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            scheduledPostData = try context.fetch(ScheduledPost.fetchRequest())
        } catch{
            print("fetching error")
        }
    }
    
    /**************************************************************************/
    // Done With Request Notifier
    /**************************************************************************/
    // This broadcasts a notification appwide that the json refresh and sorting is complete
    // For Updating tables
    
    
    private class func connectionFailure(error: String){
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "LoginFailure"), object: error)
        
    }
    class func clean(){
        HTTPRequestManager2.familyMembersData = []
        HTTPRequestManager2.itineraryData = []
        HTTPRequestManager2.medRecordData = []
        
    }
    
    
    class func getWeather(url: String, campus: Campus, completion: @escaping ()-> Void){
        // Set up the URL request
        
        guard let url = NSURL(string: url) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = NSURLRequest(url: url as URL)
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: urlRequest as URLRequest, completionHandler: { (data, response, error) in
            // do stuff with response, data & error here
            if error != nil{print(error!)}
            else{
                do{
                    let dataDict = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, AnyObject>
                    let defaults = UserDefaults.standard
                    
                    if campus == Campus.FOREST_FALLS{
                        defaults.set(dataDict, forKey: "weatherForestFalls")//Dictionary<String, AnyObject>
                    }else{
                        defaults.set(dataDict, forKey: "weatherOjai")//Dictionary<String, AnyObject>
                    }
                    completion()
                    
                }catch{
                    NSLog("json error: \(error.localizedDescription)")
                    // error
//                    let string1 = String(data: data!, encoding: String.Encoding.utf8) ?? "Data could not be printed"
//                    print("************************************RAW JSON*******************************************")
//                    print(string1)
//                    print("************************************RAW JSON*******************************************")
                }
                
            }
        })
        task.resume()
    }
    
    public class func getMonthlyBlogs(completion: @escaping ()-> Void){
        // Set up the URL request
        
        guard let url = NSURL(string: Settings.Blog_Url) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = NSURLRequest(url: url as URL)
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: urlRequest as URLRequest, completionHandler: { (data, response, error) in
            // do stuff with response, data & error here
            if error != nil{print(error!)}
            else{
                do{
                    let dataDict = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, AnyObject>
                    if dataDict["status"] as! String == "ok"{
                        processBlogUpdate(data: dataDict["blogs"] as! Array, completion: completion)
                    }
                    
                }catch{
                    NSLog("json error: \(error.localizedDescription)")
                    // error
//                    let string1 = String(data: data!, encoding: String.Encoding.utf8) ?? "Data could not be printed"
//                    print("************************************RAW JSON*******************************************")
//                    print(string1)
//                    print("************************************RAW JSON*******************************************")
                }
                
            }
        })
        task.resume()
    }
    
    class func processBlogUpdate(data: Array<Dictionary<String, AnyObject>>, completion: @escaping ()-> Void){
        
        
        if data.count > 0 {
            var blogs : Array<Dictionary<String, String>> = []
            
            for blogData in data{
                
                guard let _ = blogData["author"] as? String else{
                    break
                }
                guard let _ = blogData["title"] as? String else{
                    break
                }
                guard let _ = blogData["date"] as? String else {
                    break
                }
                guard let _ = blogData["content"] as? String else {
                    break
                }
                guard let _ = blogData["excerpt"] as? String else {
                    break
                }
                guard let _ = blogData["banner"] as? String else {
                    break
                }
                guard let _ = blogData["author_image"] as? String else{
                    break
                }
                
                blogs.append(blogData as! [String : String])
            }
            
            let defaults = UserDefaults.standard
            defaults.set(blogs, forKey: "blogs")
        }
        
        completion()
    }
    
    private class func deleteAllData(entity: String){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let fetch =  NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        request.resultType = .resultTypeCount
        do{
            let results = try context.execute(request)
            print("\(results.description)")
        } catch{
            print("could not delete")
        }
    }
    
}
