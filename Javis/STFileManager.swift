//
//  STFileManager.swift
//  Javis
//
//  Created by 王志龙 on 16/1/22.
//  Copyright © 2016年 ele.me. All rights reserved.
//

import UIKit

class STFileManager: NSObject {
  static func documentDirectory() -> String {
   return NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).first!
  }
  
  static func STFileManager() -> NSFileManager {
    return NSFileManager.defaultManager()
  }
  
  static func imagesDir() -> String {
    let path = documentDirectory().stringByAppendingString("/STImage")
    let _ = try? STFileManager().createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil)
    return path
  }
  
  static func doesFileExistsInDocument(imageURL:String) -> Bool {
    //image store in file with name of it's remote url
    let contents = try? STFileManager().contentsOfDirectoryAtPath(imagesDir()) as [String]
    if contents?.contains("\(imageURL).png") == true {
      return true
    }
    return false
  }
  
  static func imageFromDocumentWithURL(imageURL:String) -> UIImage? {
    if doesFileExistsInDocument(imageURL) {
      let data = NSData(contentsOfFile: "\(imageURL).png")
      let image = UIImage(data: data!)
      return image
    }
    return nil
  }
  
  static func writeToFileWithName(data:NSData, name:String) {
//    let success = data.writeToFile(, atomically: true)
    let success = STFileManager().createFileAtPath(imagesDir().stringByAppendingString("/\(name).png"), contents: data, attributes: nil)
    if success {
      debugPrint("写入成功")
    }
    else {
      debugPrint("写入失败\(imagesDir())")
    }
  }
  
}
