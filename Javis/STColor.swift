//
//  STColor.swift
//  Javis
//
//  Created by 王志龙 on 16/1/22.
//  Copyright © 2016年 ele.me. All rights reserved.
//

import UIKit

class STColor: NSObject {
  ///main interface
  static func strawBerryColor() -> UIColor {
    return RGBColor(255.0, g: 0, b: 128.0)
  }
  ///using RGB
  static func RGBColor(r:CGFloat, g:CGFloat, b:CGFloat) -> UIColor {
    return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
  }
}
