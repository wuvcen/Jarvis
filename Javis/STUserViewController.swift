//
//  STUserViewController.swift
//  Javis
//
//  Created by 王志龙 on 16/1/22.
//  Copyright © 2016年 ele.me. All rights reserved.
//

import UIKit
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
  
  convenience init(user:AnyObject?) {
    self.init(nibName: nil, bundle: nil)
    self.currentUser = user
  }

  override func viewDidLoad() {
    
    super.viewDidLoad()
    if self.currentUser == nil {
      loadUserIfNeeded()
    }
    setNavTitle("Profile")
  }
  
  func loadUserIfNeeded() {
    if STUserDefaults.doesAccessTokenExsits() {
      loadUser()
    }
  }
  
  func loadUser() {
    STNetWorkRequestData(path: "/user").startTask({[weak self] (user, error) -> Void in
      if error == nil && user != nil {
        self?.currentUser = user
        self?.avatar.setImageURL(user?.objectForKey("avatar_url") as! String)
        self?.avatar.setCornerRadius(4)
        self!.updateView()
      }else if error != nil {
        debugPrint(error?.description)
      }
    })
  }
  
  func updateView() {
    if self.currentUser == nil {
      return
    }
    self.userName.text = self.currentUser?.objectForKey("name") as? String
    self.userId.text = self.currentUser?.objectForKey("login") as? String
    self.location.text = self.currentUser?.objectForKey("location") as? String
    self.group.text = self.currentUser?.objectForKey("company") as? String
    self.blog.text = self.currentUser?.objectForKey("blog") as? String
    self.email.text = self.currentUser?.objectForKey("email") as? String
    var timestring = self.currentUser?.objectForKey("created_at") as! String
    timestring.toLocalTimeString()
    self.joinedTime.text = "joined at \(timestring)"
    
  }
  
  override func handleTokenRefreshNotification() {
    if self.isViewLoaded() {
      loadUser()
    }
  }
  
}
