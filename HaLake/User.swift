//
//  Store.swift
//  HaLake
//
//  Created by Tokusei Noborio on 2015/01/19.
//  Copyright (c) 2015年 Nyampass Corporation. All rights reserved.
//

import UIKit

class User: NSObject {
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
}
