//
//  Store.swift
//  HaLake
//
//  Created by Tokusei Noborio on 2015/01/19.
//  Copyright (c) 2015年 Nyampass Corporation. All rights reserved.
//

import UIKit

class User {
    var name: String!
    var id: String!
    var password: String!
    var phone: String!
    
    class func isValidAuthentication() -> Bool {
        let (id, password) = authentication()
        return (id != nil && !id!.isEmpty &&
            password != nil && !id!.isEmpty)
    }

    class func saveAuthentication(id: String, password: String) {
        let userDefaults = NSUserDefaults.standardUserDefaults()

        userDefaults.setObject(id, forKey: "_id")
        userDefaults.setObject(password, forKey: "_password")

        userDefaults.synchronize()
    }
    
    class func authentication() -> (String?, String?) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        return (userDefaults.stringForKey("_id"),
                userDefaults.stringForKey("_password"))
    }
    
    class func dic2user(dic: Dictionary<String, AnyObject>) -> User {
        let user = User()
        user.id = dic["_id"] as String
        user.name = dic["name"] as String
        user.phone = dic["phone"] as? String
        return user
    }
    
    class func isTodaysCheckin() -> Bool {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let checkinAt = userDefaults.objectForKey("checkinAt") as? NSDate
        
        if checkinAt == nil {
            return false
        }
        
        if DataUtils.isToday(checkinAt!) {
            return true
        }
        
        return false
    }
    
    class func checkin() {
        HaLakeAPI.checkin { (isSuccess) -> () in
            self.saveCheckinStatus(true)
        }
    }
    
    class func checkout() {
        HaLakeAPI.checkin { (isSuccess) -> () in
            self.saveCheckinStatus(false)
        }
    }
    
    class func saveCheckinStatus(isCheckin: Bool) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if isCheckin {
            userDefaults.setObject(NSDate(), forKey: "checkinAt")
        } else {
            userDefaults.setObject(nil, forKey: "checkinAt")
        }
        userDefaults.synchronize()
    }
}
