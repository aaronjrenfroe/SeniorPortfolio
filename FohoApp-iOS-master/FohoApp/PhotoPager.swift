//
//  PhotoPager.swift
//  FohoApp
//
//  Created by AaronR on 5/11/17.
//  Copyright © 2017 Aaron Renfroe. All rights reserved.
//

import UIKit
import Flurry_iOS_SDK
import Photos

class PhotoPager: UIPageViewController {

    var photoURLS: [(mediumQuality:String, highQuality: String)] = []
    var currentIndex = 0

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        
        dataSource = self //as? UIPageViewControllerDataSource
        
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.hidesBarsOnTap = false
        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(self.saveImage(sender:))), animated: true)
        
        
        // Do any additional setup after loading the view.
        
        // 1
        if let viewController = viewPhotoDetailController(index: currentIndex) {
            let viewControllers = [viewController]
            // 2
            setViewControllers(viewControllers,
                               direction: .forward,
                               animated: false,
                               completion: nil)
        }
    }
    
    func viewPhotoDetailController(index: Int) -> DetailVC? {
        if let storyboard = storyboard,
            let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailVC {
            vc.urlString = photoURLS[index].highQuality
            vc.currentIndex = index
            vc.totalImages = photoURLS.count
            
            return vc
        }
        return nil
    }
    
    
    func saveImage(sender: UIBarButtonItem) {
        Flurry.logEvent("Saved An Image from camp")
        //DetailVC dVC = self.viewControllers![0]
        
        if let currentImage = (self.viewControllers!.first as! DetailVC).image.image {
            let activityViewController : UIActivityViewController = UIActivityViewController(
                activityItems: [currentImage], applicationActivities: nil)
            
            
            // Anything you want to exclude
            activityViewController.excludedActivityTypes = []
            if let presenter = activityViewController.popoverPresentationController {
                
                presenter.barButtonItem = sender
            }
            self.present(activityViewController, animated: true, completion: nil)
        }
        /*else{
            let waitAlert = UIAlertController(title: "Hold your Horses", message:"Can't open the sharing menu until the image has finished downloading. You can try again when the image appears.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            waitAlert.addAction(defaultAction)
            present(waitAlert, animated: true, completion: nil)
            
        }*/
    }
}


//MARK: implementation of UIPageViewControllerDataSource
extension PhotoPager: UIPageViewControllerDataSource {
    // 1
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let viewController = viewController as? DetailVC {
            var index = viewController.currentIndex
            guard index != NSNotFound && index != 0 else { return nil }
            index = index! - 1
            currentIndex = index!
            return viewPhotoDetailController(index: index!)
        }
        return nil
    }
    
    // 2
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let viewController = viewController as? DetailVC {
            var index = viewController.currentIndex
            guard index != NSNotFound else { return nil }
            index = index! + 1
            currentIndex = index!
            guard index != photoURLS.count else {return nil}
            return viewPhotoDetailController(index: index!)
        }
        return nil
    }
    
    
    // MARK: UIPageControl
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        // 1
        return photoURLS.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        // 2
        return currentIndex 
    }
    
    //func canRotate() -> Void {}
}
