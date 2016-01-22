//
//  STBasicViewController.swift
//  Javis
//
//  Created by 王志龙 on 16/1/20.
//  Copyright © 2016年 ele.me. All rights reserved.
//

import UIKit

class STBasicViewController: UIViewController {
  
  required init() {
    super.init(nibName: nil, bundle: nil)
    addLoginNotificationObserver()
  }
  
  required override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    addLoginNotificationObserver()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    addLoginNotificationObserver()
  }
  
  func addLoginNotificationObserver() {
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("handleTokenRefreshNotification"), name: STNotification.sharedNotification.NOTIFICATION_LOGIN, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("handleNeedLoginNotification"), name: STNotification.sharedNotification.NOTIFICATION_NEED_LOGIN, object: nil)
  }
  
  func handleTokenRefreshNotification() {
    if self.isViewLoaded() == false {
      
    }
    debugPrint("\(self) have receieved login notification")
    //additional method should override by controllers itself
  }
  
  func handleNeedLoginNotification() {
    debugPrint("\(self) have receieved need login notification")
  }
  
  //config navgationcontroller
  func setNavTitle(navTitle:String?) {
    self.navigationItem.title = navTitle
  }
  
  
}
