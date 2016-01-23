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
        let data = UIImageJPEGRepresentation(image!, 1.0)
        STFileManager.writeToFileWithName(data!, name: url)
      }
      else {
        debugPrint("LoadImageError\(error?.description)")
      }
    })
  }
  
}
