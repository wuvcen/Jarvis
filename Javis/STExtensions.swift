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
    
  }
  
}
