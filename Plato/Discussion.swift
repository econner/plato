//
//  Discussion.swift
//  Plato
//
//  Created by Eric Conner on 4/29/15.
//  Copyright (c) 2015 com.platoapp. All rights reserved.
//

import RealmSwift
import SwiftyJSON

class Discussion: Object {
    dynamic var id = 0
    dynamic var image_url = ""
    dynamic var text = ""
    dynamic var created_at = NSDate(timeIntervalSinceNow: 0)
    dynamic var user: User?
    dynamic var participants = List<User>()
    dynamic var messages = List<Message>()
    
    func getParticipantsText() -> String {
        var names = [String]()
        if let user = self.user {
            names.append(user.first_name)
        }
        for participant in self.participants {
            names.append(participant.first_name)
        }
        let participantText = ", ".join(names)
        return participantText
    }
    
    static func fromJson(data: JSON) -> Discussion {
        let disc = Discussion()
        disc.id = data["id"].int!
        disc.text = data["text"].string!
        disc.user = User.fromJson(data["user"])
        if let participants = data["participants"].array {
            for participantJson in participants {
                var participant = User.fromJson(participantJson)
                disc.participants.append(participant)
            }
        }
        return disc
    }
    
    func toDict() -> [String: AnyObject] {
        var participantIds: [Int] = []
        for participant in self.participants {
            participantIds.append(participant.id)
        }
        return [
            "image_url": self.image_url,
            "text": self.text,
            "user_id": self.user!.id,
            "participants": participantIds
        ]
    }
}
