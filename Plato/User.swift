//
//  User.swift
//  Plato
//
//  Created by Eric Conner on 4/29/15.
//  Copyright (c) 2015 com.platoapp. All rights reserved.
//

import Realm

class User: RLMObject, Equatable {
    
    static let defaults = NSUserDefaults.standardUserDefaults()
    
    dynamic var id = 0
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
    
    static func setCurrentUser(userId: Int) {
        defaults.setObject(String(userId), forKey: "currentUserId")
    }
    
    static func currentUser() -> User? {
        var userId = defaults.stringForKey("currentUserId")?.toInt()
        if userId == nil {
            return nil
        }
        var users = self.objectsWhere("id=%@", userId!)
        return users[0] as? User
    }
}

func ==(lhs: User, rhs: User) -> Bool
{
    return lhs.first_name == rhs.first_name && lhs.last_name == rhs.last_name && lhs.phone == rhs.phone
}
