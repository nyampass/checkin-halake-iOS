//
//  TabViewCell.swift
//  HaLake
//
//  Created by Tokusei Noborio on 2015/01/29.
//  Copyright (c) 2015年 Nyampass Corporation. All rights reserved.
//

import Foundation


import UIKit

class TicketCell: UITableViewCell
{
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var ticketView: UIView!
    @IBOutlet weak var useButton: FUIButton!

    var ticketController: TicketController!
    var indexPath: NSIndexPath!
    
    @IBAction func tapButton(sender: AnyObject) {
        ticketController.tapUseButton(indexPath)
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        useButton.buttonColor = UIColor.cloudsColor()
        useButton.shadowColor = UIColor.asbestosColor()
        useButton.shadowHeight = 1.5
        useButton.cornerRadius = 4.0
        
        useButton.setTitleColor(UIColor.asbestosColor(), forState: .Normal)
        useButton.setTitleColor(UIColor.asbestosColor(), forState: .Highlighted)
    }
}