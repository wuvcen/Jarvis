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
  var svc:SFSafariViewController? = nil
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    STService.sharedService.loadToken()
    setNavTitle("Timeline")
    configSubviews()
  }
  
  func configSubviews() {
    self.tableView.registerNib(UINib(nibName: "STEventsCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
    self.tableView.dataSource = self
    self.tableView.delegate = self
  }
  
  func loadData() {
    let user = STUserDefaults.currentUser() as? [String : AnyObject]
    if user == nil {
      return
    }
    let data = STNetWorkRequestData(path: "/users/\(user!["login"] as! String)/received_events?page=\(self.currentPage)")
    data.startTask({(object, error) -> Void in
      if error == nil {
        self.currentPage++
        if self.eventsData == nil {
          self.eventsData = object as? [AnyObject]
        }
        self.tableView.reloadData()
      }
    })
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    if self.eventsData == nil {
      loadData()
    }
  }
  
  override func handleNeedLoginNotification() {
    super.handleNeedLoginNotification()
    if self.view.window != nil {
      self.svc = SFSafariViewController(URL: NSURL(string: STService.sharedService.AUTHORIZE_URL)!)
      self.presentViewController(svc!, animated: true, completion: nil)
    }
  }
  
  override func handleTokenRefreshNotification() {
    super.handleTokenRefreshNotification()
    self.svc?.dismissViewControllerAnimated(true, completion: nil)
    self.svc?.clearAllNotice()
  }
  
  override func handleNeedWaitNotificaiton() {
    super.handleNeedWaitNotificaiton()
    self.svc?.view.userInteractionEnabled = false
    self.svc?.pleaseWait()
  }
  
  func handleUserRefreshed() {
    self.currentPage = 1
    self.loadData()
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
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as? STEventsCell
    return (cell?.cellHeight())!
  }
  
}
