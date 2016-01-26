//
//  AppDelegate.swift
//  Javis
//
//  Created by 王志龙 on 16/1/15.
//  Copyright © 2016年 ele.me. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
    loadTabs()
    self.window?.makeKeyAndVisible()
    return true
  }
  
  func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
    if sourceApplication == "com.apple.SafariViewService" || sourceApplication == "com.apple.mobilesafari" {
      STService.sharedService.parseToken(url)
      return true
    }
    return false
  }
  
  func loadTabs() {
    let tabController = UITabBarController()
    let mainNav = UINavigationController(rootViewController: STMainViewController(nibName: "STMainViewController", bundle: nil))
    mainNav.tabBarItem.title = "Timeline"
    mainNav.tabBarItem.image = UIImage(named: "icon_timeline")
    let userNav = UINavigationController(rootViewController: STUserViewController(nibName: "STUserViewController", bundle: nil))
    userNav.tabBarItem.title = "Profile"
    userNav.tabBarItem.image = UIImage(named: "icon_user")
    tabController.setViewControllers([mainNav, userNav], animated: true)
    
//    tabController.tabBar.tintColor = STColor.strawBerryColor()
    self.window?.rootViewController = tabController
  }
  
}

