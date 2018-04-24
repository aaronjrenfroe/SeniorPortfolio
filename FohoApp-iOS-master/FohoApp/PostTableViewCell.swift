//
//  PostTableViewCell.swift
//  FohoApp
//
//  Created by AaronR on 4/14/17.
//  Copyright © 2017 Aaron Renfroe. All rights reserved.
//

import UIKit

enum PostType{
    case VIMEO
    case PDF
    case BLOG
    
}

class PostTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var ovalFade: UIImageView!
    
    @IBOutlet weak var title: UnderlineLabel!
    
    @IBOutlet weak var campCenterLogo: UIImageView!
    
    @IBOutlet weak var excerpt: UILabel!
    @IBOutlet weak var playImg: UIImageView!
    @IBOutlet weak var readMoreLabel: UILabel!
    @IBOutlet weak var titleBottomBar: UIView!
    
    @IBOutlet weak var blurImage: UIImageView!
    @IBOutlet weak var secondContentView: UIView!
    
    @IBOutlet weak var secondViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var PostTitleLabel: UILabel!
    var eventID: String?
    private var body : String?
    var state : PostType?
    var showDate : String?
    var imageURL : String?
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loadingIndicator.hidesWhenStopped = true
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            NSLayoutConstraint.deactivate([secondViewHeightConstraint])
            NSLayoutConstraint(item: secondContentView, attribute: .width, relatedBy: .equal, toItem: self.contentView, attribute: .width, multiplier: 0.75, constant: 0.0).isActive = true
        }else{
            backgroundColor = .white
            secondContentView.backgroundColor = .white
        }
        selectionStyle = .default
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected{
            loadingIndicator.startAnimating()
            loadingIndicator.isHidden = false
        }
        else{
            loadingIndicator.stopAnimating()
        }
    }
    
    
    func setUp(post: ScheduledPost, eventName: String = ""){
        setBody(body: post.body!)
        imageURL = post.thumbpath!
        eventID = post.event_id!
        backgroundImage.kf.setImage(with: URL(string: imageURL!), placeholder: #imageLiteral(resourceName: "Full_Cell_Empty_image"), completionHandler: {
            (image, error, cacheType, imageUrl) in
            // image: Image? `nil` means failed
            // error: NSError? non-`nil` means failed
            // cacheType: CacheType
            //                  .none - Just downloaded
            //                  .memory - Got from memory cache
            //                  .disk - Got from disk cache
            // imageUrl: URL of the image
            if error == nil {

                if ((image?.size.height)! / (image?.size.width)!) >= 0.5657 {
                    self.backgroundImage.contentMode = .scaleAspectFill
                }else{
                    self.backgroundImage.contentMode = .scaleAspectFit
                }
            }
        })
        
        blurImage.kf.setImage(with: URL(string: imageURL!), placeholder: #imageLiteral(resourceName: "Full_Cell_Empty_image"), options: [.transition(.fade(0.2))])
        if eventName != "" {
            PostTitleLabel.text = eventName
        }else{
            PostTitleLabel.text = post.title ?? ""
        }
        title.text = post.title ?? ""
        showDate = post.time ?? ""
        
        
        switch state!{
            // video cell
            case .VIMEO:
                excerpt.alpha = 0
                readMoreLabel.alpha = 0
                ovalFade.alpha = 0
                playImg.alpha = 1
                title.alpha = 0
                titleBottomBar.alpha = 0
                //playImg.tintColor = .white
                
                break
            // post cell
            default:
                excerpt.alpha = 1
                readMoreLabel.alpha = 1
                playImg.alpha = 0
                excerpt.text = post.excerpt!
                title.alpha = 1
                ovalFade.alpha = 1
                titleBottomBar.alpha = 1
                break
        }
        print(post.location_id)
        switch post.location_id!{
            
            case "6":
                campCenterLogo.image = #imageLiteral(resourceName: "TV-Logo-Post")
                break
            case "10":
                campCenterLogo.image = #imageLiteral(resourceName: "FC-Logo-Pos")
                break
            case "7":
                campCenterLogo.image = #imageLiteral(resourceName: "AM-Logo-Post")
                break
            case "9":
                campCenterLogo.image = #imageLiteral(resourceName: "LV-Logo-Post")
                break
            case "8":
                campCenterLogo.image = #imageLiteral(resourceName: "CS-Logo-Post")
            default:
                campCenterLogo.image = #imageLiteral(resourceName: "FH-Logo")
                break
        }
        
    }
    func setBody(body string: String){
        self.body = string
        let last4 = string.substring(from: string.index(string.endIndex, offsetBy: -4))
        if last4.lowercased() == ".pdf" {
            state = PostType.PDF
            
        }else if(string.lowercased().contains("vimeo.com")){
            state = PostType.VIMEO
        }else{
            state = PostType.BLOG
        }
    }
    
    func getBody() -> String{
        return body!
    }
    func getTitleText()-> String{
        return title.text!
    }
    func getDate() -> String{
        return showDate!
    }
    

}
