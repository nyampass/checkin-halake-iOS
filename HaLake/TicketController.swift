//
//  TicketController.swift
//  HaLake
//
//  Created by Tokusei Noborio on 2015/01/28.
//  Copyright (c) 2015年 Nyampass Corporation. All rights reserved.
//

import UIKit

class TicketController: UITableViewController {
    var tickets: Array<Ticket> = Array()
    
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
      
        tableView.backgroundColor = UIColor.pumpkinColor()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLineEtched

    }
    
    func setTickets(tickets: Array<Ticket>) {
        self.tickets = tickets
        tableView.reloadData()
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
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return tickets.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if let cell: TicketCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as? TicketCell {
            cell.configureFlatCellWithColor(UIColor.whiteColor(), selectedColor: UIColor.cloudsColor(),
                roundingCorners: .AllCorners)
            
            let ticketView = cell.ticketView
            ticketView.frame = cell.contentView.bounds
            ticketView.layer.masksToBounds = true
            ticketView.layer.cornerRadius = 3.0
            ticketView.layer.shadowOffset = CGSizeMake(1, 1)
            ticketView.layer.shadowOpacity = 0.5
            
            cell.contentView.backgroundColor = UIColor.clearColor()

            let ticket = tickets[indexPath.section]
            cell.titleLabel.text = ticket.name

            cell.cornerRadius = 5.0
            cell.separatorHeight = 1.0
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 59
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let alertView = UIUtils.alertView(nil, message: "チェックインしました！",
            delegate: nil, cancelButtonTitle: "OK")
        alertView.show()
    }
}