//
//  PhotoCollectionVC.swift
//  FohoApp
//
//  Created by AaronR on 3/5/17.
//  Copyright © 2017 Aaron Renfroe. All rights reserved.
//
// Collection View to display Gallaery of all flicker photos

import UIKit
import Foundation
import Kingfisher
import Flurry_iOS_SDK
import CoreData

private let reuseIdentifier = "Cell"

class PhotoCollectionVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    // set from previous view
    var viewTitle = String()
    var photoIDs: [String] = []
    var detailViewURL = String()
    var staticPhotoUrls: [(mediumQuality:String, highQuality: String)] = []
    // to set the detail view
    var indexOfSelectedPhoto = 0
    var thisPhotosetID = ""
    var originalLink: String?


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
//        let numberOfPhotosWide = (UIDevice.current.userInterfaceIdiom != .pad ? 3.0: 4.0) as CGFloat
//        
//        let width = (collectionView.frame.width/numberOfPhotosWide) - 1
//        //let width = (collectionView.frame.width/1) - 1
        let numberOfPhotosWide = floor(collectionView.bounds.width / 105.0)
    
        let width = (collectionView.frame.width/numberOfPhotosWide) - 1
        
        
        return CGSize(width:width, height:width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //ProgressView.shared.showProgressView(self.view)
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = (titleDict as! [String : Any])
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        // Dissabled Sharing Of Flicker Link
        // Privacy Concerns
        /*
         if let origLink = getOriginalLink(link: detailViewURL) as? String {
            originalLink = origLink
            self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(self.albumOptions(sender:))), animated: true)
        }
         */
        
        // Use Regesx to get ID from URL
        
        let pregex = "sets/[a-zA-z0-9]*"
        
        let id = matches(for: pregex, in: detailViewURL)
        
        if id.count != 0 {
            let setsPhotoSetID = id[0]
           
            let index = setsPhotoSetID.index(setsPhotoSetID.startIndex, offsetBy: 5)
            let photoSetID = setsPhotoSetID.substring(from: index)
            // Change this when We get the Flicker Credentials.
            // photo set ID for familycamp week 5 2016 used for testing sets with more than 500 photos.
            //photoSetID = "72157658508680979"
            thisPhotosetID = photoSetID
            fetchImageJSON(album:photoSetID, page: 1)
            // Register cell classes
            self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        

        // Do any additional setup after loading the view.
        }else{
            ProgressView.shared.hideProgressView()
            displayingPhotoIssues(error: "There are no photos to display")
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // disable the drawer menu indetail view becasue it is unexpected and there is a bug that prevent sthe navigation bar from reapearing
        if let drawerController = (navigationController?.parent) as? KYDrawerController {
            
            drawerController.screenEdgePanGestureEnabled = true
        }
        
        if (viewTitle.characters.count > 22)
        {
            
            if (viewTitle.contains("Family Camp"))
            {
                viewTitle = viewTitle.replacingOccurrences(of: "Family Camp", with: "FC")
            }
            else if (viewTitle.contains("Creekside"))
            {
                viewTitle = viewTitle.replacingOccurrences(of: "Creekside", with: "CS");
            }
            else if (viewTitle.contains("Adventure Mountain"))
            {
                viewTitle = viewTitle.replacingOccurrences(of: "Adventure Mountain", with: "AM");
            }
            else if (viewTitle.contains("The Village"))
            {
                viewTitle = viewTitle.replacingOccurrences(of: "The Village", with: "TV");
            }
            else if (viewTitle.contains("Village"))
            {
                viewTitle = viewTitle.replacingOccurrences(of: "Village", with: "TV");
            }
            else if (viewTitle.contains("Neighborhood Day Camp"))
            {
                viewTitle = viewTitle.replacingOccurrences(of: "Neighborhood Day Camp", with: "NDC");
            }
        }
 
        self.navigationItem.title = viewTitle
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "photoDetailViewSegue", let destination = segue.destination as? PhotoPager{
            print("Sending URL to destination \(detailViewURL)")
            
            destination.photoURLS = staticPhotoUrls
            destination.currentIndex = indexOfSelectedPhoto
            // re enable the drawer after detail view
            if let drawerController = (navigationController?.parent) as? KYDrawerController {
                
                drawerController.screenEdgePanGestureEnabled = false
                
            }
        
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        let cache = ImageCache.default
        cache.clearMemoryCache()
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return staticPhotoUrls.count
    }
    

    //*****************************************************************
    //************************ cellForItemAt ************************
    //*****************************************************************
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoViewCell
        
        cell.url = staticPhotoUrls[indexPath.row].highQuality
        cell.campImage.kf.setImage(with: URL(string: staticPhotoUrls[indexPath.row].mediumQuality), placeholder: #imageLiteral(resourceName: "emptyCellImage"), options: nil, progressBlock: nil, completionHandler: nil)
        // Configure the cell
    
        return cell
    }
    //*****************************************************************
    //************************ didSelectItemAt ************************
    //*****************************************************************
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? PhotoViewCell{
                
                detailViewURL = cell.url
                indexOfSelectedPhoto = indexPath.row
                performSegue(withIdentifier: "photoDetailViewSegue", sender: self)
            
        } else{
            
        }
    }

    
    func fetchImageJSON(album setID: String, page: Int8){
        let urlString = "https://api.flickr.com/services/rest/?method=flickr.photosets.getPhotos&api_key=f4b61f8c83c31971e8a9ccf91f5c38c3&user_id=54184317@N03&photoset_id=\(setID)&format=json&nojsoncallback=1&oauth_consumer_key=9b98601912942a4ea86c8e063d49485a&oauth_token=72157677783077924-9cf86ca021e041be&oauth_signature_method=HMAC-SHA1&oauth_timestamp=1491377282&oauth_nonce=y7nEMPvZzcW&oauth_version=1.0&oauth_signature=sJZgGCsjuApNXDhdtn0CtXs2+Jo=&user_nsid=54184317%40N03&username=Forest%20Home&page=\(page)"
        
        
            if let url = URL(string: urlString){
                
                
                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    
                    guard error == nil else {
                        
                        return
                    }
                    guard let data = data else {
                        
                        return
                    }
                    do{
                    if let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? Dictionary<String, AnyObject> {
                    
                        self.createImageURLS(json: json, url: (url.absoluteURL))
                    }else{
                        self.displayingPhotoIssues(error: "There Was an error fetching Images")
                    }
                        
                    }catch {
                        //
                        let articleParams = ["PhotoSet": setID, "page": page, "url": urlString] as [String : Any]
                        Flurry.logEvent("Bad_Flicker_URL", withParameters: articleParams);
                        self.displayingPhotoIssues(error: "There was an error fetching Images")
                    }
                
                    
                }
                
                task.resume()
            }else{
                let articleParams = ["PhotoSet": setID, "page": page, "url": urlString] as [String : Any]
                
                Flurry.logEvent("Bad_Flicker_URL", withParameters: articleParams);
                self.displayingPhotoIssues(error: "There Was an error fetching Images")
            }
        
    }
    // Dissabled Sharing Album Options for Privacy Concerns
    /*
    func albumOptions(sender: UIBarButtonItem){
            
        let actionSheet = UIAlertController(title: "\(viewTitle): Flickr Album", message: "", preferredStyle: .actionSheet)
        actionSheet.modalPresentationStyle = .popover
        
        let shareAction = UIAlertAction(title: "Share Photo Album", style: .default){ (action)-> Void in
                self.shareAlbum(link: self.originalLink ?? "", sender)
        }
        let cancelAction = UIAlertAction(title: "Done", style: .cancel){ (action) -> Void in
            
        }
        actionSheet.addAction(shareAction)
        actionSheet.addAction(cancelAction)
        if let presenter = actionSheet.popoverPresentationController {
            
            presenter.barButtonItem = sender
        }
        present(actionSheet, animated: true, completion: nil)
        
    }
 
    
    func shareAlbum(link: String, _ sender: UIBarButtonItem){
        Flurry.logEvent("Flicker Album was shared")
        
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [link], applicationActivities: nil)
        
        
        // Anything you want to exclude
        activityViewController.excludedActivityTypes = [
            .addToReadingList,
            .airDrop,
            .assignToContact,
            .openInIBooks,
            .postToFlickr,
            .postToVimeo ,
            .saveToCameraRoll,
            .postToFacebook,
            .postToTencentWeibo
        
        ]
        
        if let presenter = activityViewController.popoverPresentationController {
            
            presenter.barButtonItem = sender
        }
        
        self.present(activityViewController, animated: true, completion: nil)
    }
     */
    
    func getOriginalLink(link: String) -> String?{
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request: NSFetchRequest<FeedItem> = FeedItem.fetchRequest()
        do {
            let results = try context.fetch(request)

            for result in results {
                if result.url == link {
                    return result.originalUrl
                }
            }
        } catch {
           //Do nothing
        }
         return nil
    }
    
    func createImageURLS(json: Dictionary<String, AnyObject>, url: URL){
        
        guard json["stat"] as? String != "fail" else{
            
            let articleParams = ["url": url.absoluteString, "json": json.description]
            
            Flurry.logEvent("Flicker_Bad_URL", withParameters: articleParams);
            
            imageFetchingError(error:"createImageURLS(): Flickr fetch failed")

            return
        }
        guard let photoset = json["photoset"] as? Dictionary<String, AnyObject> else{
            
            let articleParams = ["url": url.absoluteString, "json": json.description]
            
            Flurry.logEvent("Flicker_PhotoSetWasNil", withParameters: articleParams);
            imageFetchingError(error:"createImageURLS():Photoseet was nil")
            return
        }
        guard let photos = photoset["photo"] as? Array<Dictionary<String, AnyObject>> else{
            
            let articleParams = ["url": url.absoluteString, "json": json.description]
            
            Flurry.logEvent("Flicker_PhotoSetWasEmpty", withParameters: articleParams);
            imageFetchingError(error: "there were no photos in photo set")
            return
        }
        
        for photo in photos {
            guard let farm = photo["farm"] as? Int32 else{
                continue
            }
            guard let server = photo["server"] as? String else{
                continue
            }
            guard let id = photo["id"] as? String else{
                continue
            }
            guard let secret = photo["secret"] as? String else{
                continue
            }
            
            //let mediumQ = "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_m.jpg" // 240 on longest side
            //let mediumQ = "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_n.jpg" // 320 on longest side
            let mediumQ = "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_q.jpg" // 100x100 on longest side
            //let mediumQ = "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_c.jpg" // 800 on longest side
            let highQ = "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_h.jpg" // 1600 on longest side
            
            staticPhotoUrls.append((mediumQuality:mediumQ, highQuality:highQ))
        }
        
        
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
        
        guard let pageString = photoset["page"] as? String else{
            imageFetchingError(error: "there were no photos in photo set")
            return
        }
        guard let pages = photoset["pages"] as? Int8 else{
            imageFetchingError(error: "there were no photos in photo set")
            return
        }
        
        if (Int8((pageString as NSString).integerValue) < pages) {
            DispatchQueue.global(qos: .userInitiated).sync {
                self.fetchImageJSON(album: thisPhotosetID, page: Int8((pageString as NSString).integerValue) + 1)
            }
        }

        
    }
    func matches(for regex: String, in text: String) -> [String] {
        
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let nsString = text as NSString
            let results = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
            return results.map { nsString.substring(with: $0.range)}
        } catch {
            
            return []
        }
    }
    
    func imageFetchingError(error message: String){
        ProgressView.shared.hideProgressView()
        
        let alertController = UIAlertController(title: "UH-OH", message: message, preferredStyle: .alert)
        
        
        let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: {
            action in
            // this returns a UINavigation controller.
            // _= tels the compiler I dont want to use it
            _ = self.navigationController?.popViewController(animated: true)
        })
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
        
        
    }
    
    func displayingPhotoIssues(error message: String){
        
        ProgressView.shared.hideProgressView()
        
        let alertController = UIAlertController(title: "UH-OH", message: message, preferredStyle: .alert)
        
        
        let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: {
            action in
            // this returns a UINavigation controller. 
            // _= tels the compiler I dont want to use it
            _ = self.navigationController?.popViewController(animated: true)
        })
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    func canRotate() -> Void {}

}
