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
    STNetWorkRequestData(path: "/user").startTask({[weak self] (json, error) -> Void in
      if error == nil && json != nil {
        STUserDefaults.setCurrentUser(json)
        self?.label.text = json?.objectForKey("login") as? String
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
