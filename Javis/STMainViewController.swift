//
//  STMainViewController.swift
//  Javis
//
//  Created by 王志龙 on 16/1/20.
//  Copyright © 2016年 ele.me. All rights reserved.
//

import UIKit
import SafariServices

class STMainViewController: STBasicViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setNavTitle("Timeline")
  }
  
  override func handleNeedLoginNotification() {
    super.handleNeedLoginNotification()
    UIApplication.sharedApplication().openURL(NSURL(string: STService.sharedService.AUTHORIZE_URL)!)
  }
  
  override func handleTokenRefreshNotification() {
    super.handleTokenRefreshNotification()
    
  }
  
}
