//
//  STNetWorkRequestData.swift
//  Javis
//
//  Created by 王志龙 on 16/1/22.
//  Copyright © 2016年 ele.me. All rights reserved.
//

import UIKit
import SwiftyJSON

class STNetWorkRequestData: NSObject {
  var pathPrefix = "https://api.github.com"
  var path:String? = nil
  
  required init(path:String?) {
    super.init()
    self.path = path
  }
  
  func startTask(completionHandler:(AnyObject?, NSError?) -> Void) {
    let reuqest = STRequest.request("\(self.pathPrefix)\(self.path!)", params: nil, method: "GET")
    STNetWork.networkTask(reuqest, completionHandler: {(data, response, error) -> Void in
      if error == nil && data != nil {
        //wtf SwiftyJSON can't parse github's json data?
        let data = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
        dispatch_async(dispatch_get_main_queue(), {
          completionHandler(data, nil)
        })
      }else {
        dispatch_async(dispatch_get_main_queue(), {
          completionHandler(nil, error)
        })
      }
    })
  }
  
}
