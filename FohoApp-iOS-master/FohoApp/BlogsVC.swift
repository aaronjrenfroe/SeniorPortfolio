//
//  BlogsVC.swift
//  FohoApp
//
//  Created by AaronR on 3/23/17.
//  Copyright © 2017 Aaron Renfroe. All rights reserved.
//

import UIKit
import Kingfisher
import Flurry_iOS_SDK

class BlogsVC: UITableViewController {
    
    var blogs: Array<Dictionary<String,String>> = []
    var selectedCellIndex = 0
    var PhotosForAuthor : Dictionary<String, String> = [:]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        blogs = UserDefaults.standard.object(forKey: "blogs") as! Array<Dictionary<String,String>>
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 310
        
        let adjustForTabbarInsets: UIEdgeInsets = UIEdgeInsetsMake(0, 0, (self.tabBarController!.tabBar.frame.height), 0);
        //Where tableview is the IBOutlet for your storyboard tableview.
        self.tableView.contentInset = adjustForTabbarInsets;
        self.tableView.scrollIndicatorInsets = adjustForTabbarInsets;
        Flurry.logEvent("Blogs_Did_Load");
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        fixPhotosForAuthor()
    }
    func fixPhotosForAuthor(){
        for blog in blogs {
            if blog["author_image"] != "" {
                PhotosForAuthor[blog["author"]!] = blog["author_image"]
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return blogs.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "blogCell", for: indexPath) as! BlogCell
        
        let blogDict = blogs[indexPath.row]
        
        cell.author.text = blogDict["author"]
        cell.date.text = blogDict["date"]
        cell.exceprt.text = blogDict["excerpt"]
        cell.title.text = blogDict["title"]
        if blogDict["author_image"] != "" && blogDict["author_image_type"] != "image/bob" {
            cell.authorImage.contentMode = .scaleAspectFill
            cell.authorImage.kf.setImage(with: URL(string: blogDict["author_image"]!))
        } else if (PhotosForAuthor[blogDict["author"]!] != nil) {
            cell.authorImage.contentMode = .scaleAspectFill
            cell.authorImage.kf.setImage(with: URL(string: PhotosForAuthor[blogDict["author"]!]!))
        }else{
            cell.authorImage.contentMode = .scaleAspectFit
            cell.authorImage.image = #imageLiteral(resourceName: "fc_bear")
        }
        // Configure the cell...

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        selectedCellIndex = indexPath.row
        performSegue(withIdentifier: "viewBlog", sender: self)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "viewBlog", let destinationVC = segue.destination as? BlogView {
            let blogDict = blogs[selectedCellIndex]
            
            destinationVC.dateString = blogDict["date"]!
            destinationVC.authorString = blogDict["author"]!
            destinationVC.titleString = blogDict["title"]!
            
            destinationVC.authorImageUrl = (blogDict["author_image"]! == "") ? (PhotosForAuthor[blogDict["author"]!] == nil ? "" : PhotosForAuthor[blogDict["author"]!])! : blogDict["author_image"]!
            destinationVC.bannerString = blogDict["banner"]!
            destinationVC.contentHtmlString = blogDict["content"]!
            
            
        }
    }
    


}
