//
//  TicketController.swift
//  HaLake
//
//  Created by Tokusei Noborio on 2015/01/28.
//  Copyright (c) 2015年 Nyampass Corporation. All rights reserved.
//

import UIKit

class TicketController: UITableViewController, FUIAlertViewDelegate {
    let alertTagUseTicket = 1
    let alertTagMessage = 2
    
    var tickets: Array<Ticket> = Array()
    var tappedIndex: Int = 0

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
      
        tableView.backgroundColor = UIColor.cloudsColor()
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
            
            cell.ticketController = self
            cell.indexPath = indexPath

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
    
    func tapUseButton(indexPath: NSIndexPath) {
        let ticket = tickets[indexPath.section]
        tappedIndex = indexPath.section
        
        let alertView = UIUtils.alertView("チケット使用", message: "チケット\"\(ticket.name)\"を使用しますか？\n\n" +
            "HaLakeスタッフにお見せして下記の[使用する]ボタンを押してもらって下さい.\n事前に押してしまうと無効になります",
            delegate: self, cancelButtonTitle: "キャンセル")
        UIUtils.addButtonToAlertView(alertView, title:  "使用する")
        alertView.tag = alertTagUseTicket
        alertView.show()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func alertView(alertView: FUIAlertView!, clickedButtonAtIndex buttonIndex: Int) {
        println(alertView.tag)
        if alertView.tag == alertTagUseTicket && buttonIndex == 1 {
            UIUtils.showActivityIndicator(self.tabBarController!.view)
            
            let ticket = tickets[tappedIndex]
            HaLakeAPI.useTicket(ticket.id, callback: { (isSuccess) -> () in
                dispatch_async(dispatch_get_main_queue(), {
                    UIUtils.hideActivityIndicator(self.tabBarController!.view)
                    if !isSuccess {
                        let alertView = UIUtils.alertView("チケット使用",
                            message: "チケットの利用に失敗しました。スタッフにお問い合わせ下さい",
                            delegate: self,
                            cancelButtonTitle: "キャンセル")
                        alertView.tag = self.alertTagMessage
                        alertView.show()
                    } else {
                        (self.tabBarController as TabBarController).fetchData()
                    }
                })
            })
        }
    }
}