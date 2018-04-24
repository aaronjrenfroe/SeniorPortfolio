//
//  loginEx.swift
//  FohoApp
//
//  Created by Aaron Renfroeon 12/16/16.
//  Copyright © 2016 Aaron Renfroe. All rights reserved.
//

import UIKit

extension Loginvc { // extention to Main Login View Controller
    
    // Authenticates User with CT Credentials
    func ct_Auth2(email: String, pass: String){
        HTTPRequestManager2.ct_Auth2(email: email, pass: pass){
            () in
            self.fetchMeds()
        }
    }
    

    func fetchMeds(){
        
        HTTPRequestManager2.fetchMeds(){
            () in
            self.succesfulLoginSegue()
        }
        HTTPRequestManager2.fetchStoreCards(){
            () in
            
        }
    }

    // called to get the events a camper is attending

    func isValidEmail(_ testStr:String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func emailNotValidAlert(){
        
        let alertController = UIAlertController(title: "UH-OH", message: "The email you entered does not look like a valid email", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "Try Again", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func loginCredNotCompleteAlert(){
        
        let alertController = UIAlertController(title: "UH-OH", message: "Username Or Password was left blank", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "Try Again", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func signInFailedAlert(message: String){
        ProgressView.shared.hideProgressView()
        let alertController = UIAlertController(title: "UH-OH", message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "Try Again", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func noConnectionAlert(error: String){
        DispatchQueue.main.async {
            
            if (!self.isSegueing){
                ProgressView.shared.hideProgressView()
                let alertController = UIAlertController(title: "UH-OH", message: error, preferredStyle: .alert)
            
                let defaultAction = UIAlertAction(title: "Try Again", style: .default, handler: nil)
                alertController.addAction(defaultAction)
            
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func connectionFailure(notification: NSNotification){
         DispatchQueue.main.async {
            if (!self.isSegueing){
                
                // viewController is visible
                ProgressView.shared.hideProgressView()
                let error = notification.object as! String
            
                let alertController = UIAlertController(title: "UH-OH", message: error, preferredStyle: .alert)
            
                let defaultAction = UIAlertAction(title: "Try Again", style: .default, handler: nil)
                alertController.addAction(defaultAction)
            
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func passwordTooShortAlert(){
        
        let alertController = UIAlertController(title: "UH-OH", message: "It looks like your password is too short", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "Try Again", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
