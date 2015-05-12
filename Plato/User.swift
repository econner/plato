//
//  User.swift
//  Plato
//
//  Created by Eric Conner on 4/29/15.
//  Copyright (c) 2015 com.platoapp. All rights reserved.
//

import Realm

class User: RLMObject, Equatable {
    dynamic var phone = ""
    dynamic var first_name = ""
    dynamic var last_name = ""
    dynamic var avatar = ""
    
    dynamic var contacts = RLMArray(objectClassName: User.className())
    
    var name: String {
        get {
            return first_name + " " + last_name
        }
    }
    
    static func currentUser() -> User? {
        var users = self.objectsWhere("phone='3033507959'")
        return users[0] as? User
    }
}

func ==(lhs: User, rhs: User) -> Bool
{
    return lhs.first_name == rhs.first_name && lhs.last_name == rhs.last_name && lhs.phone == rhs.phone
}
