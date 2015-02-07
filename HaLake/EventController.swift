//
//  EventController.swift
//  HaLake
//
//  Created by Tokusei Noborio on 2015/01/18.
//  Copyright (c) 2015年 Nyampass Corporation. All rights reserved.
//

import UIKit

class EventController: UITableViewController {
    let kCellIdentifier = "EventCell"
    
    var events: Array<Event>?

    override init() {
        super.init()
        
        self.events = Array<Event>()

        self.tabBarItem.image = UIImage(named:"tabbar_news.png")
        self.tabBarItem.title = "イベント"
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        UIUtils.setNavigationBar(self, title: self.tabBarItem.title!)
        
        var nib  = UINib(nibName: "EventCell", bundle:nil)
        tableView.allowsSelection = false
        tableView.registerNib(nib, forCellReuseIdentifier: "EventCell")
    }
    
    func setEvents(events: Array<Event>) {
        self.events = events
        tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "contentSizeCategoryChanged:", name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool)
    {
        super.viewDidDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }
    
    func contentSizeCategoryChanged(notification: NSNotification)
    {
        tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return events!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if let cell: EventCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as? EventCell {
            if let event = events?[indexPath.row] {
                
                cell.tableView = self.tableView
                cell.indexRow = indexPath
                
                cell.titleLabel.text = event.title
                cell.dateLabel.text = DataUtils.date2str(event.date)
                
                request(.GET, event.imageURL).response() {
                    (_, _, data, _) in
                    
                    let image = UIImage(data: data! as NSData)
                    dispatch_async(dispatch_get_main_queue(), {
                        if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) {
                            cell.backgroundImageView?.image = image
                        }
                    })
                }
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 145
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let event = events?[indexPath.row] {
            self.navigationController?.pushViewController(WebController(url: event.contentURL), animated: true)
        }
    }
}
