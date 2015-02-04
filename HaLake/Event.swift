//
//  Event.swift
//  HaLake
//
//  Created by Tokusei Noborio on 2015/01/29.
//  Copyright (c) 2015年 Nyampass Corporation. All rights reserved.
//

import Foundation

struct Event {
    var title: String
    var imageURL: NSURL
    var date: NSDate
    var contentURL: NSURL
    
    init(title: String, imageURL: NSURL, date: NSDate, contentURL: NSURL) {
        self.title = title
        self.imageURL = imageURL
        self.date = date
        self.contentURL = contentURL
    }
}