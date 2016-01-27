//
//  STUser.swift
//  Javis
//
//  Created by 王志龙 on 16/1/27.
//  Copyright © 2016年 ele.me. All rights reserved.
//

import UIKit

enum STStatusCode:Int {
  case NoAccessToken = 404,AccessTokenInvalidate
}

class STCurrentUser: NSObject {
  
  var isLoading:Bool = false
  
  class var singleTon : STCurrentUser {
    struct Static {
      static let singleTon = STCurrentUser()
    }
    return Static.singleTon
  }
  
  ///in this singleton, if isloading, do not request, wait for notification
  // if not loading, request and load
  // if access token No or Invalid, post notification and need login
  func requestUser() -> Void {
    if self.isLoading == true {
      return
    }
    if STUserDefaults.currentUser() != nil {
      return
    }
    if STUserDefaults.getAccessToken() == nil {
      STNotification.postNotification(STNotification.sharedNotification.NOTIFICATION_NEED_LOGIN)
      return
    }
    self.isLoading = true
    STNetWorkRequestData(path: "/user").startTask({(user, error) -> Void in
      self.isLoading = false
      if error == nil && user != nil {
        if !STUserDefaults.validateUser(user!) {
          STNotification.postNotification(STNotification.sharedNotification.NOTIFICATION_NEED_LOGIN)
          return
        }
        STUserDefaults.setCurrentUser(user)
        STNotification.postNotification(STNotification.sharedNotification.NOTIFICATION_USER_REFRESHED)
      }else if error != nil {
        debugPrint(error?.description)
      }
    })
  }
  
}
