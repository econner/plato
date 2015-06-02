//
//  Message.swift
//  Plato
//
//  Created by Eric Conner on 4/29/15.
//  Copyright (c) 2015 com.platoapp. All rights reserved.
//

import RealmSwift
import SwiftyJSON

class Message: Object, JSQMessageData {
    dynamic var id = 0
    dynamic var text_ = ""
    dynamic var created_at = NSDate(timeIntervalSinceNow: 0)
    dynamic var user: User?
    dynamic var discussion: Discussion?
    
//    convenience init(senderId: String?, senderDisplayName: String?, date: NSDate?, media: JSQMessageMediaData?) {
//        self.init(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: nil)
//    }
//    
//    convenience init(senderId: String?, senderDisplayName: String?, media: JSQMessageMediaData?) {
//        self.init(senderId: senderId, senderDisplayName: senderDisplayName, date: NSDate(), text: nil)
//    }
//    
//    convenience init(senderId: String?, senderDisplayName: String?, text: String?) {
//        self.init(senderId: senderId, senderDisplayName: senderDisplayName, date: NSDate(), text: text)
//    }
//    
//    init(senderId: String?, senderDisplayName: String?, date: NSDate?, text: String?) {
//        
//        if let validText = text {
//            self.text_ = validText
//        }
//
//        self.user = User()
//        self.user!.first_name = senderDisplayName!
//        self.user!.phone = senderId!
//        
//        self.created_at = date!
//        
//        super.init()
//    }
    
    func text() -> String! {
        return text_
    }
    
    func senderDisplayName() -> String! {
        return self.user?.first_name
    }
    
    func senderId() -> String! {
        return self.user?.phone
    }
    
    func isMediaMessage() -> Bool {
        return false
    }
    
    func media() -> JSQMessageMediaData! {
        return nil
    }
    
    func date() -> NSDate! {
        return self.created_at
    }
    
    func messageHash() -> UInt {
//        var contentHash = self.isMediaMessage() ? self.media.mediaHash() : self.text.hash;
        var contentHash = abs(self.text().hashValue)
        var senderHash = abs(self.senderId().hashValue)
        var textHash = abs(self.text().hashValue)
        return 31 &* UInt(contentHash) &+ UInt(senderHash) &+ UInt(textHash)
    }
    
    func toDict() -> [String: AnyObject] {
        return [
            "discussion_id": self.discussion!.id,
            "text": self.text(),
            "user_id": self.user!.id
        ]
    }
    
    static func fromJson(data: JSON) -> Message {
        let message = Message()
        message.id = data["id"].int!
        message.text_ = data["text"].string!
        message.user = User.fromJson(data["user"])
        return message
    }
    

}