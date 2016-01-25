//
//  STImageLoader.swift
//  Javis
//
//  Created by 王志龙 on 16/1/22.
//  Copyright © 2016年 ele.me. All rights reserved.
//

import UIKit

class STImageLoader: NSObject {
  static func loadImage(url:String, completionHanlder:(UIImage?, NSError?) -> Void) {
    if let image = STFileManager.imageFromDocumentWithURL(url) {
      completionHanlder(image, nil)
    }
    else {
      let imageData = STNetWorkRequestData(path: nil)
      imageData.downloadImage(url, completionHandler: completionHanlder)
    }
  }
}
