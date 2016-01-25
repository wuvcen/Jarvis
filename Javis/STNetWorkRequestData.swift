//
//  STNetWorkRequestData.swift
//  Javis
//
//  Created by 王志龙 on 16/1/22.
//  Copyright © 2016年 ele.me. All rights reserved.
//

import UIKit
import SwiftyJSON
import Fuzi

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
  
  func downloadImage(url:String?, completionHandler:(UIImage?, NSError?) -> Void) {
    let reuqest = STRequest.request(url!)
    STNetWork.networkTask(reuqest, completionHandler: {(data, response, error) -> Void in
      if error == nil && data != nil {
        let image = UIImage(data: data!)
        dispatch_async(dispatch_get_main_queue(), {
          STFileManager.writeToFileWithName(data!, name: url!)
          completionHandler(image, nil)
        })
      }
      else {
        dispatch_async(dispatch_get_main_queue(), {
          completionHandler(nil, error)
        })
      }
    })
  }
  
}

class STUserSVG: NSObject {
  static func svgString(url:String, completionHandler:(String?) -> Void) {
    STNetWork.htmlFromURL(url, completionHandler: {data -> Void in
      let html = String(data: data!, encoding: NSUTF8StringEncoding)
      do {
        let doc = try HTMLDocument(string: html!, encoding: NSUTF8StringEncoding)
        let svg = doc.xpath("//*[@id='contributions-calendar']/div[1]/svg")
        completionHandler(svg.first?.rawXML)
      } catch let error {
        completionHandler(nil)
        debugPrint(error)
      }
      
    })
  }
}
