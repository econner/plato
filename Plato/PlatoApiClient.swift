//
//  PlatoApiClient.swift
//  Plato
//
//  Created by Eric Conner on 5/12/15.
//  Copyright (c) 2015 com.platoapp. All rights reserved.
//

import SwiftHTTP

class PlatoApiClient {
    
    static func ping() {
        var request = HTTPTask()
        request.GET("http://localhost:8080/v1/ping/", parameters: nil, success: {(response: HTTPResponse) in
            if let data = response.responseObject as? NSData {
                let str = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("response: \(str)")
                self.pingIndex()
            }
            },failure: {(error: NSError, response: HTTPResponse?) in
                println("error: \(error)")
        })
    }
    
    static func pingIndex() {
        var request = HTTPTask()
        request.GET("http://localhost:8080/v1/", parameters: nil, success: {(response: HTTPResponse) in
            if let data = response.responseObject as? NSData {
                let str = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("response: \(str)")
            }
            },failure: {(error: NSError, response: HTTPResponse?) in
                println("error: \(error)")
        })
    }
    
}