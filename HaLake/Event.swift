//
//  Event.swift
//  HaLake
//
//  Created by Tokusei Noborio on 2015/01/29.
//  Copyright (c) 2015年 Nyampass Corporation. All rights reserved.
//

import Foundation

class Event {
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
    
    class func dic2event(dic: Dictionary<String, AnyObject>) -> Event? {
        let title = dic["title"] as String
        let imageURL =  NSURL(string: dic["image-url"] as String)!
        let date = DataUtils.str2date(dic["event-at"] as String)!
        let contentURL = NSURL(string: dic["content-url"] as String)!
        //let date = dic["event-at"] as
        //let contentURL = dic["content-url"]
        return Event(title: title, imageURL: imageURL,
            date: date,
            contentURL: contentURL)
    }
}