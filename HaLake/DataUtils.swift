//
//  DataUtils.swift
//  HaLake
//
//  Created by Tokusei Noborio on 2015/02/06.
//  Copyright (c) 2015年 Nyampass Corporation. All rights reserved.
//

import UIKit

class DataUtils: NSObject {
    class func str2date(str: String) -> NSDate! {
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")

        formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
        formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
 
        return formatter.dateFromString(str)
    }
}
