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

    override init(style: UITableViewCellStyle, reuseIdentifier: String!)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    
}