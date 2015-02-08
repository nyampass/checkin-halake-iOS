//
//  Ticket.swift
//  HaLake
//
//  Created by Tokusei Noborio on 2015/01/29.
//  Copyright (c) 2015年 Nyampass Corporation. All rights reserved.
//

import Foundation

class Ticket {
    var id: String
    var name: String
    
    init(id: String, name: String)
    {
        self.id = id
        self.name = name
    }
    
    class func id2name(id: String) -> String {
        switch (id) {
            case "1day":
                return "HaLake 1日利用"
        default:
                return id
        }
    }

    class func dic2tickets(dic: Dictionary<String, AnyObject>) -> Array<Ticket> {
        println(dic)
        var tickets = Array<Ticket>()
        for (id, countData) in dic {
            if let count = countData as? Int {
                for i in 0..<count {
                    tickets.append(Ticket(id: id, name: id2name(id)))
                }
            }
        }
        
        return tickets
    }
}