//
//  STMainViewController.swift
//  Javis
//
//  Created by 王志龙 on 16/1/20.
//  Copyright © 2016年 ele.me. All rights reserved.
//

import UIKit
import SafariServices

class STMainViewController: STBasicViewController, UITableViewDataSource, UITableViewDelegate{
  let reuseIdentifier = "event_cell"
  var currentPage = 1
  var eventsData:[AnyObject]? = nil
  var svc:SFSafariViewController?
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setNavTitle("Timeline")
    configSubviews()
  }
  
  func configSubviews() {
    self.tableView.registerNib(UINib(nibName: "STEventsCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
    self.tableView.dataSource = self
    self.tableView.delegate = self
    self.tableView.estimatedRowHeight = 100
    self.tableView.rowHeight = UITableViewAutomaticDimension
    self.tableView.addRefresh({ [weak self]() -> Void in
      self?.eventsData?.removeAll()
      self?.currentPage = 1
      self?.loadData((self?.currentPage)!)
    })
    
    self.tableView.addLoadMore({ [weak self]() -> Void in
      self?.loadMore({() -> Void in
        self?.tableView.makeLoadMoreNormal()
      })
    })
    
  }
  
  func loadData(page:Int) {
    self.loadData(page, completion: nil)
  }
  
  func loadData(page:Int, completion:actionBlock?) {
    let user = STUserDefaults.currentUser() as? [String : AnyObject]
    if user == nil || STUserDefaults.getAccessToken() == nil {
      return
    }
    let data = STNetWorkRequestData(path: "/users/\(user!["login"] as! String)/received_events?page=\(page)")
    data.startTask({(object, error) -> Void in
      if completion != nil {
        completion!()
      }
      if error == nil {
        if self.eventsData == nil {
          self.eventsData = object as? [AnyObject]
        }
        else {
          self.eventsData?.appendContentsOf(object as! [AnyObject])
        }
        self.tableView.reloadData()
        self.tableView.endRefresh()
      }
    })
  }
  
  func loadMore(completion:actionBlock?) {
    self.currentPage += 1
    self.loadData(self.currentPage, completion: completion)
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    STCurrentUser.singleTon.requestUser()
    if self.eventsData == nil {
      loadData(self.currentPage)
    }
  }
  
  override func handleNeedLoginNotification() {
    super.handleNeedLoginNotification()
    self.clearAllNotice()
    if self.svc == nil {
      self.svc = SFSafariViewController(URL: NSURL(string: STService.sharedService.AUTHORIZE_URL)!)
      self.presentViewController(svc!, animated: true, completion: nil)
    }
  }
  
  override func handleTokenRefreshNotification() {
    super.handleTokenRefreshNotification()
    self.svc!.dismissViewControllerAnimated(true, completion: nil)
    self.svc?.clearAllNotice()
    STCurrentUser.singleTon.requestUser()
  }
  
  override func handleNeedWaitNotificaiton() {
    super.handleNeedWaitNotificaiton()
    self.svc?.pleaseWait()
  }
  
  override func handleUserRefreshedNotification() {
    if self.view.window != nil {
      super.handleUserRefreshedNotification()
      self.clearAllNotice()
      self.loadData(self.currentPage)
    }
  }
  
  
  
  func handleUserRefreshed() {
    self.currentPage = 1
    self.loadData(self.currentPage)
  }
  
  //tableview data source
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as? STEventsCell
    cell?.setModel(self.eventsData![indexPath.row])
    return cell!
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if self.eventsData == nil {
      return 0
    }
    let events = self.eventsData!
    return events.count
  }
  
  
}
