//
//  StoreCardBalances.swift
//
//  The TableViewControler for StoreCardBalancesRemainingBalance
//
//  Created by AaronR on 1/21/17.
//  Copyright © 2017 Aaron Renfroe. All rights reserved.
//

import UIKit
import CoreData

class StoreCardBalances: UITableViewController {
    
    var storeCardData : [StoreCard] = []
    var isRefreshing = false
    
    @IBAction func backButton(_ sender: Any) {
        let transition = CATransition()
        transition.duration = 0.40
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionFromLeft
        view.window!.layer.add(transition, forKey: kCATransition)
        
        self.dismiss(animated: false, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.title = "Storecard Balances"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = (titleDict as! [String : Any])
        self.navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "NewNavBar2").resizableImage(withCapInsets: .zero, resizingMode: .stretch), for: .default)
        HTTPRequestManager2.getStoreCardBalance(completion: { () in
            self.storeCardsUpdated()
        })
        updatestoreCardData()
        
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: UIControlEvents.valueChanged)
        self.refreshControl? = refreshControl
        self.tableView.refreshControl?.backgroundColor = Settings.REFRESH_CONTROL_BACKGROUND
        self.tableView.tableFooterView = UIView()
        
    }
    
    func backbutton2(){
        self.dismiss(animated: true, completion: nil)
    }
    func storeCardsUpdated(){
        if (ProgressView.shared.isOn){
            ProgressView.shared.hideProgressView()
        }
        isRefreshing = false
        updatestoreCardData()
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        updatestoreCardData()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        var numOfSections: Int = 0
        if storeCardData.count > 0{
            tableView.separatorStyle = .singleLine
            numOfSections            = 1
            tableView.backgroundView = nil
        }
        else
        {
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "There don't seem to be any active \nStorecards on your account.\n Try adding one in CircuiTree\nor refresh by pulling down"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            noDataLabel.numberOfLines = 0
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        return numOfSections
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return storeCardData.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sc = storeCardData[indexPath.row]
        let regID = sc.registrationID
        
        if let itin = getItinData(regID: regID ?? "") {
            var transactions = getStoreCardData(itinId: itin.itineraryID!)
            if transactions.count > 0{
                for trans in transactions {
                    if trans.name != sc.firstName {
                        transactions.remove(at: transactions.index(of: trans)!)
                    }
                }
                // segue to details page
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "scTransViewController") as! SCTransactionTableViewController
                vc.storeCardData = transactions
                
                navigationController?.pushViewController(vc,
                                                         animated: true)
            }else{
                // display no transactions alert
                noTransactionsAlert()
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cardCell", for: indexPath)
        
        
        if (indexPath.row % 2 == 0){
            cell.backgroundColor = Settings.CELL_COLOR_1
            self.tableView.backgroundColor = Settings.CELL_COLOR_2
        } else{
            cell.backgroundColor = Settings.CELL_COLOR_2
            self.tableView.backgroundColor = Settings.CELL_COLOR_1
        }
        
        let nameLabel = cell.viewWithTag(1) as! UILabel
        let eventLabel = cell.viewWithTag(2) as! UILabel
        let stringLabel = cell.viewWithTag(3) as! UILabel
        let balanceLabel = cell.viewWithTag(4) as! UILabel
        let card = storeCardData[indexPath.row]
        
        let credits = Double(card.credits)
        let debits = Double(card.debits)
        
        nameLabel.text = card.firstName!
        eventLabel.text = card.event!
        if card.status != "Cancelled"{
            stringLabel.text = "Available Funds:"
            balanceLabel.text = formatBalance(balance: -1 * (credits+debits))
        }else{
           stringLabel.text = "Card is no longer Active"
            balanceLabel.text = ""
        }
        
        eventLabel.adjustsFontSizeToFitWidth = true
        return cell
        
    }
    
    
    func formatBalance(balance: Double) -> String{
        let number = NSDecimalNumber(value: balance) //(string: balance)//(decimal: balance)
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        
        return numberFormatter.string(from: number)!
    }
    
    
    func updatestoreCardData(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            let fetR:NSFetchRequest = StoreCard.fetchRequest()
            fetR.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            storeCardData = try context.fetch(fetR)
        } catch{
            
        }
    }
    
    func handleRefresh() {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from the server if they exist
        if !isRefreshing && Reachability.isConnected(){
            isRefreshing = true
            HTTPRequestManager2.getStoreCardBalance(){ ()in
                HTTPRequestManager2.fetchStoreCards(){ ()in
                    self.storeCardsUpdated()
                }
            }
            
        }else if (!Reachability.isConnected()){
            noConnectionAlert(error: "It appears you are not connected to the internet")
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: {
            self.tableView.refreshControl?.endRefreshing()
        })
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getStoreCardData(itinId : String) -> [StoreCardTransaction]{
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let empty : [StoreCardTransaction]?
        
        do {
            let fetR:NSFetchRequest = StoreCardTransaction.fetchRequest()
            fetR.predicate = NSPredicate(format: "itineraryID = %@",itinId)
            fetR.sortDescriptors = [NSSortDescriptor(key: "time", ascending: false)]
            
             empty =  try context.fetch(fetR)
            
        } catch{
            empty = []
        }
        
        return empty!
    }
    
    func getItinData( regID: String) -> Itinerary?{
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do { //itin
            
            let fetR:NSFetchRequest = Itinerary.fetchRequest()
            
            fetR.predicate = NSPredicate(format: "registrationID = %@", regID)
            
            let itin : [Itinerary] = try context.fetch(fetR)
            if itin.count > 0 {
                return itin[0]
            }
        } catch{
            
        }
        
        return nil
    }

    func noConnectionAlert(error: String){
        self.tableView.refreshControl?.endRefreshing()
        let alertController = UIAlertController(title: "UH-OH", message: error, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
        
    }
    
    func noTransactionsAlert(){
        self.tableView.refreshControl?.endRefreshing()
        let alertController = UIAlertController(title: "There are not any transactions to display for this card", message: "", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
        
    }
    


}
