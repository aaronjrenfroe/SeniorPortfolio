//
//  TabBarController.swift
//  FohoApp
//
//  Created by Aaron Renfroeon 12/29/16.
//  Copyright © 2016 Aaron Renfroe. All rights reserved.
//

import UIKit
import QuartzCore

class TabBarController: UITabBarController {


    @IBOutlet weak var menuButtonBtn: UIBarButtonItem!
    
    @IBAction func menuButton(_ sender: Any) {
        
        if let drawerController = navigationController?.parent as? KYDrawerController {

            drawerController.setDrawerState(.opened, animated: true)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationController!.navigationBar.frame = CGRect(x:0,y:0,width:self.view.frame.width, height:80)

        //UINavigationBar.appearance().setBackgroundImage(UIImage(named: "image")!.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch), for: .default)
        addTitleImage()
        self.navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "NewNavBar2").resizableImage(withCapInsets: .zero, resizingMode: .stretch), for: .default)
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationItem.titleView?.tintColor = UIColor.white
        
        // unselected tint color
        self.tabBar.unselectedItemTintColor = UIColor.lightGray
        // selected Tint color
        self.tabBar.tintColor = UIColor(colorLiteralRed: 1, green: 1, blue: 1, alpha: 1)
        
        // Shadow
//        self.tabBar.layer.shadowColor = UIColor.black.cgColor
//        self.tabBar.layer.shadowOpacity = 1
//        self.tabBar.layer.shadowRadius = 5
//        self.tabBar.layer.shadowOffset = CGSize.zero
//        self.tabBar.layer.shadowPath = UIBezierPath(rect: self.tabBar.bounds).cgPath
        //self.tabBarItem
        
        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        addTitleImage()
    }
    
   func addTitleImage(){
        var size = 35
        if UIDevice.current.orientation.isLandscape && UIDevice.current.userInterfaceIdiom != .pad {
            size = 25
            // else would be portrate
        }
        // Getting Image
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: size))
        imageView.contentMode = .scaleAspectFit
        let image = #imageLiteral(resourceName: "logo_small-small")
        imageView.image = image
        imageView.tintColor = .white
        // Placing Image in a view so we can adjust it's frame
        let titleView = UIView(frame: CGRect(x:0, y:0, width:100, height:40))
        titleView.addSubview(imageView)
        // adding view
        navigationItem.titleView = titleView
    
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        //return the value as per the required orientation
        return UIInterfaceOrientationMask.portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
    }

}


