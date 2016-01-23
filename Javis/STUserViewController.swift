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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loadUserIfNeeded()
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
      }else if error != nil {
        debugPrint(error?.description)
      }
    })
  }
  
  override func handleTokenRefreshNotification() {
    if self.isViewLoaded() {
      loadUser()
    }
  }
  
}
