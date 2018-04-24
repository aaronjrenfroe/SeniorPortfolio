//
//  SCTransactionTableViewController.swift
//  FohoApp
//
//  Created by AaronR on 7/11/17.
//  Copyright © 2017 Aaron Renfroe. All rights reserved.
//

import UIKit
import CoreData

class SCTransactionTableViewController: UITableViewController {

    var storeCardData: [StoreCardTransaction]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if storeCardData == nil || storeCardData?.count == 0{
            noTransactionsAlert()
        }
        
        tableView.register(UINib(nibName: "SCTransactionTableViewCell", bundle: nil), forCellReuseIdentifier: "TransCell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 115
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationItem.titleView?.tintColor = UIColor.white
        navigationItem.title = "Transactions"
        
        //self.navigationController?.navigationItem.title = "Transactions"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (storeCardData ?? []).count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cardTransactionCell(transaction: (storeCardData?[indexPath.row])!, indexPath: indexPath)

        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return super.tableView(tableView, heightForRowAt: indexPath)
        
    }
    
    func cardTransactionCell(transaction: StoreCardTransaction, indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransCell", for: indexPath) as! SCTransactionTableViewCell
        cell.header.backgroundColor = UIColor(hex: 0x82BD7E, alpha: 1)
        cell.backgroundColor = Settings.CELL_COLOR_1
        
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
            cell.detailTextView.text = detailsText
        }// funds were added
        else if (transaction.transactionType == "Add Store Credit"){
            cell.header.text = (transaction.name ?? "Camper")
            cell.detailTextView.text = "\(transaction.totalCharged!) was added to your camper's storecard."
            
        }// Donated remaining balance
        else if (transaction.transactionType == "Donate Remaining Credit"){
            cell.header.text = (transaction.name ?? "Camper")
            cell.detailTextView.text = "\(transaction.totalCharged!) was donated from your camper's storecard."
        }// balance was reduced
        else if (transaction.transactionType == "Reduce Store Credit"){
            cell.header.text = (transaction.name ?? "Camper")
            cell.detailTextView.text = "\(transaction.totalCharged!) was returned from your camper's storecard."
        }
        else if (transaction.transactionType == "Cancel Card"){
            cell.header.text = (transaction.name ?? "Camper")
            cell.detailTextView.text = "\(transaction.totalCharged!) was returned from your camper's storecard."
        }
        
        cell.icon.image = #imageLiteral(resourceName: "storeCards")
        
        cell.icon.image = (cell.icon.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate))
        cell.icon.tintColor = .white
        
        return cell
    }
    
    func formatBalance(balance: Double) -> String{
        let number = NSDecimalNumber(value: balance) //(string: balance)//(decimal: balance)
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        
        return numberFormatter.string(from: number)!
    }


    func noTransactionsAlert(){
        self.tableView.refreshControl?.endRefreshing()
        let alertController = UIAlertController(title: "There are not any transactions to display for this card", message: "", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "Go Back", style: .destructive, handler: {
            (alert: UIAlertAction!) in
            self.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
        
    }

}
