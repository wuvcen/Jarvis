//
//  STUserDefaults.swift
//  Javis
//
//  Created by 王志龙 on 16/1/21.
//  Copyright © 2016年 ele.me. All rights reserved.
//

import UIKit

class STUserDefaults: NSObject {
  
  static func UserDefaultForKey(key:String) -> AnyObject? {
    return NSUserDefaults.standardUserDefaults().objectForKey(key)
  }
  
  static func setUserDefaultForKey(key:String, object:AnyObject?) {
    NSUserDefaults.standardUserDefaults().setObject(object, forKey: key)
  }
  
  static func doesStringExsits(key:String) -> Bool {
    if UserDefaultForKey(key) != nil && UserDefaultForKey(key) as! String != "" {
      return true
    }
    return false
  }
  
  static func doesAccessTokenExsits() -> Bool {
    if getAccessToken() != nil && getAccessToken()! != "" {
      return true
    }
    return false
  }
  
  static func getAccessToken() -> String? {
    return UserDefaultForKey("access_token") as? String
  }
  
  static func setAccessToken(accessToken:String) {
    setUserDefaultForKey("access_token", object: accessToken)
  }
  
  static func currentUser() -> AnyObject? {
    if doesAccessTokenExsits() {
      let data =  UserDefaultForKey(getAccessToken()!) as! NSData
      return NSKeyedUnarchiver.unarchiveObjectWithData(data)
    }
    return nil
  }
  
  static func setCurrentUser(user:AnyObject?) {
    let data = NSKeyedArchiver.archivedDataWithRootObject(user!)
    setUserDefaultForKey(getAccessToken()!, object: data)
  }
  
}
