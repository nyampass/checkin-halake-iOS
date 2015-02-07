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
    
    class func date2str(date: NSDate) -> String {
        var date_formatter: NSDateFormatter = NSDateFormatter()
        date_formatter.locale     = NSLocale(localeIdentifier: "ja")

        let weekdays: Array<String!>  = [nil, "日", "月", "火", "水", "木", "金", "土"]
        let calender: NSCalendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)!
        let comps: NSDateComponents = calender.components(NSCalendarUnit.YearCalendarUnit|NSCalendarUnit.MonthCalendarUnit|NSCalendarUnit.DayCalendarUnit|NSCalendarUnit.HourCalendarUnit|NSCalendarUnit.MinuteCalendarUnit|NSCalendarUnit.SecondCalendarUnit|NSCalendarUnit.WeekdayCalendarUnit, fromDate: date)
        
        date_formatter.dateFormat = "yyyy/M/d(\(weekdays[comps.weekday])) HH:mm"
        return date_formatter.stringFromDate(date)
    }
}
