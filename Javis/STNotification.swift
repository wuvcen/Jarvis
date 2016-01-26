//
//  STNotification.swift
//  Javis
//
//  Created by 王志龙 on 16/1/21.
//  Copyright © 2016年 ele.me. All rights reserved.
//

import UIKit

class STNotification: NSObject {
  let NOTIFICATION_LOGIN = "notification_login"
  let NOTIFICATION_NEED_LOGIN = "notification_need_login"
  let NOTIFICATION_WAIT = "notification_wait"
  let NOTIFICATION_USER_REFRESHED = "notification_user_refreshed"
  
  class var sharedNotification : STNotification {
    struct Static {
      static let sharedNotification = STNotification()
    }
    return Static.sharedNotification
  }
  
  static func postNotification(name:String) {
    NSNotificationCenter.defaultCenter().postNotificationName(name, object: nil)
  }
  
  static func postNotification(name:String, object:AnyObject?) {
    NSNotificationCenter.defaultCenter().postNotificationName(name, object: object)
  }
  
  static func postNSNotification(notification:NSNotification) {
    NSNotificationCenter.defaultCenter().postNotification(notification)
  }
  
}
