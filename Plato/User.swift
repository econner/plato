//
//  User.swift
//  Plato
//
//  Created by Eric Conner on 4/29/15.
//  Copyright (c) 2015 com.platoapp. All rights reserved.
//

import RealmSwift
import SwiftyJSON

class User: Object, Equatable {
    
    static let defaults = NSUserDefaults.standardUserDefaults()
    
    dynamic var id = 0
    dynamic var phone = ""
    dynamic var first_name = ""
    dynamic var last_name = ""
    dynamic var avatar = ""
    
    dynamic var contacts = List<User>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
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
        var users = Realm().objects(User).filter("id=%d", userId!)
        if users.count == 0 {
            return nil
        }
        return users[0]
    }
    
    static func getMany(userIds: [Int]) {
        
    }
    
    static func fromJson(data: JSON) -> User {
        let user = User()
        user.id = data["id"].int!
        user.phone = data["phone"].string!
        user.first_name = data["first_name"].string!
        user.last_name = data["last_name"].string!
        return user
    }
}

func ==(lhs: User, rhs: User) -> Bool
{
    return lhs.first_name == rhs.first_name && lhs.last_name == rhs.last_name && lhs.phone == rhs.phone
}
