//
//  FeedViewController.swift
//  FohoApp
//
//  Created by Aaron Renfroeon 12/17/16.
//  Copyright © 2016 Aaron Renfroe. All rights reserved.
//

import UIKit
import CoreData
import Kingfisher
import AVFoundation
import AVKit
import YTVimeoExtractor
import PDFReader
import Flurry_iOS_SDK

class TVCFeedVc: UITableViewController {
    
    var medRecordData : [MedRecord] = []//HTTPRequestManager.getMostResentMedRecordData()
    var storeCardData: [StoreCardTransaction] = []//HTTPRequestManager.getMostRecentStoreCardData()
    var mediaLinkData: [FeedItem] = []
    var scheduledPosts: [ScheduledPost] = []
    var itemsInFeed : [feedItemStruct] = []
    var itineraryIDToName : [String: String] = [:]
    var storeCardsUpdateReturn = false
    var feedItemsUpdateReturn = false
    var scheduledPostsReturn = false
    var nextViewContent: String!
    var nextViewTitle: String!
    var postDate : String = ""
    var nextBlogEventName = ""
    var postType : PostType!
    var postImageURL : String!
    var videoUrl : URL!
    var mediaLinksTimer : Timer?

    var isRefreshing = false
    
    
    override func viewDidLoad() {
        

        super.viewDidLoad()
        // gets data stored on disk

        
        
        // Adjusts for Tab bar
        let adjustForTabbarInsets: UIEdgeInsets = UIEdgeInsetsMake(0, 0, (self.tabBarController!.tabBar.frame.height), 0);
        //Where tableview is the IBOutlet for your storyboard tableview.
        self.tableView.contentInset = adjustForTabbarInsets;
        self.tableView.scrollIndicatorInsets = adjustForTabbarInsets;
        
        
        let refreshControl = UIRefreshControl()
        let refreshControlText = "Meds can take a few hours to update"
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: UIControlEvents.valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: refreshControlText)
        self.refreshControl? = refreshControl
        
        addLastUpdateTimeToRefreshControl()
        
        self.tableView.refreshControl?.backgroundColor = Settings.REFRESH_CONTROL_BACKGROUND
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 140
        Flurry.logEvent("Feed_Did_Load");
        //self.tableView.tableFooterView = UIView()
        //self.viewReturnPoint = self.view.center

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        if let oldDate = (UserDefaults.standard.object(forKey: "FeedLastUpdated") as? Date) {
            
            if oldDate.addingTimeInterval(1) < Date() {
                handleRefresh()
            }
        }
        
        updateViews()
        nextViewContent = ""
        NotificationCenter.default.addObserver(self, selector: #selector(mediaFinished), name: NSNotification.Name(rawValue: "MediaLinksFinished"), object: nil)
        
    }
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            print(self.view.frame.width * 0.125)
            self.tableView.separatorInset.left = self.view.frame.width * 0.125
            self.tableView.separatorInset.right = self.view.frame.width * 0.125
            self.tableView.separatorInset.top = self.view.frame.width * 0.125
            self.tableView.separatorInset.bottom = self.view.frame.width * 0.125
            
        }
 
    }
    
    func mediaFinished(){
        updateViews()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        NotificationCenter.default.removeObserver(name: NSNotification.Name(rawValue: "MediaLinksFinished"))
        
            // Get the new view controller using [segue destinationViewController].
            // Pass the selected object to the new view controller.
        if segue.identifier == "photoCollectionSegue", let destinationVC = segue.destination as? PhotoCollectionVC{
            
            destinationVC.viewTitle = nextViewTitle
            destinationVC.detailViewURL = nextViewContent
            // viewing a blog post
        }else if segue.identifier == "viewPostSegue", let destinationVC = segue.destination as? BlogView{
            destinationVC.titleString = nextViewTitle
            destinationVC.dateString = "\(MyDateTime.getDayOfWeek(dateString: postDate))  \(MyDateTime.dateToMonthDayYear(timeString: postDate))"
            destinationVC.contentHtmlString = nextViewContent
            destinationVC.bannerString = postImageURL
            destinationVC.authorString = nextBlogEventName
            // viewing a vimeo video
        }else if segue.identifier == "VideoPlayerSegue", let destinationVC = segue.destination as? AVPlayerViewController{
            destinationVC.player = AVPlayer(url: self.videoUrl)
            
            let articleParams = ["Title": nextViewTitle]
            Flurry.logEvent("Played_Video", withParameters: articleParams)
        }
        
    }
    // pulls the data from Core data and refreshed the views with new data
    func updateViews(){
        
            updateMedRecordData()
            updateStoreCardData()
            updateMediaLinkData()
            updateItineraryData()
            updateScheduledPostsData()
            itemsInFeed = self.mergeFeedItems()
        
            isRefreshing = false
        
            self.tableView.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        
        }
        
    
    // merges and sorts the feed Item arrays based on time
    // optimized this by putting all items into mergeFeedItems and then sorting by time
    // this would also make this super scaleable
    func mergeFeedItems() -> [feedItemStruct]{
        
        var mergedArray : [feedItemStruct] = []
        // --adds meds to the new feed array
        for med in medRecordData{
            if (med.dosageStatus == "Administered"
                || med.dosageStatus == "Checked-In"
                ) {
                
                let feedItem = feedItemStruct(type: feedItemType.MED_RECORD, item: med as AnyObject, time: med.time!)
                mergedArray.append(feedItem)
            }
        }
        // --adds meds to the new feed array
        for trans in storeCardData{
            let feedItem = feedItemStruct(type: feedItemType.CARD_TRANSACTION, item: trans as AnyObject, time: trans.time!)
            mergedArray.append(feedItem)
        }
        for link in mediaLinkData{
            if (MyDateTime.stringToDate(string: link.time!)) < Date().addingTimeInterval(518400.0){
                let feedItem = feedItemStruct(type: feedItemType.IMAGES, item: link as AnyObject, time: link.time!)
                mergedArray.append(feedItem)
            }
        }
        for post in scheduledPosts{
            
            
            if MyDateTime.stringToDate(string: post.time!).description <= MyDateTime.NowPDT(){
                
                if post.expire_date == "0000-00-00" || MyDateTime.stringToDate(string: post.expire_date!).description > MyDateTime.NowPDT(){
                    
                    let feedItem = feedItemStruct(type: feedItemType.POST, item: post as AnyObject, time: post.time!)
                    mergedArray.append(feedItem)
                }
            }
        }
        
        mergedArray.sort{
            
            if ( $0.time == $1.time && $0.type == .POST && $1.type == .POST){
                
                    let p1 = $0.item as! ScheduledPost
                    let p2 = $1.item as! ScheduledPost
                    
                    return p1.post_id! > p2.post_id!
                
            }else{
                return $0.time > $1.time
            }
        }
        
        return mergedArray
    }
    // MARK: - Table view data source
    //******************************************************
    //************* Table View Delegate Methods ************
    //******************************************************
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemsInFeed.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        if (!Reachability.isConnected()){
            noConnectionAlert(error: "It appears that you are not connected to the internet to download this content")
        }else{
            
            if let cell = tableView.cellForRow(at: indexPath) as? PhotoCollectionCell{
                
                    nextViewContent = cell.link
                    nextViewTitle = cell.eventTitle
                    performSegue(withIdentifier: "photoCollectionSegue", sender: self)
                
            }else if let cell = tableView.cellForRow(at: indexPath) as? PostTableViewCell{
                
                switch cell.state!{
                    case .BLOG:
                        nextViewContent = cell.getBody()
                        nextViewTitle = cell.getTitleText()
                        postDate = cell.getDate()
                        postType = cell.state!
                        postImageURL = cell.imageURL
                        nextBlogEventName = itineraryIDToName[cell.eventID!] ?? ""
                        performSegue(withIdentifier: "viewPostSegue", sender: self)
                        
                        break
                    
                    case .VIMEO:
                        
                        nextViewTitle = cell.getTitleText()
                        playVimeoVideo(url: cell.getBody())
                        break
                    case .PDF:
                        attemptToDisplayPDF(from: cell.getBody(), with: cell.getTitleText())
                        
                        break
                }
                
            }
        }
    }
    func attemptToDisplayPDF(from url: String,with title: String){
        if let pdfUrl = URL(string: url){
            // Downloads PDF Async
            DispatchQueue.global(qos: .userInitiated).sync {
                if let document = PDFDocument(url: pdfUrl){
                    
                    DispatchQueue.main.async {
                        let readerController = PDFViewController.createNew(with: document, title: title, actionButtonImage: nil, actionStyle: .activitySheet)
                        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
                        self.navigationController?.navigationBar.titleTextAttributes = (titleDict as! [String : Any])
                        self.navigationController?.pushViewController(readerController, animated: true)
                    }
                }else{
                    DispatchQueue.main.async {
                        
                        let params = ["Pdf Url": url]
                        Flurry.logEvent("Bad PDF", withParameters: params)
                        self.noConnectionAlert(error: "It Appears you were given a broken PDF link")
                    }
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if ( itemsInFeed.count % 2 == 0){
            self.tableView.backgroundColor = Settings.CELL_COLOR_2
        }else{
            self.tableView.backgroundColor = Settings.CELL_COLOR_1
        }
        
        let feedItem = itemsInFeed[indexPath.row] as feedItemStruct
        let cell: UITableViewCell!
        
        switch feedItem.type {
        case .MED_RECORD:
            cell = medRecordCell(record: feedItem.item as! MedRecord, indexPath: indexPath)
        case .CARD_TRANSACTION:
            cell = cardTransactionCell(transaction: feedItem.item as! StoreCardTransaction, indexPath: indexPath)
        case.IMAGES:
            cell = photoAlbumCell(media: feedItem.item as! FeedItem, indexPath: indexPath)
        case.POST:
            cell = postCell(post: feedItem.item as! ScheduledPost, for: indexPath)
        default:
            
            let articleParams = ["FeedItemType": feedItem.type]
            Flurry.logEvent("unknown_FeedItemType", withParameters: articleParams)
            cell = UITableViewCell()
        }

        
        return cell
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (itemsInFeed[indexPath.row] as feedItemStruct).type {
        case .POST:
            return super.tableView(tableView, heightForRowAt: indexPath)
            /*
            var value = self.view.frame.width * 0.65
            if UIDevice.current.userInterfaceIdiom == .pad{
                value *= 0.75
            }
            return value
 */
            
        case .IMAGES:
            return super.tableView(tableView, heightForRowAt: indexPath)
            
        default :
            return super.tableView(tableView, heightForRowAt: indexPath)
        
        }
    }
    
    func playVimeoVideo(url: String){
        
        
        YTVimeoExtractor.shared().fetchVideo(withVimeoURL: url, withReferer: nil, completionHandler: {(_ video: YTVimeoVideo?, _ error: Error?) -> Void in
            if (video != nil) {
                
                //Will get the lowest available quality.
                //NSURL *lowQualityURL = [video lowestQualityStreamURL];
                //Will get the highest available quality.
                self.videoUrl = video!.highestQualityStreamURL()
                
                self.performSegue(withIdentifier: "VideoPlayerSegue", sender: self)
            }
            else {
                let params = ["Vimeo Link" : url]
                Flurry.logEvent("Bad Vimeo Link", withParameters: params)
                self.noConnectionAlert(error: "It appears you were given a broken link to this video.")
            }
        })
    }
    //******************************************************
    //*************** Photo Cell ***************************
    //******************************************************

    func photoAlbumCell(media: FeedItem, indexPath: IndexPath)-> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "photosCell", for: indexPath) as! PhotoCollectionCell
        let url = URL(string: media.thumbPath!)
        
        cell.thumbnail.kf.setImage(with: url!)
        cell.backgroundImage.kf.setImage(with: url!)
        
        
        cell.title.text = "\(media.title!.CapitaliseFirstLetterOfEveryWord()) Photos".capitalized
        
        cell.link = media.url!
        cell.eventTitle = media.title!
        
        return cell
    }
    
    //******************************************************
    //***************** Med Cell ***************************
    //******************************************************
    func medRecordCell(record: MedRecord, indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedItemCellWithText", for: indexPath) as! FeedItemCellTableViewCell
        cell.header.backgroundColor = Settings.RED_WEB_COLOR
        
        if (indexPath.row % 2 == 0){
            cell.backgroundColor = Settings.CELL_COLOR_1
            cell.header.text = record.entityFullName
        } else{
            cell.backgroundColor = Settings.CELL_COLOR_2
            cell.header.text = record.entityFullName
        }
        
        var detailsString = record.entityFullName ?? "Camper"
        if (record.dosageStatus == "Administered"){
            
            detailsString += " received \(record.dosageTimeOfDay!) medication"
            
        }else if(record.dosageStatus == "Checked-In"){
            detailsString += "'s medication has been checked-in."
        }
        
        cell.detailsTextView.text = detailsString
        cell.dateLabel.text = MyDateTime.getDayOfWeek(dateString: record.time!) + " " + MyDateTime.dateToPrettyString(timeString: record.time!)
        //cell.header.text = //record.entityFullName
        cell.iconImage.image = #imageLiteral(resourceName: "firstAid")
        cell.iconImage.image = (cell.iconImage.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate))
        cell.iconImage.tintColor = .white
        return cell
    }
    //******************************************************
    //************************** Post **********************
    //******************************************************
    func postCell(post: ScheduledPost,for indexPath: IndexPath) ->UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell",for: indexPath) as! PostTableViewCell
        cell.isUserInteractionEnabled = true
        var eventName = " "
        
        if let eventID = post.event_id, post.event_id != ""{
            
            eventName = itineraryIDToName[eventID] ?? ""
        }
        
        eventName = eventName.CapitaliseFirstLetterOfEveryWord()//.capitalized
        cell.setUp(post: post, eventName: eventName)
        return cell
        
    }
    //******************************************************
    //***************** Card Transaction *******************
    //******************************************************
    func cardTransactionCell(transaction: StoreCardTransaction, indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedItemCellWithText", for: indexPath) as! FeedItemCellTableViewCell
        cell.header.backgroundColor = UIColor(hex: 0x82BD7E, alpha: 1)
        
        
        if (indexPath.row % 2 == 0){
            cell.backgroundColor = Settings.CELL_COLOR_1
            
        } else{
            cell.backgroundColor = Settings.CELL_COLOR_2
        }
        
        cell.dateLabel.text = MyDateTime.getDayOfWeek(dateString: transaction.time!) + " " + MyDateTime.dateToPrettyString(timeString: transaction.time!, offsetHours: 0)
        
        if (transaction.transactionType == "Store Purchase"){
            cell.header.text = "\(transaction.name!) made a purchase"
            var detailsText = ""
            let purchasedItems = transaction.itemsPurchased as! Array<Dictionary<String, AnyObject>>
            for product in purchasedItems {
                let itemPrice = Double(product["price"] as! NSNumber) / Double(product["quantity"] as! NSNumber)
                
                detailsText += "\(product["quantity"] as! NSNumber) x \(product["description"] as! String ) for \(formatBalance(balance: itemPrice))\n"
                
            }
            detailsText += "For a total of \(transaction.totalCharged!) with tax"
            cell.detailsTextView.text = detailsText
        }// funds were added
        else if (transaction.transactionType == "Add Store Credit"){
            cell.header.text = transaction.name!
            cell.detailsTextView.text = "\(transaction.totalCharged!) was added to your camper's storecard."
            
        }// Donated remaining balance
        else if (transaction.transactionType == "Donate Remaining Credit"){
            cell.header.text = transaction.name!
            cell.detailsTextView.text = "\(transaction.totalCharged!) was donated from your camper's storecard."
        }// balance was reduced
        else if (transaction.transactionType == "Reduce Store Credit"){
            cell.header.text = transaction.name!
            cell.detailsTextView.text = "\(transaction.totalCharged!) was returned from your camper's storecard."
        }
        else if (transaction.transactionType == "Cancel Card"){
            cell.header.text = transaction.name!
            cell.detailsTextView.text = "\(transaction.totalCharged!) was returned from your camper's storecard."
        }
        
        cell.iconImage.image = #imageLiteral(resourceName: "storeCards")
        
        cell.iconImage.image = (cell.iconImage.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate))
        cell.iconImage.tintColor = .white
        
        return cell
    }
    //******************************************************
    //******************* Helper Methods *******************
    //******************************************************
    // not being used yet but sooon
    func hisOrHers(gender: String)-> String{
        switch gender {
        case "M":
            return "his"
        case "F":
            return "her"
        default:
            return "their"
        }
    }
    func personGender(entityID: String) throws -> [FamilyMember]?{
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request: NSFetchRequest<FamilyMember> = FamilyMember.fetchRequest()
        request.relationshipKeyPathsForPrefetching = ["toFamilyMember"]
        request.predicate = NSPredicate(format: "ANY entityID ==[c] %@",argumentArray: [entityID])
        return try context.fetch(request)
    }
    
    
    
    func handleRefresh(){
        
        if !isRefreshing && Reachability.isConnected(){
            isRefreshing = true
            
            HTTPRequestManager2.updateInfo(){
                (_ good: Bool) in
                if (good){
                    self.updateViews()

                }else{
                    HTTPRequestManager2.updateInfo(){
                        (_ good: Bool) in
                        if (!good){
                            self.noConnectionAlert(error: "Currently not able to update info at this time")
                        }
                        self.updateViews()

                    }
                }
                self.addLastUpdateTimeToRefreshControl()
            }
        }else if (!Reachability.isConnected()){
            
            noConnectionAlert(error: "It appears you are not connected to the internet")
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(60), execute: {
            self.tableView.refreshControl?.endRefreshing()
        })
    }
    
    func addLastUpdateTimeToRefreshControl(){
        var refreshString = ""
        if let updateTime = (UserDefaults.standard.object(forKey: "FeedLastUpdated") as? Date){
            
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
        refreshString += "Meds can take a few hours to update"
        self.refreshControl?.attributedTitle = NSAttributedString(string: refreshString)

    }
    
    func updateMedRecordData(){
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            let fetR:NSFetchRequest = MedRecord.fetchRequest()
            fetR.sortDescriptors = [NSSortDescriptor(key: "time", ascending: false)]
            self.medRecordData = try context.fetch(fetR)
        } catch{
           
        }
    }
    
    func updateStoreCardData(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            let fetR:NSFetchRequest = StoreCardTransaction.fetchRequest()
            fetR.sortDescriptors = [NSSortDescriptor(key: "time", ascending: false)]
            self.storeCardData = try context.fetch(fetR)
        } catch{
            
        }
    }
    
    func updateMediaLinkData(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            mediaLinkData = try context.fetch(FeedItem.fetchRequest())
            
        } catch{
            
        }
        
    }
    
    func updateScheduledPostsData(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            let fetR:NSFetchRequest = ScheduledPost.fetchRequest()
            fetR.sortDescriptors = [NSSortDescriptor(key: "time",ascending: false)]
            scheduledPosts = try context.fetch(fetR)
        } catch{
            
        }
    }
    
    func updateItineraryData(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            let itins : [Itinerary] = try context.fetch(Itinerary.fetchRequest())
            for itin in itins{
                itineraryIDToName[itin.eventID!] = itin.eventName
            }
        } catch{
            
        }
    }
    
    func noConnectionAlert(error: String){
        self.tableView.refreshControl?.endRefreshing()
        let alertController = UIAlertController(title: "UH-OH", message: error, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    func formatBalance(balance: Double) -> String{
        let number = NSDecimalNumber(value: balance) //(string: balance)//(decimal: balance)
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        
        return numberFormatter.string(from: number)!
    }
    

}
