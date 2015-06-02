//
//  PlatoApiService.swift
//  Plato
//
//  Created by Eric Conner on 5/15/15.
//  Copyright (c) 2015 com.platoapp. All rights reserved.
//

import Alamofire
import SwiftyJSON

struct PlatoApiService {
    
    private static let baseURL = "http://localhost:8080"
    
    private enum ResourcePath: Printable {
        case Signup
        case Login
        
        case AddContacts(userId: Int)
        case GetContacts(userId: Int)
        
        case CreateDiscussion
        case ListDiscussions(userId: Int)
        case CreateMessage(discussionId: Int)
        case GetMessages(discussionId: Int)
        
        case GetUsers
        
        var description: String {
            switch self {
            case .Signup: return "/v1/join/"
            case .Login: return "/v1/login/"
            case .AddContacts(let userId): return "/v1/contacts/\(userId)/add/"
            case .GetContacts(let userId): return "/v1/contacts/\(userId)/get/"
            case .CreateDiscussion: return "/v1/discussion/create/"
            case .CreateMessage(let discussionId): return "/v1/discussion/\(discussionId)/message/create/"
            case .GetMessages(let discussionId): return "/v1/discussion/\(discussionId)/messages/get/"
            case .ListDiscussions(let userId): return "/v1/discussion/\(userId)/list/"
            case .GetUsers: return "/v1/users/get/"
            }
        }
    }
    
    static func join(parameters: [String: AnyObject], callback: ((data: JSON, error: NSError?) -> Void)) {
        let urlString = baseURL + ResourcePath.Signup.description
        Alamofire.request(.POST, urlString, parameters: parameters).responseJSON { (request, response, respData, error) in
            
            var responseJSON: JSON
            if error != nil || respData == nil{
                responseJSON = JSON.nullJSON
            } else {
                responseJSON = SwiftyJSON.JSON(respData!)
            }
            callback(data: responseJSON, error: error)
        }
    }
    
    static func login(parameters: [String: AnyObject], callback: ((data: JSON, error: NSError?) -> Void)) {
        let urlString = baseURL + ResourcePath.Login.description
        Alamofire.request(.POST, urlString, parameters: parameters).responseJSON { (request, response, respData, error) in
            
            var responseJSON: JSON
            if error != nil || respData == nil{
                responseJSON = JSON.nullJSON
            } else {
                responseJSON = SwiftyJSON.JSON(respData!)
            }
            callback(data: responseJSON, error: error)
        }
    }
    
    static func addContacts(userId: Int, phoneNumbers: [String], callback: ((data: JSON, error: NSError?) -> Void)) {
        let urlString = baseURL + ResourcePath.AddContacts(userId: userId).description
        let params = ["phone_numbers": phoneNumbers]
        Alamofire.request(.POST, urlString, parameters: params).responseJSON { (request, response, respData, error) in
            
            var responseJSON: JSON
            if error != nil || respData == nil{
                responseJSON = JSON.nullJSON
            } else {
                responseJSON = SwiftyJSON.JSON(respData!)
            }
            callback(data: responseJSON, error: error)
        }
    }
    
    static func getContacts(userId: Int, callback: ((data: JSON, error: NSError?) -> Void)) {
        let urlString = baseURL + ResourcePath.GetContacts(userId: userId).description
        Alamofire.request(.GET, urlString, parameters: nil).responseJSON { (request, response, respData, error) in
            
            var responseJSON: JSON
            if error != nil || respData == nil{
                responseJSON = JSON.nullJSON
            } else {
                responseJSON = SwiftyJSON.JSON(respData!)
            }
            callback(data: responseJSON, error: error)
        }
    }
    
    static func createDiscussion(discussion: Discussion, callback: ((data: JSON, error: NSError?) -> Void)) {
        let urlString = baseURL + ResourcePath.CreateDiscussion.description
        let params = discussion.toDict()
        Alamofire.request(.POST, urlString, parameters: params).responseJSON { (request, response, respData, error) in
            
            var responseJSON: JSON
            if error != nil || respData == nil{
                responseJSON = JSON.nullJSON
            } else {
                responseJSON = SwiftyJSON.JSON(respData!)
            }
            callback(data: responseJSON, error: error)
        }
    }
    
    static func listDiscussions(userId: Int, callback: ((data: JSON, error: NSError?) -> Void)) {
        let urlString = baseURL + ResourcePath.ListDiscussions(userId: userId).description
        Alamofire.request(.GET, urlString, parameters: nil).responseJSON { (request, response, respData, error) in
            
            var responseJSON: JSON
            if error != nil || respData == nil{
                responseJSON = JSON.nullJSON
            } else {
                responseJSON = SwiftyJSON.JSON(respData!)
            }
            callback(data: responseJSON, error: error)
        }
    }
    
    static func createMessage(message: Message, callback: ((data: JSON, error: NSError?) -> Void)) {
        let discussionId = message.discussion!.id
        let urlString = baseURL + ResourcePath.CreateMessage(discussionId: discussionId).description
        println(urlString)
        let params = message.toDict()
        Alamofire.request(.POST, urlString, parameters: params).responseJSON { (request, response, respData, error) in
            
            var responseJSON: JSON
            if error != nil || respData == nil{
                responseJSON = JSON.nullJSON
            } else {
                responseJSON = SwiftyJSON.JSON(respData!)
            }
            callback(data: responseJSON, error: error)
        }
    }
    
    static func getMessages(discussionId: Int, callback: ((data: JSON, error: NSError?) -> Void)) {
        let urlString = baseURL + ResourcePath.GetMessages(discussionId: discussionId).description
        Alamofire.request(.GET, urlString, parameters: nil).responseJSON { (request, response, respData, error) in
            
            var responseJSON: JSON
            if error != nil || respData == nil{
                responseJSON = JSON.nullJSON
            } else {
                responseJSON = SwiftyJSON.JSON(respData!)
            }
            callback(data: responseJSON, error: error)
        }
    }

    
    static func getUsers(userIds: [Int], callback: ((data: JSON, error: NSError?) -> Void)) {
        let urlString = baseURL + ResourcePath.GetUsers.description
        let params = ["user_ids": userIds]
        Alamofire.request(.GET, urlString, parameters: params).responseJSON { (request, response, respData, error) in
            var responseJSON: JSON
            if error != nil || respData == nil{
                responseJSON = JSON.nullJSON
            } else {
                responseJSON = SwiftyJSON.JSON(respData!)
            }
            callback(data: responseJSON, error: error)
        }
    }

}
