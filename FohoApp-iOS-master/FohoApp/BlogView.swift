//
//  BlogView.swift
//  FohoApp
//
//  Created by AaronR on 3/24/17.
//  Copyright © 2017 Aaron Renfroe. All rights reserved.
//

import UIKit
import Kingfisher

var MyObservationContext = 0

class BlogView: UIViewController {
    
    var observing = false
    var titleString = ""
    var dateString = ""
    var authorString = ""
    var bannerString = ""

    @IBOutlet weak var webViewHeight: NSLayoutConstraint!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var bannerImage: UIImageView!
    
    var authorImageUrl: String = ""
    var contentHtmlString : String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTitleImage()
        titleLabel.text = titleString
        
        authorLabel.text = authorString
        webView.scrollView.isScrollEnabled = false
        webView.delegate = self
        
        if authorImageUrl != "" {
            contentHtmlString = "<img align=\"left\" src=\"\(authorImageUrl)\" width=\"127\" style = \"margin-right: 20px\" loop=\"-1\">\(contentHtmlString)"
        }
        if bannerString != "" {
            bannerImage.kf.setImage(with: URL(string:bannerString), placeholder: #imageLiteral(resourceName: "landscape_banner2"))
        }else{
            bannerImage.image = #imageLiteral(resourceName: "landscape_banner2")
        }
        if authorString == "" {
            
            authorLabel.text  = dateString
            dateLabel.text = ""
        }
        //Where tableview is the IBOutlet for your storyboard tableview.
        webView.loadHTMLString(contentHtmlString, baseURL: nil)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        stopObservingHeight()
    }
    
    func startObservingHeight() {
        let options = NSKeyValueObservingOptions([.new])
        webView.scrollView.addObserver(self, forKeyPath: "contentSize", options: options, context: &MyObservationContext)
        observing = true;
    }
    
    func stopObservingHeight() {
        if observing {
            webView.scrollView.removeObserver(self, forKeyPath: "contentSize", context: &MyObservationContext)
            observing = false
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let keyPath = keyPath,
            let context = context else {
                super.observeValue(forKeyPath: nil, of: object, change: change, context: nil)
                return
        }
        switch (keyPath, context) {
        case("contentSize", &MyObservationContext):
            webViewHeight.constant = webView.scrollView.contentSize.height
        default:
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
        
    }
    
    func addTitleImage(){
        var size = 35
        if UIDevice.current.orientation.isLandscape && UIDevice.current.userInterfaceIdiom != .pad {
            size = 28
            
        }
        // else would be portrate
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        imageView.contentMode = .scaleAspectFit
        let image = #imageLiteral(resourceName: "logo_small-small")
        imageView.image = image
        imageView.tintColor = .white
        navigationItem.titleView = imageView
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        addTitleImage()
    }

}

extension BlogView: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        webViewHeight.constant = webView.scrollView.contentSize.height
        if (!observing) {
            startObservingHeight()
        }
    }
}
