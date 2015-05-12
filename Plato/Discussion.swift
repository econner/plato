//
//  Discussion.swift
//  Plato
//
//  Created by Eric Conner on 4/29/15.
//  Copyright (c) 2015 com.platoapp. All rights reserved.
//

import Realm

class Discussion: RLMObject {
    dynamic var image_url = ""
    dynamic var text = ""
    dynamic var created_at = NSDate(timeIntervalSinceNow: 0)
    dynamic var user: User?
    dynamic var participants = RLMArray(objectClassName: User.className())
    dynamic var messages = RLMArray(objectClassName: Message.className())
    
    func getParticipantsText() -> String {
        var names = [String]()
        if let user = self.user {
            names.append(user.first_name)
        }
        for participant in self.participants {
            let user = participant as! User
            names.append(user.first_name)
        }
        let participantText = ", ".join(names)
        return participantText
    }
}
