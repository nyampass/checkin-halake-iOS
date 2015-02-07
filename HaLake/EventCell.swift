//
//  EventCell.swift
//  HaLake
//
//  Created by Tokusei Noborio on 2015/01/29.
//  Copyright (c) 2015年 Nyampass Corporation. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    var tableView: UITableView!
    var indexRow: NSIndexPath!

    @IBAction func tapButton(sender: AnyObject) {
        self.tableView.delegate?.tableView!(self.tableView, didSelectRowAtIndexPath: indexRow)
    }
}
