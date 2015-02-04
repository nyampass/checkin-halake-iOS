//
//  TicketController.swift
//  HaLake
//
//  Created by Tokusei Noborio on 2015/01/28.
//  Copyright (c) 2015年 Nyampass Corporation. All rights reserved.
//

import UIKit

class TicketController: UITableViewController {
    override init() {
        super.init()
    
        self.tabBarItem.image = UIImage(named:"tabbar_ticket.png")
        self.tabBarItem.title = "チケット"
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

        var nib  = UINib(nibName: "TicketCell", bundle:nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "TicketCell")

        //tableView.rowHeight = UITableViewAutomaticDimension
        //tableView.estimatedRowHeight = 58.0
        
        tableView.backgroundColor = UIUtils.UIColorFromHex(0xf2f2f2)
        tableView.separatorColor = UIColor.whiteColor()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None

        addRow()
        addRow()
        addRow()
        addRow()
    }

    
    let kCellIdentifier = "TicketCell"
    
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
    
    // Deletes all rows in the table view and replaces the model with a new empty one

    func addRow()
    {
        addSingleItem()
        
        let lastIndexPath = NSIndexPath(forRow: dataArray.count - 1, inSection: 0)
        tableView.insertRowsAtIndexPaths([lastIndexPath], withRowAnimation: .Automatic)
    }
    
    var dataArray: Array<(title:String, body:String)> = Array()

    func addSingleItem()
    {
        let data = (title: "hoge", body: "asdf")
        dataArray.append(data)
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return dataArray.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if let cell: TicketCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as? TicketCell {
            let modelItem = dataArray[indexPath.section]
            cell.titleLabel.text = "hogehoge"
            
            let corners = UIRectCorner.AllCorners
            cell.ticketView.layer.cornerRadius = 3.0 // optional
            cell.ticketView.layer.masksToBounds = true
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 59
    }
}