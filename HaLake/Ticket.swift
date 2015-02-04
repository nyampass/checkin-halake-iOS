//
//  Ticket.swift
//  HaLake
//
//  Created by Tokusei Noborio on 2015/01/29.
//  Copyright (c) 2015年 Nyampass Corporation. All rights reserved.
//

import Foundation

struct Ticket {
    var id: String
    var name: String
    var rest: Int
    var imageURL: NSURL
    var note: String
    
    init(id: String, name: String, rest: Int, imageURL: NSURL, note: String)
    {
        self.id = id
        self.name = name
        self.rest = rest
        self.imageURL = imageURL
        self.note = note
    }
}