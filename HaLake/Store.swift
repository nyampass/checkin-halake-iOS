//
//  Store.swift
//  HaLake
//
//  Created by Tokusei Noborio on 2015/01/19.
//  Copyright (c) 2015年 Nyampass Corporation. All rights reserved.
//

import UIKit

class Store: NSObject {
    class func saveAccountId(id: String) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(id, forKey: "accountId")
        userDefaults.synchronize()
    }
    
    class func account() -> String! {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        return userDefaults.stringForKey("accountId")
    }
}
