//
//  STExtensions.swift
//  Javis
//
//  Created by 王志龙 on 16/1/22.
//  Copyright © 2016年 ele.me. All rights reserved.
//

import UIKit
import ObjectiveC
import PureLayout

extension UIImageView {
  
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

private var stAssociationKey: UInt8 = 0
extension UIView {
  var hud:UIActivityIndicatorView? {
    get {
      return objc_getAssociatedObject(self, &stAssociationKey) as? UIActivityIndicatorView
    }
    set(newValue) {
      objc_setAssociatedObject(self, &stAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
  
  //waste to much memory
  func ovalCover(sideWidth:CGFloat) {
    let path = UIBezierPath(ovalInRect: CGRectMake(0, 0, sideWidth, sideWidth))
    let mask = CAShapeLayer()
    mask.path = path.CGPath
    self.layer.mask = mask
  }
  func setCornerRadius(radius:CGFloat) {
    self.layer.cornerRadius = radius
    self.clipsToBounds = true
  }
  
  func showLoading() {
    if self.hud == nil {
      self.hud = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
      self.addSubview(self.hud!)
      self.hud?.autoCenterInSuperview()
    }
    if self.hud?.hidden == true {
      self.userInteractionEnabled = false
      self.hud?.startAnimating()
      self.hud?.hidden = false
    }
    
  }
  
  func dismissLoading() {
    if self.hud == nil {
      return
    }
    if self.hud?.hidden == false {
      self.userInteractionEnabled = true
      self.hud?.stopAnimating()
      self.hud?.hidden = true
    }
  }
}

typealias actionBlock = () -> Void
class ActionBlockWrapper : NSObject {
  var block : actionBlock
  init(block:actionBlock) {
    self.block = block
  }
}

private var stRefreshControlKey: UInt8 = 1
private var stRefreshActionBlockKey: UInt8 = 2
extension UITableView {
  var stRefreshControl:UIRefreshControl? {
    get {
      return objc_getAssociatedObject(self, &stRefreshControlKey) as? UIRefreshControl
    }
    set(newValue) {
      objc_setAssociatedObject(self, &stRefreshControlKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
  
//  var stLoadMoreView:
  
  func addRefresh(action:actionBlock) {
    if self.stRefreshControl != nil {
      if self.stRefreshControl?.superview != nil {
        self.stRefreshControl?.removeFromSuperview()
      }
      self.stRefreshControl = nil
    }
    if self.stRefreshControl == nil {
      self.stRefreshControl = UIRefreshControl()
      objc_setAssociatedObject(self, &stRefreshActionBlockKey, ActionBlockWrapper(block: action), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC) /// retains, must use weak self
      self.stRefreshControl?.addTarget(self, action: Selector("blockAction"), forControlEvents: UIControlEvents.ValueChanged)
      self.addSubview(self.stRefreshControl!)
    }
  }
  
  func blockAction() {
    let wrapper = objc_getAssociatedObject(self, &stRefreshActionBlockKey) as? ActionBlockWrapper
    wrapper?.block()
  }
  
  func endRefresh() {
    if self.stRefreshControl != nil {
      self.stRefreshControl?.endRefreshing()
    }
  }
  
  func addLoadMore(action:actionBlock) {
    if self.tableFooterView == nil {
      let footer = STTableFooterView(action: action)
      footer.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 50)
      self.tableFooterView = footer
    }
  }
  
  func makeLoadMoreNormal() {
    let footerView = self.tableFooterView as? STTableFooterView
    if footerView != nil {
      footerView?.showMoreButton()
    }
  }
}
