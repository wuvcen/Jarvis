//
//  STExtensions.swift
//  Javis
//
//  Created by 王志龙 on 16/1/22.
//  Copyright © 2016年 ele.me. All rights reserved.
//

import UIKit

extension UIImageView {
  func setCornerRadius(radius:CGFloat) {
    self.layer.cornerRadius = radius
    self.clipsToBounds = true
  }
  
  func setImageURL(url:String) {
    STImageLoader.loadImage(url, completionHanlder: {(image, error) -> Void in
      if image != nil {
        self.image = image
      }
      else {
        debugPrint("LoadImageError\(error?.description)")
      }
    })
  }
  
}

extension String {
   mutating func toLocalTimeString() {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
    let date = dateFormatter.dateFromString(self)
    dateFormatter.dateFormat = "yyyy-MM-dd"
    dateFormatter.timeZone = NSTimeZone.localTimeZone()
    self = dateFormatter.stringFromDate(date!)
  }
}
