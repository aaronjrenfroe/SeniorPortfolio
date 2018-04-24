//
//  CountDownController.swift
//  FohoApp
//
//  Created by AaronR on 3/2/17.
//  Copyright © 2017 Aaron Renfroe. All rights reserved.
//

import UIKit
import CoreData
import Social
//import AVKit
//import AVFoundation
import Splitflap

/* This view displays a countdown to the next registration as well as:
 providing an good oportunity for the phone to make requests to fetch
 updates from the server. If the continue button is pressed before all 
 responses have been recieved a Activity Indicator will appear until finished.
 
*/

class CountDownController: UIViewController, SplitflapDelegate, SplitflapDataSource {

    var familyMembersData : [FamilyMember] = []
    var itineraryData : [Itinerary] = []
    var myTimer: Timer = Timer()
    var blogsHaveReturned = false
    var postsHaveReturned = false
    var mediaHaveReturned = false
    var canContinue = false
    //var player: AVPlayer?
    var modelName: String = ""
    
    
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var eventNameLabel: UILabel!
    
    @IBOutlet weak var daysFlap: Splitflap!
    @IBOutlet weak var hoursFlap: Splitflap!
    @IBOutlet weak var minutesFlap: Splitflap!
    @IBOutlet weak var secondsFlap: Splitflap!
    
    @IBAction func shareButtonAction(_ sender: Any) {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
            if let fbShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook){
               
                // I originally had a Preset message but autofill violates FB's TOS and is no longer functional
                let url = NSURL(string: "https://www.foresthome.org/events/")! as URL
                fbShare.add(url)
                self.present(fbShare, animated: true, completion: nil)
            }
            
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        shareButton.imageView?.tintColor = UIColor.white
    }
        
    @IBAction func continueAction(_ sender: Any) {
        //continueFromCountdown
        // Spoofing what this would look like if user pressed this befor responses were received
        
        activityIndicator.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000), execute: {
            self.activityIndicator.stopAnimating()
            self.performSegue(withIdentifier: "continueFromCountdown", sender: nil)
            
        })
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // gets model name to calculate size of flip clock
        modelName = UIDevice.current.modelName
        
        activityIndicator.hidesWhenStopped = true;
        shareButton.imageView?.tintColor = UIColor.white
        
        DispatchQueue.global(qos: .userInteractive).sync {
            
            HTTPRequestManager2.getMonthlyBlogs(){ () in
                self.doneFetchingBlogs()
            }
            HTTPRequestManager2.fetchScheduledPosts(){ () in
                self.doneFetchingPosts()
            }
            
        }
        HTTPRequestManager2.getStoreCardBalance(completion: {() in })
        continueButton.setTitle("Continue", for: .normal)
        continueButton.setTitle("Please Wait", for: .disabled)
        // check if blogs exist already on disk
        // if not we need to wait for them to be updated
        if (UserDefaults.standard.object(forKey: "blogs") as? Array<Dictionary<String, String>>) != nil{
            blogsHaveReturned = true
            canContinue = true
        }else{
            continueButton.isEnabled = false
            
            self.activityIndicator.startAnimating()
        }
//      if let path = Bundle.main.path(forResource: "16FH WebBanner 8", ofType:"mp4") {
    //        player = AVPlayer(url: URL(fileURLWithPath: path))
    //        player?.actionAtItemEnd = .none
    //        let playerLayer = AVPlayerLayer(player: player)
    //        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
    //        playerLayer.zPosition = -1
    //        playerLayer.frame = view.frame
    //        view.layer.addSublayer(playerLayer)
    //        
    //        NotificationCenter.default.addObserver(self, selector: #selector(loopVideo), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,object: nil)
//      }
    
        daysFlap.datasource = self
        hoursFlap.datasource = self
        minutesFlap.datasource = self
        secondsFlap.datasource = self
        
        daysFlap.delegate = self
        hoursFlap.delegate = self
        minutesFlap.delegate = self
        secondsFlap.delegate = self

        daysFlap.reload()
        hoursFlap.reload()
        minutesFlap.reload()
        secondsFlap.reload()
        
        

    }
    
//    func loopVideo() {
//        player?.seek(to: kCMTimeZero)
//        player?.play()
//    }
    override func viewDidAppear(_ animated: Bool) {
        
        
        
        updateItineraryData()
        updateFamilyMembersData()
        fetchMedia()
        // TODO: Fetch Photos, videos, and blogs.
        updateCountDown()

        // update labels
        updateCountDown()
        startCountdown()
        //player?.play()
    }
    
    func fetchMedia(){
        HTTPRequestManager2.fetchMediaLinks(){ () in
            self.mediaHaveReturned = true
        }
        
    }

    func doneFetchingBlogs(){

        blogsHaveReturned = true

    }
    func doneFetchingPosts(){

        postsHaveReturned = true

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        myTimer.invalidate()
        NotificationCenter.default.removeObserver(self)
        
    }
    
    // called every second
    func updateCountDown(){
        if let nextItinerary = getNextEvent(){
            let names = getNamesForEvent(event: nextItinerary)
            
            //let adjustedDate = Calendar.current.date(byAdding: .hour, value: 7, to: MyDateTime.stringToDate(string: nextItinerary.beginDateTime!))!
            
            if (nextItinerary.beginDateTime! >= MyDateTime.NowPDT()){
            
                let components = getDHMS(nextEvent: nextItinerary)
                
                eventNameLabel.text = "\(names) attending\n\(String(describing: nextItinerary.eventName!))"
                
                daysFlap.setText(String(format: "%0.3d",components.days), animated: true)
                hoursFlap.setText(String(format: "%0.2d",components.hours), animated: true)
                minutesFlap.setText(String(format: "%0.2d",components.minutes), animated: true)
                secondsFlap.setText(String(format: "%0.2d",components.seconds), animated: true)
                
            }else{
                eventNameLabel.text = "Check out our upcoming events \nand get this clock moving."
                daysFlap.setText(("000"), animated: true)
                hoursFlap.setText(("00"), animated: true)
                minutesFlap.setText(("00"), animated: true)
                secondsFlap.setText(("00"), animated: true)

            }
        }else{
            eventNameLabel.text = "Check out our upcoming events \nand get this clock moving"

            daysFlap.setText(("000"), animated: true)
            hoursFlap.setText(("00"), animated: true)
            minutesFlap.setText(("00"), animated: true)
            secondsFlap.setText(("00"), animated: true)


        }
        
        // checks if blogs have returned
        if blogsHaveReturned , !canContinue{
            canContinue = true
            continueButton.isEnabled = true
            self.activityIndicator.stopAnimating()
        }
        
    }

    func startCountdown(){
        
        myTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCountDown), userInfo: nil, repeats: true)
        
    }
    
    func getNextEvent()->Itinerary?{
        
        
        if itineraryData.count > 0{
            var next: Itinerary = itineraryData[0]
            
            for itin in itineraryData{
                
                if itin.beginDateTime! > MyDateTime.NowPDT() && itin.beginDateTime! < (next.beginDateTime)!{
                    next = itin
                }
            
            }
            
            return next
        }
        return nil
    }
    
    func getDHMS(nextEvent: Itinerary)->(days: Int, hours: Int, minutes:Int, seconds: Int){
        
        let countDownDate = MyDateTime.stringToDate(string: nextEvent.beginDateTime!)
        // shifting from UTC to pacific
        var offset = -28800.0
        // accounting for daylight savings
        if (TimeZone(identifier: "America/Los_Angeles")?.isDaylightSavingTime())! {
            offset += 3600
        }
        
        let timeInterval = countDownDate.timeIntervalSinceNow.distance(to: Double(offset))
        
        let counter = Int(timeInterval) * -1
        
        let seconds = counter % 60
        let minutes = (counter / 60) % 60
        let hours = ((counter % 86400) / 3600)
        let days = (counter/86400)
        return (days,hours,minutes,seconds)
    }
    
    
    /**
    *********** CoreData Fetching ***********
    **/
    func fetchPerson(familyMemberID: String) -> String{
        for f in familyMembersData{
            if (f.entityID == familyMemberID){
                return f.firstName!
            }
        }
        return ""
    }
    
    
    func updateItineraryData(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            let fetR:NSFetchRequest = Itinerary.fetchRequest()
            
            
            fetR.predicate = NSPredicate(format: "beginDateTime > %@", MyDateTime.NowPDT())
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
    //
    
    // MARK: - Splitflap DataSource Methods
    
    func numberOfFlapsInSplitflap(_ splitflap: Splitflap) -> Int {
        if (splitflap.tag == 1){ return 3 } else if (splitflap.tag == 2) { return 11 } else { return 2 }
    }
    
    func tokensInSplitflap(_ splitflap: Splitflap) -> [String] {
        return "9876543210".characters.map{ String($0)}
    }
    
    // MARK: - Splitflap Delegate Methods
    
    func splitflap(_ splitflap: Splitflap, rotationDurationForFlapAtIndex index: Int) -> Double {
        return 0.25
    }
    
    func splitflap(_ splitflap: Splitflap, builderForFlapAtIndex index: Int) -> FlapViewBuilder {
        switch modelName {
        case "iPhone5,1", "iPhone5,2", "iPhone5,3", "iPhone5,4","iPhone6,1", "iPhone6,2","iPhone8,4":
            return FlapViewBuilder { builder in
                builder.backgroundColor = UIColor.white.withAlphaComponent(0.9)
                builder.cornerRadius    = 1
                builder.font            = UIFont(name: "Avenir Next", size: 30)
                builder.textAlignment   = .center
                builder.textColor       = .black
                builder.lineColor       = .darkGray
            }
            
        default:
            return FlapViewBuilder { builder in
                builder.backgroundColor = UIColor.white.withAlphaComponent(0.9)
                builder.cornerRadius    = 2
                builder.font            = UIFont(name: "Avenir-Black", size: 45)
                builder.textAlignment   = .center
                builder.textColor       = .black
                builder.lineColor       = .darkGray
            }
        }
    }
    
    
    
    /**
     ************* EndCoreData Fetching ***********
     **/
    
    func connectionFailure(notification: NSNotification){

        
        let error = notification.object as! String
        
        let alertController = UIAlertController(title: "We tried to update some information but it appears something went wrong", message: error, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(defaultAction)

        
        present(alertController, animated: true, completion: nil)
    }
    
    func noConnectionAlert(error: String){
        
        let alertController = UIAlertController(title: "It appears you don't have a good connection to the internet. Some features of this app will be limited until a better connection is established.", message: error, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    func getNamesForEvent(event: Itinerary)-> String{
        var names: [String] = []
        
        for itin in itineraryData {
            if itin.eventID == event.eventID {
                names.append(fetchPerson(familyMemberID: itin.entityID!))
                
            }
        }
        
        var nameString = ""
        if (names.count == 2){
            nameString.append(names[1])
            nameString.append(" and ")
            nameString.append(names[0])
            nameString.append(" are")
        }else if(names.count > 2) {
            nameString = "\(names[names.count-1]) and \(names.count - 1) others are"
        }else if (names.count == 1){
            nameString.append(names[0])
            nameString.append(" is")
        }else{
            nameString = "A camper is"
        }
        
        return nameString
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait //return the value as per the required orientation
    }
    
    override var shouldAutorotate: Bool {
        return false
    }

}
