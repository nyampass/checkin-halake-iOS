//
//  ButtonCell.swift
//  HaLake
//
//  Created by Tokusei Noborio on 2015/02/09.
//  Copyright (c) 2015年 Nyampass Corporation. All rights reserved.
//

import UIKit

class ButtonCell: UITableViewCell {
    @IBOutlet weak var button: FUIButton!

    override func awakeFromNib() {
        super.awakeFromNib()

        button.buttonColor = UIColor.turquoiseColor()
        button.shadowColor = UIColor.greenSeaColor()
        button.shadowHeight = 3.0
        button.cornerRadius = 6.0
        button.titleLabel?.font = UIFont.boldFlatFontOfSize(16)
        
        button.setTitleColor(UIColor.cloudsColor(), forState: .Normal & .Highlighted)
    }
}
