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
    
    override func awakeFromNib() {
        super.awakeFromNib()

        useButton.buttonColor = UIColor.sunflowerColor()
        useButton.shadowColor = UIColor.orangeColor()
        useButton.shadowHeight = 1.5
        useButton.cornerRadius = 2.0
        
        useButton.setTitleColor(UIColor.cloudsColor(), forState: .Normal)
        useButton.setTitleColor(UIColor.cloudsColor(), forState: .Highlighted)
    }
/*
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
  */
}