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
        
        var description: String {
            switch self {
            case .Signup: return "/v1/join/"
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
}
