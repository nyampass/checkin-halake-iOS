//
//  TabBarController.swift
//  HaLake
//
//  Created by Tokusei Noborio on 2015/02/05.
//  Copyright (c) 2015年 Nyampass Corporation. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        UIUtils.showActivityIndicator(self.view)
        
        let (id, password) = User.authentication()
        HaLakeAPI.login(id!, password: password!) { (userData, alertMessage) -> () in
            UIUtils.hideActivityIndicator(self.view)
            
            if (alertMessage != nil) {
                UIApplication.sharedApplication().delegate?.window!?.rootViewController = StartupController()
            } else {
                HaLakeAPI.events({ (eventsData) -> () in
                    if eventsData != nil {
                        let eventController = self.viewControllers![1] as EventController
                        eventController.setEvents(eventsData!)
                    }
                })
            }
        }
    }
}
