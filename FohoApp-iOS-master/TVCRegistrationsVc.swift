//
//  FamilyItinerariesVC.swift
//  FohoApp
//
//  Created by Aaron Renfroe on 12/30/16.
//  Copyright © 2016 Aaron Renfroe. All rights reserved.
//

import UIKit
import Foundation
import EventKit
import CoreData
import Flurry_iOS_SDK

class TVCRegistrationsVc: UITableViewController {
    
    var familyMembersData : [FamilyMember] = []
    var itineraryData : [Itinerary] = []
    var pastItins: [Itinerary] = []
    var upcomingItins : [Itinerary] = []
    var mediaLinksForEvents = Dictionary<String, FeedItem>()
    
    // This is for the FamilyCamp Remaining balance Calculations
    
    var familyCampItins : [Itinerary] = []
    
    // this is used for the Event Options Presentation
    var viewReturnPoint = CGPoint(x: 0, y: 0)
    let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.dark))
    var lastSelectedCellIndex = 0
    var isRefreshing = false
    var mediaLinkData: [FeedItem] = []
    var photoSetURLToBeViewed: String!
    var photoSetTitle: String!
    
    // Called when View is loaded in memory
    override func viewDidLoad() {
        super.viewDidLoad()
        itinsUpdated()
        updateMediaLinkData()
        
        
        
        let adjustForTabbarInsets: UIEdgeInsets = UIEdgeInsetsMake(0, 0, (self.tabBarController!.tabBar.frame.height), 0);
        //Where tableview is the IBOutlet for your storyboard tableview.
        self.tableView.contentInset = adjustForTabbarInsets;
        self.tableView.scrollIndicatorInsets = adjustForTabbarInsets;
        
        self.refreshControl?.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControlEvents.valueChanged)
        self.tableView.refreshControl?.backgroundColor = Settings.REFRESH_CONTROL_BACKGROUND
        self.tableView.tableFooterView = UIView()
        self.viewReturnPoint = self.view.center
        Flurry.logEvent("Registrations_Did_Load");
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)

        NotificationCenter.default.addObserver(self, selector: #selector(connectionFailure), name: NSNotification.Name(rawValue: "LoginFailure"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateMediaLinkData), name: NSNotification.Name(rawValue: "MediaLinksFinished"), object: nil)
        
    }
    
    func itinsUpdated(){
        // Everything in dispatch.sync will run first in the background before moving on
        DispatchQueue.global(qos: .userInteractive).sync {
            self.updateItineraryData()
            self.updateFamilyMembersData()
        }
        familyCampItins = []
        for itin in itineraryData{
            if itin.eventTypeID == "1" {
                familyCampItins.append(itin)
                if itin.entityID != UserDefaults.standard.string(forKey: "entityID"){
                
                    itineraryData.remove(at: itineraryData.index(of: itin)!)
                }
            }
        }
        sortEvents()
        self.isRefreshing = false
        self.tableView.refreshControl?.endRefreshing()
        addLastUpdateTimeToRefreshControl()
        self.tableView.reloadData()
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        NotificationCenter.default.removeObserver(name:"MediaLinksFinished")
        NotificationCenter.default.removeObserver(name:"LoginFailure")
        
        if segue.identifier == "showPhotosFromRegOptions", let destinationVC = segue.destination as? PhotoCollectionVC{
            
            destinationVC.viewTitle = photoSetTitle
            destinationVC.detailViewURL = photoSetURLToBeViewed
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       
        
    }
    
    /**
     Number of sections in table View. Currently 2: The ones that have past and the ones that have not past.
     */
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        if pastItins.count > 0, upcomingItins.count>0{
            return 2
        }
        else {
            return 1
        }
    }
    
    /**
     Counts the number of events in each section and returns them.
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0,upcomingItins.count>0{
            return upcomingItins.count
            
        }else{
            return pastItins.count
        }
        
    }
    /**
     Returns the title of each section
     */
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height:30)) //set these values as necessary
        returnedView.backgroundColor =  UIColor.init(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)//UIColor.init(hex: 0x53AFD6, alpha: 1)
        
        let label = UILabel(frame: CGRect(x: 10, y: 2.5, width: self.view.frame.width, height:25))
        label.textColor = UIColor.black
        label.font = UIFont.init(name: "Avenir Next Medium", size: 20)
        label.textAlignment = .center
        if section == 0, upcomingItins.count>0{
            label.text = "Current Registrations"
        }else if (pastItins.count>0){
            label.text = "Past Registrations"
        }else{
            label.text = "You have no Registrations with us"
        }
        returnedView.addSubview(label)
        
        
        return returnedView
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Current Registrations"
        }else{
            return"Past Registrations"
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Configure the cell...
        
        
        //let items = [upcomingItins,pastItins]
        
        let itinerary: Itinerary
        
        if indexPath.section == 0, upcomingItins.count>0{
            itinerary = self.upcomingItins[indexPath.row]
        }else{
            itinerary = self.pastItins[indexPath.row]
        }
        
        //print("Name and Event: \(itinerary.eventName)")
        //print("Registration ID: \(itinerary.registrationID)")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "regCell", for: indexPath) as! RegistrationCell
        if itinerary.eventID != nil {
            cell.eventID = itinerary.eventID!
        }
        
        if (indexPath.row % 2 == 0){
            cell.backgroundColor = Settings.CELL_COLOR_1
            self.tableView.backgroundColor = Settings.CELL_COLOR_2
        } else{
            cell.backgroundColor = Settings.CELL_COLOR_2
            self.tableView.backgroundColor = Settings.CELL_COLOR_1
        }
        cell.locationID = itinerary.locationID!
        if cell.locationID == "1006"{
            cell.eventNameLabel.text = "\(MyDateTime.dateStringToYear(timeString: itinerary.beginDateTime!)) \(CampCenter.getFullName(id2: itinerary.locationID!))"
        }else{
            cell.eventNameLabel.text = itinerary.eventName
        }
        cell.dateLabel.text = MyDateTime.dateRange(startString: itinerary.beginDateTime!, endString: itinerary.endDateTime!)
        cell.campCenterID = itinerary.locationName!
        
        if itinerary.eventTypeID == "1"{
            //if itinerary.entityID == UserDefaults.standard.string(forKey: "entityID"){
            
            //MARK : Find out why it broke here
            
            
            cell.eNameLabel.text = "\(fetchLastname(familyMemberID: itinerary.entityID!)) Family"
            
            
            let balanceString = formatBalance(balance: (getFamilycampBalance(eventID: itinerary.eventID!)))
            cell.dollarAmountLabel.text = balanceString
            cell.remainingBalanceLabel.text = "Balance:"
            
            
            if (cell.dollarAmountLabel.text != ("$0.00")){
                cell.dollarAmountLabel.textColor = Settings.RED_WEB_COLOR
            }else{
                cell.dollarAmountLabel.textColor = UIColor.black
            }

            
        } else{

            cell.eNameLabel.text = fetchPerson(familyMemberID: itinerary.entityID!)
            cell.remainingBalanceLabel.text = ""
            cell.dollarAmountLabel.text = ""
            
        }
        cell.eventTypeID = itinerary.eventTypeID!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd'T'HH:mm:s"
        dateFormatter.timeZone = TimeZone(identifier: "American/LosAngeles")
        cell.calenderDate = dateFormatter.date(from: itinerary.beginDateTime!)!
        cell.endDate = dateFormatter.date(from: itinerary.endDateTime!)!
        
        //        cell.optionsBtn.addTarget(self, action: #selector(TVCRegistrationsVc.showEventOptions), for: .touchUpInside)
        cell.registrationID = itinerary.registrationID!
        cell.eventDevisionID = itinerary.eventDivisionID!
        cell.entityID = itinerary.entityID!
        let hour = MyDateTime.hourForTime(timeString: itinerary.beginDateTime!)
        
        if itinerary.locationID! == "1006"{
            cell.checkinInfo.text = "Check-in \(cell.calenderDate > Date() ? "is":"was") at \(hour)"
        }else{
            cell.checkinInfo.text = "Check-in \(cell.calenderDate > Date() ? "is":"was") at \(hour) in \(CampCenter.getFullName(id2: itinerary.locationID!))"
        }
        
        
        //MyDateTime.NowPDT()
        
        
        //let mask = 100000
        
        //cell.optionsBtn.tag = indexPath.row
        //cell.optionsBtn.tag += (mask * indexPath.section)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath) as! RegistrationCell
        showEventOptions(cell: cell)
    }
    
    func sortEvents(){
        upcomingItins = Array()
        pastItins = Array()
        for itin in itineraryData{
            
            if (itin.endDateTime! > Date().description){
                upcomingItins.append(itin)
            }else{
                pastItins.append(itin)
            }
        }
        upcomingItins.sort{
            $0.beginDateTime! < $1.beginDateTime!
        }
    }
    
    
    func showEventOptions(cell : RegistrationCell){
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        var itinData : [Itinerary] = Array<Itinerary>()
        do {
            let fetR:NSFetchRequest = Itinerary.fetchRequest()
            fetR.sortDescriptors = [NSSortDescriptor(key: "beginDateTime", ascending: false)]
            itinData = try context.fetch(fetR)
        } catch{
            
        }
        
        var names = ""
        var familyCount: Int = 0
        if cell.eventTypeID == "1" {
            for itin in itinData {
                
                if itin.eventID! == cell.eventID {
                    if names != "" {
                        names.append(", ")
                    }
                    
                    names.append(fetchPerson(familyMemberID: itin.entityID!))
                    familyCount += 1
                }
            }
            switch familyCount{
                case 2:
                    names = names.replacingOccurrences(of: ",", with: " and")
                    break
                case 3..<(Int.max):
                    let lastComma: NSRange = (names as NSString).range(of: ",", options: .backwards)
                    if lastComma.location != NSNotFound {
                        names = (names as NSString).replacingCharacters(in: lastComma, with: " and")
                    }
                    break
                default:
                    break
            }
            
        }
        // Create Action Sheet
        if familyCount == 0 {
            names = cell.eNameLabel.text!
        }
        var message = ""
        if cell.eventTypeID == "8" {
            message = "This is a Non-program Event and options may be limited."
        }
        let actionSheet = UIAlertController(title: "\(names):\n\(cell.eventNameLabel.text!)", message: message, preferredStyle: .actionSheet)
        // If event Has started
        if ((cell.calenderDate as Date) <= Date()){
            // Addrebooking option
            if cell.eventTypeID != "8" {
                let rebookAction = UIAlertAction(title: "Request Rebooking", style: .default){ (action)-> Void in
                    if Reachability.isConnected(){
                        self.sendRebookingRequest(name: cell.eNameLabel.text!, id: cell.entityID, event: cell.eventNameLabel.text!, regID: cell.registrationID)
                    }else{
                        self.noConnectionAlert(error: "It appears you are not connected to the internet. Can not send request")
                    }
                }
                actionSheet.addAction(rebookAction)
            }
            
            // If event has not started
        }else{
            // add add calender option
            let calendarAction = UIAlertAction(title: "Add to Calender", style: .default){ (action) -> Void in
                Flurry.logEvent("Added Registration to Calendar from Registration Cell")
                self.addDateToCallender(cell:cell)
            }
                
            //}
            actionSheet.addAction(calendarAction)
            //actionSheet.addAction(rebookNotifierAction)
        }
        //If event has not ended. add directions options
        if !((cell.endDate as Date) < Date()){
            let directionsAction = UIAlertAction(title: "Get Directions", style: .default){(action) -> Void in
                Flurry.logEvent("Got Directions from Registration Cell")
                self.getDirectionsToEvent(cell: cell)


            }
            actionSheet.addAction(directionsAction)
            
        }else{
            // check if there are photo/video media links and them here
            
            //TODO: Add Videos to past Registrations options
            // view photos
            // view highlight video
        }
            updateMediaLinkData()
        
            if let photoLink = mediaLinksForEvents[cell.eventID] {
                
                let viewPhotos = UIAlertAction(title: "View Photos", style: .default){ (action)-> Void in
                    if Reachability.isConnected(){
                        let params = ["link":photoLink]
                        Flurry.logEvent("Viewed photos from Registration Cell", withParameters: params)
                        self.viewPhotos(photoFeedItem: photoLink)
                    }else{
                        self.noConnectionAlert(error: "It appears you are not connected to the internet")
                    }
                }
                actionSheet.addAction(viewPhotos)
            }
        
        
        // Always add a done button
        let cancelAction = UIAlertAction(title: "Done", style: .cancel){ (action) -> Void in
            
        }
        
        actionSheet.addAction(cancelAction)
        
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = cell.viewWithTag(99)
            popoverController.sourceRect = (cell.viewWithTag(99)?.bounds)!
        }
        present(actionSheet, animated: true, completion: nil)
        
    }
    
    func viewPhotos(photoFeedItem : FeedItem){
        photoSetURLToBeViewed = photoFeedItem.url
        photoSetTitle = photoFeedItem.title
        performSegue(withIdentifier: "showPhotosFromRegOptions", sender: self)
    }
    
    
    // Add Event to Devices Calender
    func addDateToCallender(cell: RegistrationCell){
        
        let eventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            if (granted) && (error == nil) {
                let event = EKEvent(eventStore: eventStore)
                event.title = cell.eventNameLabel.text!
                event.startDate = cell.calenderDate as Date
                event.endDate = cell.endDate as Date
                event.notes = "\(cell.eNameLabel.text!) is registered for \(cell.eventNameLabel.text!) with Forest Home. Meeting space is located in \(cell.campCenterID)"
                event.calendar = eventStore.defaultCalendarForNewEvents
                
                
                do {
                    try eventStore.save(event, span: .thisEvent)
                    
                    
                } catch let e as NSError {
                    //completion?(false, e)
                    
                    self.noConnectionAlert(error: "Failed to add event to your Calendar, Message: \(e)")
                    return
                }
                self.gotoAppleCalendar(date: event.startDate)
            } else {
                self.appNeedsCalanderPermisions()
            }
        })
        
    }
    
    
    func getDirectionsToEvent(cell: RegistrationCell){
        
        
        let url = URL(string: CampCenter.getMapLink(id: cell.locationID))
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        
    }
    func fetchPerson(familyMemberID: String) -> String{
        for f in familyMembersData{
            if (f.entityID == familyMemberID){
                return f.firstName!
            }
        }
        return ""
    }
    func fetchLastname(familyMemberID: String) -> String{
        for f in familyMembersData{
            if (f.entityID == familyMemberID){
                return f.lastName!
            }
        }
        return ""
    }
    
    func updateItineraryData(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            let fetR:NSFetchRequest = Itinerary.fetchRequest()
            fetR.sortDescriptors = [NSSortDescriptor(key: "beginDateTime", ascending: false)]
            itineraryData = try context.fetch(fetR)
        } catch{
            
        }
    }
    func updateFamilyMembersData(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            familyMembersData = try context.fetch(FamilyMember.fetchRequest())
        } catch{
            
        }
    }
    
    func updateMediaLinkData(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        var untouchedItins : [Itinerary] = []
        
        do {
            
            mediaLinkData = try context.fetch(FeedItem.fetchRequest())
            untouchedItins = try context.fetch(Itinerary.fetchRequest())
        } catch{
            
        }
        
        for photoLink in mediaLinkData {
            for event in untouchedItins {
                if  event.registrationID == photoLink.registrationID{
                    mediaLinksForEvents[event.eventID!] = photoLink
                }
            }
        }
    }
    
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from the server if they exist
        if !isRefreshing && Reachability.isConnected(){
            isRefreshing = true
            
            HTTPRequestManager2.fetchItineraries(){ () in
                self.itinsUpdated()
                self.tableView.refreshControl?.endRefreshing()
            }
            
        }else if (!Reachability.isConnected()){
            noConnectionAlert(error: "It appears you are not connected to the internet")
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(10), execute: {
            self.tableView.refreshControl?.endRefreshing()
        })
        
    }
    
    func addLastUpdateTimeToRefreshControl(){
        var refreshString = ""
        if let updateTime = (UserDefaults.standard.object(forKey: "ItinsLastUpdated") as? Date){
            
            let titleLabel = self.refreshControl?.subviews.first?.subviews.last
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: TimeZone.current.abbreviation()!)
            if (Date().timeIntervalSince(updateTime) < (24 * 60 * 60)) {
                dateFormatter.dateStyle = .none
                dateFormatter.timeStyle = .short
                
            }else{
                dateFormatter.dateFormat = "h:mm a, MMM dd"
            }
            if(titleLabel != nil){
                if let titleLabelLabel = titleLabel as? UILabel {
                    titleLabelLabel.numberOfLines = 0
                    refreshString = "Last updated \(dateFormatter.string(from: updateTime))\n"
                    
                }
            }
        }
        self.refreshControl?.attributedTitle = NSAttributedString(string: refreshString)
        
    }

    
    func getFamilycampBalance(eventID: String)-> Int32{
        var bal: Int32 = 0;
        for i in familyCampItins{
            
            if (i.eventTypeID == "1"){
                
                if i.eventID == eventID {
                    bal += i.registrationBalance
                }
            }
        }
        return bal
    }
    
    
    func eventAddedToCallenderNotification(eventName: String){
        let alertController = UIAlertController(title: "Done", message: eventName, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func appNeedsCalanderPermisions(){
        let alertController = UIAlertController(title: "The App needs permissions", message: "Open your Settings app > Privacy > Calander, and and grant permissions for Forest Home Adventure Guide", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func formatBalance(balance: Int32) -> String{
        let number = NSDecimalNumber(value: balance) //(string: balance)//(decimal: balance)
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        
        return numberFormatter.string(from: number)!
    }
    
    func connectionFailure(notification: NSNotification){
        isRefreshing = false
        self.tableView.refreshControl?.endRefreshing()
        
        let error = notification.object as! String
        
        let alertController = UIAlertController(title: "UH-OH", message: error, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        ProgressView.shared.hideProgressView()
        
        present(alertController, animated: true, completion: nil)
    }
    
    func noConnectionAlert(error: String){
        self.tableView.refreshControl?.endRefreshing()
        let alertController = UIAlertController(title: "UH-OH", message: error, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    func gotoAppleCalendar(date: Date) {
        let interval = date.timeIntervalSinceReferenceDate
        let url = URL(string: "calshow:\(interval)")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
    }
    
    func sendRebookingRequest(name: String, id: String, event: String, regID: String){
        
        
        var urlAsString = "http://aaronrenfroe.com/fohoapp/rebooking/rebooking-email.php?name=\(name)&event=\(event)&regid=\(regID)&entityid=\(id)"
        urlAsString = urlAsString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
       
        if let url = URL(string: urlAsString){
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard error == nil else {
                    
                    let params = ["name":name,"id":id,"event":event,"regID":regID, "reason": error.debugDescription]
                    Flurry.logEvent("Unable to Send Rebook Email", withParameters : params)
                    return
                }
                guard let data = data else {
                    
                    let params = ["name":name,"id":id,"event":event,"regID":regID, "reason": "data returned was nil"]
                    Flurry.logEvent("Unable to Send Rebook Email", withParameters : params)
                    return
                }
                
                let json = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, AnyObject>
                guard let result = json["status"] as? String else{
                    self.notifyRebooking(result: "We were not able to process request but please try again later")
                    let params = ["name":name,"id":id,"event":event,"regID":regID, "reason": "bad return status from script"]
                    Flurry.logEvent("Unable to Send Rebook Email", withParameters : params)
                    return
                }
                self.notifyRebooking(result: result)
            }
            
            task.resume()
        }
    }
    
    
    func notifyRebooking(result: String){
        var title = ""
        var message = ""
        if (result == "sent"){
            title = "You're Set"
            message = "Our Registration team will contact you soon to confirm"
        }else{
            title = "Uh Oh"
            message = "Your request was unable to be sent."
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}


