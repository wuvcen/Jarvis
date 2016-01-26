//
//  STService.swift
//  Javis
//
//  Created by 王志龙 on 16/1/15.
//  Copyright © 2016年 ele.me. All rights reserved.
//

import UIKit
import SwiftyJSON

class STService: NSObject {
  let CLIENT_ID = "90c717280c265c4b5cc6"
  let CLIENT_SECRET = "85fe699610969206b82cb8d295ecf9aaed145c5f"
  let AUTHORIZE_URL = "https://github.com/login/oauth/authorize?client_id=90c717280c265c4b5cc6&scope=user,repo,notifications,gist"
  let REFRESH_TOKEN_URL = "https://github.com/login/oauth/access_token"
  let ACCESS_TOKEN_KEY = "access_token"
  
  var ACCESS_TOKEN = ""
  var ACCESS_CODE = ""
  
  class var sharedService : STService {
    struct Static {
      static let sharedservice = STService()
    }
    return Static.sharedservice
  }
  
  func loadToken() {
    if !STUserDefaults.doesAccessTokenExsits() {
      STNotification.postNotification(STNotification.sharedNotification.NOTIFICATION_NEED_LOGIN)
    }
  }
  
  func parseToken(url:NSURL) {
    let code = url.query
    let array = code?.componentsSeparatedByString("=")
    self.ACCESS_CODE = array![1]
    STNotification.postNotification(STNotification.sharedNotification.NOTIFICATION_WAIT)
    refreshToken()
  }
  
  func refreshToken() {
    let request = STRequest.request(self.REFRESH_TOKEN_URL, params: ["client_id":self.CLIENT_ID, "client_secret":self.CLIENT_SECRET, "code":self.ACCESS_CODE], method: "POST")
    STNetWork.networkTask(request, completionHandler: {(data, response, error) -> Void in
      if error == nil {
        let json = JSON(data: data!)
        self.ACCESS_TOKEN = json["access_token"].stringValue
        STUserDefaults.setAccessToken(self.ACCESS_TOKEN)
        STNotification.postNotification(STNotification.sharedNotification.NOTIFICATION_LOGIN)
      }else {
        debugPrint(error?.description)
      }
    })
  }
  
  
}
