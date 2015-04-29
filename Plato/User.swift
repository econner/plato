//
//  User.swift
//  Plato
//
//  Created by Eric Conner on 4/29/15.
//  Copyright (c) 2015 com.platoapp. All rights reserved.
//

import Realm

class User: RLMObject {
    dynamic var phone = ""
    dynamic var first_name = ""
    dynamic var last_name = ""
    dynamic var avatar = ""
}
