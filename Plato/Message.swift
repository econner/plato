//
//  Message.swift
//  Plato
//
//  Created by Eric Conner on 4/29/15.
//  Copyright (c) 2015 com.platoapp. All rights reserved.
//

import Realm

class Message: RLMObject {
    dynamic var text = ""
    dynamic var created_at = NSDate(timeIntervalSinceNow: 0)
    dynamic var user: User?
    dynamic var discussion: Discussion?
}