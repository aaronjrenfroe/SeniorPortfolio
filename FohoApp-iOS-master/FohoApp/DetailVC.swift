//
//  DetailVC.swift
//  FohoApp
//
//  Created by AaronR on 3/5/17.
//  Copyright © 2017 Aaron Renfroe. All rights reserved.
//

import UIKit
import Kingfisher

class DetailVC: UIViewController, UIScrollViewDelegate {
//TODO save Image
    
    var urlString: String!
    var image = UIImageView()
    var currentIndex: Int!
    var totalImages: Int!
    var loadingIndicator = UIActivityIndicatorView()
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.frame = view.frame
        
        loadingIndicator.frame = CGRect(x: (self.view.frame.maxX/2.0), y: (self.view.frame.maxY/2.0), width: 30.0, height: 30.0)
        
        view.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
        
        image.kf.setImage(with: URL(string: urlString), options: [.transition(.fade(0.2))]) {
            void in self.loadingIndicator.removeFromSuperview()
        }
        
        
        image.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        image.contentMode = .scaleAspectFit
        
        scrollView.addSubview(image)
        
        scrollView.delegate = self
        
        scrollView.minimumZoomScale = 0.80
        scrollView.maximumZoomScale = 3.0
        scrollView.zoomScale = 1.0
        
        setZoomScale()
        setupGestureRecognizer()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.parent?.navigationItem.title = "\(currentIndex! + 1) of \(totalImages!)"
    }
    
    override func viewWillLayoutSubviews() {
        setZoomScale()
    }
    
    func setupGestureRecognizer() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTap)
    }
    
    func handleDoubleTap(recognizer: UITapGestureRecognizer) {
        
        if (scrollView.zoomScale > scrollView.minimumZoomScale) {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        } else {
            scrollView.setZoomScale(scrollView.maximumZoomScale, animated: true)
        }
    }
    
    func viewForZooming(in: UIScrollView) -> UIView? {
        return image
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.hidesBarsOnTap = false
        
    }
    
 //Disabled DoubleTapToZoom becasue NavigationBar hidden on tap breaks it
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let imageViewSize = image.frame.size
        let scrollViewSize = scrollView.bounds.size
        
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        
        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
    }
    
    func setZoomScale() {
        let imageViewSize = image.bounds.size
        let scrollViewSize = scrollView.bounds.size
        let widthScale = scrollViewSize.width / imageViewSize.width
        let heightScale = scrollViewSize.height / imageViewSize.height
        scrollView.minimumZoomScale = min(widthScale, heightScale)
        scrollView.zoomScale = 0.8
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        let cache = ImageCache.default
        cache.clearMemoryCache()
        // Dispose of any resources that can be recreated.
    }
    //func canRotate() -> Void {}

}

