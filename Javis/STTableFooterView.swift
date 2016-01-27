//
//  STTableFooterView.swift
//  Javis
//
//  Created by 王志龙 on 16/1/27.
//  Copyright © 2016年 ele.me. All rights reserved.
//

import UIKit
import PureLayout

class STTableFooterView: UIView {
  var action:actionBlock?
  var button:UIButton?
  
  convenience init(action:actionBlock) {
    self.init()
    self.action = action
    configSubviews()
  }
  
  func configSubviews() {
    self.button = UIButton(type: UIButtonType.System)
    self.button!.setTitle("More", forState: UIControlState.Normal)
    self.button!.addTarget(self, action: Selector("blockAction"), forControlEvents: UIControlEvents.TouchUpInside)
    self.addSubview(self.button!)
    self.button!.autoCenterInSuperview()
  }
  
  func blockAction() {
    if self.action != nil {
      self.action!()
      self.button?.hidden = true
      self.showLoading()
    }
  }
  
  func showMoreButton() {
    self.dismissLoading()
    self.button?.hidden = false
  }

}
