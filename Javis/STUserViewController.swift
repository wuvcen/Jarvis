//
//  STUserViewController.swift
//  Javis
//
//  Created by 王志龙 on 16/1/22.
//  Copyright © 2016年 ele.me. All rights reserved.
//

import UIKit
import SafariServices
import SwiftyJSON


class STUserViewController: STBasicViewController {
  
  var currentUser:AnyObject? = nil
  
  @IBOutlet weak var avatar: UIImageView!
  @IBOutlet weak var userId: UILabel!
  @IBOutlet weak var userName: UILabel!
  @IBOutlet weak var group: UILabel!
  @IBOutlet weak var location: UILabel!
  @IBOutlet weak var blog: UILabel!
  @IBOutlet weak var email: UILabel!
  @IBOutlet weak var joinedTime: UILabel!
  @IBOutlet weak var follower: UILabel!
  @IBOutlet weak var following: UILabel!
  @IBOutlet weak var contributionView: UIWebView!
  @IBOutlet weak var errorView: UIView!
  
  convenience init(user:AnyObject?) {
    self.init(nibName: nil, bundle: nil)
    self.currentUser = user
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.setLeftItems()
    self.configSubviews()
    if self.currentUser == nil {
      loadUserIfNeeded()
    }
    else {
      self.updateView()
    }
    
    setNavTitle("Profile")
  }
  
  func configSubviews() {
    self.follower.adjustsFontSizeToFitWidth = true
    self.following.adjustsFontSizeToFitWidth = true
    
    self.following.minimumScaleFactor = 0.5
    self.follower.minimumScaleFactor = 0.5
    
    self.contributionView.scrollView.alwaysBounceVertical = false
    self.contributionView.scrollView.alwaysBounceHorizontal = false
  }
  
  
  func loadUserIfNeeded() {
    if STUserDefaults.doesAccessTokenExsits() {
      loadUser()
    }
  }
  
  func loadUser() {
    self.pleaseWait()
    if STUserDefaults.currentUser() != nil {
      self.clearAllNotice()
      self.currentUser = STUserDefaults.currentUser()
      self.updateView()
    }
    else {
      STCurrentUser.singleTon.requestUser()
    }
  }
  
  func updateView() {
    if self.currentUser == nil {
      return
    }
    self.avatar.setImageURL(self.currentUser?.objectForKey("avatar_url") as! String)
    self.avatar.setCornerRadius(4)
    self.userName.text = self.currentUser?.objectForKey("name") as? String
    self.userId.text = self.currentUser?.objectForKey("login") as? String
    self.location.text = self.currentUser?.objectForKey("location") as? String
    self.group.text = self.currentUser?.objectForKey("company") as? String
    
    self.blog.text = self.currentUser?.objectForKey("blog") as? String
    self.blog.userInteractionEnabled = true
    self.blog.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("handleTapLink")))
    
    self.email.text = self.currentUser?.objectForKey("email") as? String
    var timestring = self.currentUser?.objectForKey("created_at") as! String
    timestring.toLocalTimeString()
    self.joinedTime.text = "joined at \(timestring)"
    self.follower.text = "\(self.currentUser?.objectForKey("followers") as! Int)"
    self.following.text = "\(self.currentUser?.objectForKey("following") as! Int)"
    
    self.contributionView.showLoading()
    STUserSVG.svgString("https://github.com/\(self.userId.text!)", completionHandler: {svg -> Void in
      self.contributionView.dismissLoading()
      if svg != nil {
        self.contributionView.loadHTMLString(svg!, baseURL: nil)
        self.errorView.hidden = true
      }
      else {
        self.errorView.hidden = false
      }
    })
  }
  
  override func handleTokenRefreshNotification() {
    if self.isViewLoaded() {
      loadUser()
    }
  }
  
  override func handleUserRefreshedNotification() {
    self.clearAllNotice()
    if self.isViewLoaded() {
      self.loadUser()
    }
  }
  
  
  func setLeftItems() {
    let fixedSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
    fixedSpace.width = 4
    let notification = UIButton(frame: CGRectMake(0,0,40,40))
    notification.setImage(UIImage(named: "icon_notification"), forState: UIControlState.Normal)
    notification.addTarget(self, action: Selector("handleNotification"), forControlEvents: UIControlEvents.TouchUpInside)
    let item = UIBarButtonItem(customView: notification)
    self.navigationItem.rightBarButtonItems = [item,fixedSpace]
  }
  
  func handleNotification() {
    
  }
  
  func handleTapLink() {
    let svc = SFSafariViewController(URL: NSURL(string: (self.blog.attributedText?.string)!)!)
    self.presentViewController(svc, animated: true, completion: nil)
  }
  
}
