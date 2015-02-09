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
        
        fetchData()
    }
    
    func fetchData() {
        
        UIUtils.showActivityIndicator(self.view)
        
        let (id, password) = User.authentication()
        HaLakeAPI.login(id!, password: password!) { (userData, alertMessage) -> () in
            UIUtils.hideActivityIndicator(self.view)
            
            let controllers = self.viewControllers!
            
            if (userData != nil) {
                let user: User = User.dic2user(userData!)
                let profileController = (controllers[2] as UINavigationController)
                    .viewControllers[0] as ProfileController
                profileController.setUser(user)
            }
            
            println(userData)
            
            if let ticketObj = userData?["tickets"] as? Dictionary<String, AnyObject> {
                println(ticketObj)
                let ticketController = (controllers[0] as UINavigationController).viewControllers[0]
                    as TicketController
                ticketController.setTickets(Ticket.dic2tickets(ticketObj))
            }
            
            if (alertMessage != nil) {
                UIApplication.sharedApplication().delegate?.window!?.rootViewController = StartupController()
            } else {
                HaLakeAPI.events({ (eventsData) -> () in
                    if eventsData != nil {
                        let eventController = (controllers[1] as UINavigationController).viewControllers[0]
                            as EventController
                        eventController.setEvents(eventsData!)
                    }
                })
            }
        }
    }
}
