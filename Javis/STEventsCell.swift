//
//  STEventsCell.swift
//  Javis
//
//  Created by 王志龙 on 16/1/26.
//  Copyright © 2016年 ele.me. All rights reserved.
//

import UIKit
import Kingfisher

class STEventsCell: UITableViewCell {
  @IBOutlet weak var avatar: UIButton!
  @IBOutlet weak var event: UILabel!
  @IBOutlet weak var time: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
    self.avatar.setCornerRadius(20)
  }

  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  func setModel(model:AnyObject?) {
    if model == nil {
      return
    }
    let actor = model?.objectForKey("actor")
    self.avatar.kf_setImageWithURL(NSURL(string: (actor?.objectForKey("avatar_url"))! as! String)!, forState: UIControlState.Normal)
    self.event.text = buildActionString(model)
  }
  
  func buildActionString(model:AnyObject?) ->String {
    let type = model?.objectForKey("type") as! String
    let actor = (model?.objectForKey("actor"))?.objectForKey("login") as! String
    let repo = (model?.objectForKey("repo"))?.objectForKey("name") as! String
    var action:String? = nil
    switch type {
      case "WatchEvent":
        //starred a repo
        action = (model?.objectForKey("payload"))?.objectForKey("action") as? String
        break
      case "PushEvent":
        //push a commit
        let commits = (model?.objectForKey("payload"))?.objectForKey("size") as! Int
        action = "pushed \(commits) \(commits > 1 ? "commit" : "commits") to"
        break
      case "PullRequestEvent":
        let operation = (model?.objectForKey("payload"))?.objectForKey("action") as? String
        action = "\(operation == nil ? "" : operation!) pull request on"
        break
      case "IssueCommentEvent":
        action = "make a comment on"
        break
      case "CreateEvent":
        //create a repo
        let ref = (model?.objectForKey("payload"))?.objectForKey("ref_type") as! String
        if ref == "branch" {
          action = "created \(ref) \((model?.objectForKey("payload"))?.objectForKey("ref") as! String) on"
        }
        else {
         action = "created repo named"
        }
        break
      case "IssuesEvent":
        let operation = (model?.objectForKey("payload"))?.objectForKey("action") as? String
        action = "\(operation == nil ? "" : operation!) issue on"
        //open a issue
        break
      case "DeleteEvent":
        //delete a repo
        action = "deleted repo named"
        break
      case "MemberEvent":
        let operation = (model?.objectForKey("payload"))?.objectForKey("action") as! String
        action = "\(operation) member(s) on"
        break
      case "ForkEvent":
        action = "forked"
        break
      default: break
    }
    return "\(actor) \(action == nil ? "" : action!) \(repo)"
  }
  
  func cellHeight() -> CGFloat {
    return 56
  }
    
}
