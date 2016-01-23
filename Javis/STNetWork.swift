//
//  STNetWork.swift
//  Javis
//
//  Created by 王志龙 on 16/1/20.
//  Copyright © 2016年 ele.me. All rights reserved.
//

import UIKit

class STRequest: NSObject {
  static func request(url:String, params:[String : String]?, method:String) -> NSMutableURLRequest {
    let request = NSMutableURLRequest(URL: NSURL(string: url)!)
    request.HTTPMethod = method
    if method == "GET" {
      request.URL = NSURL(string: "\(url)?\(buildParams(params))")
    } else {
      let body = buildParams(params)
      if body != nil {
        request.HTTPBody = body!.dataUsingEncoding(NSUTF8StringEncoding)
      }
    }
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    if url != STService.sharedService.REFRESH_TOKEN_URL {
      request.setValue("token \(STUserDefaults.getAccessToken()!)", forHTTPHeaderField: "Authorization")
    }
    return request
  }
  
  static func request(imageURL:String) -> NSMutableURLRequest {
    let request = NSMutableURLRequest(URL: NSURL(string: imageURL)!)
    request.HTTPMethod = "GET"
    return request
  }
  
  static func buildParams(params:[String : String]?) -> String? {
    if params == nil {
      return nil
    }
    var array:Array<String> = []
    for (key , value) in params! {
      array += ["\(key)=\(value)"]
    }
    let outcome = array.joinWithSeparator("&")
    return outcome
  }
}

class STNetWork: NSObject {
  static func networkTask(request:NSURLRequest, completionHandler:(NSData?, NSURLResponse?, NSError?) -> Void) {
    let session = NSURLSession.sharedSession()
    let task = session.dataTaskWithRequest(request, completionHandler: completionHandler);
    task.resume()
    session.finishTasksAndInvalidate()
  }
  
}
