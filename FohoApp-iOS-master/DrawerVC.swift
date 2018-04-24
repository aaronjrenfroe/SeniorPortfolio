//
//  DrawerVC.swift
//  FohoApp
//
//  Created by Aaron Renfroeon 12/19/16.
//  Copyright © 2016 Aaron Renfroe. All rights reserved.
//

import UIKit
import CoreData
import Kingfisher
import Flurry_iOS_SDK

class DrawerVC: UITableViewController {
    
    // array for menu options
    var arrayMenuOptions = [Dictionary<String,String>]()
    var weatherUpdateTime = Date()
    var BOTTOM = CGFloat()
    //let transition: CATransition = CATransition()
    
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    let MAX_RIGHT = Settings.DRAWER_WIDTH
    
    // sets up communication with another class
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HTTPRequestManager2.getWeather(url: Settings.WEATHER_URL_FOREST_FALLS, campus: Campus.FOREST_FALLS){
            self.weatherFetched()
        }
        
        let defaults = UserDefaults.standard
        nameLabel.text = ("Hi \(defaults.string(forKey: "firstName")!)")
        
        let appVersionString: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let buildNumber: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
        BOTTOM = UIScreen.main.bounds.height - 25
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                //iPhone 5 or 5S or 5C
                break
            case 1334:
                //iPhone 6/6S/7/8
                break
            case 2208:
                //iPhone 6+/6S+/7+/8+
                break
            case 2436:
               //iPhone X
                BOTTOM -= 65
                break
            default:
                break
            }
        }
        versionLabel.frame = CGRect(x: 10, y: BOTTOM, width: self.view.frame.width * 0.5, height: versionLabel.frame.height)
        
        versionLabel.text = "Forest Home Adventure Guide \(appVersionString).\(buildNumber)"
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 40
        self.tableView.backgroundColor = /*UIColor.black */ Settings.DRAWER_BACKGROUND_COLOR
        
        if #available(iOS 11.0, *) {
            let ei = self.tableView.contentInset
            print(ei)
            self.tableView.contentInset = UIEdgeInsets(top: -20.0, left: ei.left, bottom: ei.bottom, right: ei.right)
        } else {
            // Fallback on earlier versions
        }
        processWeather()
        self.addFooterView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        //versionLabel.frame = CGRect(x: 10, y: BOTTOM, width: self.view.frame.width * 0.5, height: versionLabel.frame.height)
        updateArrayMenuOptions()
        
        let ti:Double = weatherUpdateTime.timeIntervalSince(Date())
        if ((ti) < -120.0){
            HTTPRequestManager2.getWeather(url: Settings.WEATHER_URL_FOREST_FALLS, campus: Campus.FOREST_FALLS){
                self.weatherFetched()
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let BOTTOM = size.height
        versionLabel.frame = CGRect(x: 10, y: BOTTOM, width: self.view.frame.width * 0.5, height: versionLabel.frame.height)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
////        print(segue.destination)
////        if segue.identifier == "storeCardBalanceSegue" {
////            HTTPRequestManager2.getStoreCardBalance(){ ()in
////                dest.storeCardsUpdated()
////            }
////        }
//    }
    
    // Unwind Action
    @IBAction func unwindFromViewController(_ sender: UIStoryboardSegue) {
        
    }
    
    // loads buttons in to table view
    // to add a new button specify It's name and IconName here and make sure you handle its selection in buttonFunctions
    func updateArrayMenuOptions(){
        
        if arrayMenuOptions.count < 1 {
            //addButton(title: "Feed", icon:"house")
            //addButton(title: "Your Events", icon:"calendar")
            addButton(title: "Directions", icon:"Map")
            addButton(title: "Weather", icon:"weather")
            addButton(title: "Storecard Balances", icon:"storeCards")
            //addButton(title: "Rebook", icon:"rebook")
            addButton(title: "Give", icon:"giveIcon")
            addButton(title: "About Forest Home", icon:"information")
            addButton(title: "Countdown", icon: "clock_icon")
            addButton(title: "Sign Out", icon:"power")
            
        }
        self.tableView.reloadData()
    }
    
    
    // cellHeights
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 40
        
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! menuBtnCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.backgroundColor = UIColor.clear
        
        
        cell.title.text = arrayMenuOptions[indexPath.row]["title"]
        cell.iconImg.image =  UIImage(named: arrayMenuOptions[indexPath.row]["icon"]!)
        
        return cell
        
        //}
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = self.tableView.cellForRow(at: indexPath) as! menuBtnCell
        UIView.animate(withDuration: 0.2, animations:{
            
            cell.title.textColor = UIColor.lightGray
            
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200), execute: {
            UIView.animate(withDuration: 0.2, animations:{
                
                cell.title.textColor = UIColor.white
            })
        })
        
        buttonFunctions(buttonAtRow: indexPath.row)
        
        
    }
    
    func addButton(title: String, icon: String){
        arrayMenuOptions.append(["title":title, "icon":icon])
        
    }
    
    func buttonFunctions(buttonAtRow: Int){
        
        switch buttonAtRow+3{
        // Feed
        case 1 :
            break
            
        // Your Events
            
        case 2:
            break
            
        // Directions
        case 3:
            
            //This can be used to send camper to a specific location
            // by using geo co-ordinates
//            
//            let transition = CATransition()
//            transition.duration = 0.40
//            transition.type = kCATransitionMoveIn
//            transition.subtype = kCATransitionFromRight
//            view.window!.layer.add(transition, forKey: kCATransition)
//            
//            self.performSegue(withIdentifier: "directionsSegue", sender: nil)
            
            Flurry.logEvent("User_Pressed_Directions_in_drawer")
            let url = URL(string: "http://maps.apple.com/?daddr=40000,+Valley+of+the+Falls+Drive,+Forest+Falls,+California&dirflg=d&t=h")!
            
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            break
        // Weather
        case 4:
            
            
            let transition = CATransition()
            transition.duration = 0.40
            transition.type = kCATransitionMoveIn
            transition.subtype = kCATransitionFromRight
            view.window!.layer.add(transition, forKey: kCATransition)
            self.performSegue(withIdentifier: "weatherSegue", sender: nil)
            Flurry.logEvent("User_Checked_Weather")
            
            //let url = URL(string: "https://weather.com/weather/today/l/USCA0387:1:US")!
            //UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
            break
        // StoreCards
        case 5:
            
            let transition = CATransition()
            transition.duration = 0.40
            transition.type = kCATransitionMoveIn
            transition.subtype = kCATransitionFromRight
            view.window!.layer.add(transition, forKey: kCATransition)
            
            self.performSegue(withIdentifier: "storeCardBalanceSegue", sender: nil)
            
            
            break
            
//        case 4:
//            //Rebook
          
        case 6:

            Flurry.logEvent("User_Visited_Give_Page")
            //https://www.foresthome.org/donate/giving-opportunities/
            let url = URL(string: "https://www.foresthome.org/donate/giving-opportunities/")!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)

            break
            
        case 7:
            //About
            Flurry.logEvent("User_About_Page")
            //https://www.foresthome.org/about/
            let url = URL(string: "https://www.foresthome.org/about/")!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
            break
            
        case 8:
            //CountDown
            self.performSegue(withIdentifier: "toCDfromDrawer", sender: nil)
            break
            
            // 9
        default:
            
            // clear core data
            DispatchQueue.global(qos: .userInitiated).sync {

                self.deleteAllData(entity: "FamilyMember")
                self.deleteAllData(entity: "Itinerary")
                self.deleteAllData(entity: "MedRecord")
                self.deleteAllData(entity: "StoreCardTransaction")
                self.deleteAllData(entity: "StoreCard")
                self.deleteAllData(entity: "FeedItem")
                self.deleteAllData(entity: "ScheduledPost")
                let defaults = UserDefaults.standard
                
                defaults.set(false, forKey: "isAuthed")
                let appDomain = Bundle.main.bundleIdentifier!
                UserDefaults.standard.removePersistentDomain(forName: appDomain)
                HTTPRequestManager2.clean()
                let cache = ImageCache.default
                cache.clearMemoryCache()
                cache.clearDiskCache()
                
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "signOut", sender: nil)
                    //_ = navigationController?.popToRootViewControllerAnimated(true)
                }
            }
            
            Flurry.logEvent("User_Signed_Out")
            break
        }
        
    }
    // called from SignOut
    func deleteAllData(entity: String){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let fetch =  NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        request.resultType = .resultTypeCount
        
        do{
            try context.execute(request)

        } catch{
            Flurry.logEvent("Could not Delete: \(entity)")
        }
    }
    
    func addFooterView(){
        
        let footerView = UIView()
        footerView.backgroundColor = Settings.DRAWER_BACKGROUND_COLOR
        self.tableView.tableFooterView = footerView
        
        
        
    }
    
    func weatherFetched(){
        DispatchQueue.main.async {
            
            self.processWeather()
            self.weatherUpdateTime = Date()
            let defaults = UserDefaults.standard
            defaults.set(self.weatherUpdateTime, forKey: "weatherUpdateTime")
        }
    }
    
    func processWeather(){
        
        let defaults = UserDefaults.standard
        
        guard let weatherDict = defaults.dictionary(forKey: "weatherForestFalls") else{ return }
        
        guard let current = weatherDict["currently"] as? Dictionary<String, Any> else {return}
        guard let summary = current["summary"] as? String else{return}
        //guard let time = current["time"] as? NSNumber else {return}
        guard let temp = current["temperature"] as? NSNumber else {return}
        //guard let feelsLike = current["apparentTemperature"] as? NSNumber else {return}
        guard let icon = current["icon"] as? String else {return}
        //guard let percip = current["precipProbability"] as? NSNumber else {return}
        //let doublePercip = (percip as! Double) * 100.0
    
        
        tempLabel.text = "\(temp.intValue)\u{00B0}"
        weatherLabel.text = "\(summary)"
        let weatherY = nameLabel.frame.midY-(weatherLabel.frame.height/2)
        
        tempLabel.frame = CGRect(x: (MAX_RIGHT - tempLabel.frame.width)-15, y: weatherY-tempLabel.frame.height, width: tempLabel.frame.width, height: tempLabel.frame.height)
        
        weatherLabel.frame = CGRect(x: (MAX_RIGHT - weatherLabel.frame.width) - 5, y: weatherY, width: weatherLabel.frame.width, height: weatherLabel.frame.height)

        let frame = CGRect(x: tempLabel.frame.minX - 35, y: weatherLabel.frame.minY - 30, width: 30, height: 30)
        
        //check if icon exists
        let views = headerView.subviews
        var found = false
        for view in views{
            if let skyView = view as? SKYIconView{
                if let iconEnum = Skycons(rawValue: icon){
                    skyView.setType = iconEnum
                    found = true
                    break
                }
            }
        }
        if (!found){
    
            let iconView = SKYIconView(frame: frame)
            if let iconEnum = Skycons(rawValue: icon){
                iconView.setType = iconEnum
                iconView.setColor = UIColor.white
                iconView.backgroundColor = UIColor.clear
                headerView.addSubview(iconView)
                
                //iconView.pause() //To pause the animation when needed
            }
        }
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return arrayMenuOptions.count
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
