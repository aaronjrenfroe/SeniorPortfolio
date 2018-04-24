//
//  ViewController.swift
//  FohoApp
//
//  Created by Aaron Renfroe on 12/15/16.
//  Copyright © 2016 Aaron Renfroe. All rights reserved.
//

import UIKit
import CoreData
import Kingfisher
import Flurry_iOS_SDK

class Loginvc: UIViewController, UITextFieldDelegate { // LoginEx is in extention of this View Controller
    
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    var isSegueing = false
    
    var familyMembersData: [FamilyMember] = []
    var itineraryData: [Itinerary] = []
    var medRecordData : [MedRecord] = []
    
    @IBOutlet weak var curtain: UIView!
    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var loginButtnAsOut: UIButton!
    
    @IBAction func helpButton(_ sender: Any) {
        
        let alert = UIAlertController(title: "Login Information", message: "Use the Same credentials used to Access your account on our website.", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title:"Ok", style: .cancel)
        let resetAction = UIAlertAction(title: "Reset Password", style: .default){ action in
            let url = URL(string: "https://mycircuitree.com/ForestHome/ForgotPassword")!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        alert.addAction(okAction)
        alert.addAction(resetAction)
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    // login button pressed action
    @IBAction func loginBtn(_ sender: AnyObject) {
        dismissKeyboard()
        let email = emailField.text
        let password = passwordField.text
        
        if credinentialsAreValidFormat(email: email!, pass: password!){
            ProgressView.shared.showProgressView(self.view)
            ct_Auth2(email: email!, pass: password!)
        }
        
    }
    
    // need to add nsuser defaults to see if user has login in before
    //if so we should send them right to their feed
    override func viewDidLoad(){
        super.viewDidLoad()
        isSegueing = false
        // checks if user is signed in
        let defaults = UserDefaults.standard
        
        if defaults.bool(forKey: "isAuthed") == true, let _ = defaults.string(forKey: "entityID"),let _ = defaults.string(forKey: "apiToken"){
            
            DispatchQueue.main.async {
                    //self.dismiss(animated: true, completion: nil)
                self.performSegue(withIdentifier: "loginSuccess", sender: nil)
            }
            
            // if not signed in present signin screen
        }else{
            
            //let mainBackgroundColor = self.view.layer.backgroundColor?.
            // Do any additional setup after loading the view, typically from a nib.
            
            self.deleteAllData(entity: "FamilyMember")
            self.deleteAllData(entity: "Itinerary")
            self.deleteAllData(entity: "MedRecord")
            self.deleteAllData(entity: "StoreCardTransaction")
            self.deleteAllData(entity: "StoreCard")
            self.deleteAllData(entity: "FeedItem")
            self.deleteAllData(entity: "ScheduledPost")
            let defaults = UserDefaults.standard
            
            defaults.set(false, forKey: "isAuthed")
            let appDomain = Bundle.main.bundleIdentifier!
            UserDefaults.standard.removePersistentDomain(forName: appDomain)
            HTTPRequestManager2.clean()
            let cache = ImageCache.default
            cache.clearMemoryCache()
            cache.clearDiskCache()
            
            
            emailField.layer.cornerRadius = 5
            emailField.layer.borderWidth = 3
            emailField.layer.borderColor = UIColor.clear.cgColor
            emailField.autocorrectionType = .no
            
            //emailField.attributedText.c
            //emailField.drawText(in: <#T##CGRect#>)
            
            passwordField.layer.cornerRadius = 5
            passwordField.layer.borderWidth = 3
            passwordField.layer.borderColor = UIColor.clear.cgColor
            passwordField.autocorrectionType = .no
            
            emailField.returnKeyType = UIReturnKeyType.default
            emailField.keyboardType = UIKeyboardType.emailAddress
            
            passwordField.returnKeyType = UIReturnKeyType.done
            passwordField.clearsOnBeginEditing = true
            passwordField.isSecureTextEntry = true
            
            let tapGesture = UILongPressGestureRecognizer(target: self, action: #selector(Loginvc.pressedLogo))
            logoView.isUserInteractionEnabled = true
            logoView.addGestureRecognizer(tapGesture)
            
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(Loginvc.dismissKeyboard))
            view.addGestureRecognizer(tap)
            
            // listener for dataTask Completion
            
        }
    }
    
    func pressedLogo(){
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        //DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            // Put your code which should be executed with a delay here
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
           generator.selectionChanged()
            
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300), execute: {
            
            UIView.animate(withDuration: 0.5, delay: 0, options: [.autoreverse], animations: {
                self.logoView.alpha = 0
                self.logoView.transform = CGAffineTransform.init(scaleX: 40.0, y: 40.0)
                
            }, completion: { (finished: Bool) in
                
                let url = URL(string: "https://www.foresthome.org/")!
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
                    UIView.animate(withDuration: 0.2, animations:{
                        
                        self.logoView.alpha = 1
                        self.logoView.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
                    })
                })
            }
            )
        })

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let defaults = UserDefaults.standard
        
        if !defaults.bool(forKey: "isAuthed"){
            UIView.animate(withDuration: 0.3, animations: {() in
                self.curtain.backgroundColor = .clear
            }, completion: { (finished: Bool) in
                self.curtain.removeFromSuperview()
            })
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(connectionFailure), name: NSNotification.Name(rawValue: "LoginFailure"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(appDidWakeFromBackground), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterForground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
    }
    
    
    func appDidWakeFromBackground(){
        print("App DidAwakeFromBackground")

    }
    func appDidEnterForground(){
         print("AppDidEnterForground")
    }
    
    func succesfulLoginSegue(){
        
        NotificationCenter.default.removeObserver(name: NSNotification.Name(rawValue: "LoginFailure"))
        NotificationCenter.default.removeObserver(name: NSNotification.Name.UIApplicationWillEnterForeground)
        NotificationCenter.default.removeObserver(name: NSNotification.Name.UIApplicationDidBecomeActive)
        
        if !isSegueing{
            isSegueing = true
            DispatchQueue.main.async {
                UserDefaults.standard.set(Date(), forKey: "FeedLastUpdated")
                let appVersionString: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
                let buildNumber: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
                var params : [String: String] = [:]
                
                params["Entity ID"] = UserDefaults.standard.string(forKey: "entityID");
                params["Date"] = Date().description
                params["Version"] = appVersionString.appending("b").appending(buildNumber)
                params["Device"] = UIDevice.current.modelName
                Flurry.logEvent("Succesfull Login", withParameters: params)
                self.performSegue(withIdentifier: "loginSuccess", sender: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        NotificationCenter.default.removeObserver(self)
        if (segue.identifier == "loginSuccess") {

            DispatchQueue.main.async {
                print("leaving: from main thread")
                ProgressView.shared.hideProgressView()
                Flurry.logEvent("Succesfull Login");
            }
        }
        
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    // makes sure credentials are valid format
    func credinentialsAreValidFormat(email: String, pass: String)-> Bool{
        if (email != "" && pass != ""){ // If fields are not blank
            
            // if email is valid format and pass is long enough
            if(isValidEmail(email) && (pass.characters.count  >= 7)){
                
                return true
                
            } else{
                if (pass.characters.count < 7 && isValidEmail(email)){
                    passwordTooShortAlert()
                    return false
                }
                else{
                    emailNotValidAlert()
                    return false
                }
            }
        }else{
            // username or password was blank
            loginCredNotCompleteAlert()
            return false
        }
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if UIDevice.current.userInterfaceIdiom == .pad , UIDevice.current.orientation.isLandscape {
            
            scrollView.setContentOffset(CGPoint(x: 0, y: 100), animated: true)
            if self.logoView.tintColor != .clear {
                UIView.animate(withDuration: 0.2, animations: { () in
                    self.logoView.tintColor = Color.lightGray
                })
            }
        }
        
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            UIView.animate(withDuration: 0.2, animations: { () in
                self.logoView.tintColor = Color.white
            })
        }
        //scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)    
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        //view.endEditing(true)
        if (textField == emailField){
            passwordField.becomeFirstResponder()
        }
        else{
            
            textField.resignFirstResponder()
        }
        
        return true;
    }
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func deleteAllData(entity: String){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let fetch =  NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        request.resultType = .resultTypeCount
        do{
            let results = try context.execute(request)
            print("\(results.description)")
        } catch{
            print("could not delete")
        }
    }
    deinit{

    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait //return the value as per the required orientation
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    
}
