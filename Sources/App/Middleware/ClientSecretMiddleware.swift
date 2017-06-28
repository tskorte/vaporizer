//
//  ClientSecretMiddleware.swift
//  HelloVapor
//
//  Created by Karl Kristian Forfang on 17.06.2017.
//
//

import Foundation
import Vapor
import Authentication
import HTTP
let MySecret = "øløløløl"

public final class ClientSecretMiddleWare: Middleware{
    public func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        try request.clientSecret()
        return try next.respond(to: request)
    }
}

extension Request{
    public func clientSecret() throws -> String?{
        guard let header = self.headers["Authorization"]?.string
            else {
                throw ClientError.invalidClient
        }
        
        guard let range = header.range(of: "Basic ") else {
            throw ClientError.invalidClient
        }
        
        let token = header.substring(from: range.upperBound)
        let decodedToken = token.makeBytes().base64Decoded.makeString()
        guard decodedToken == MySecret else {
            throw ClientError.invalidClient
        }
        return decodedToken
    }
}

enum ClientError : AbortError{
    case invalidClient
    var status: Status{
        return .unauthorized
    }
    
    var reason: String{
        return "Fuck off"
    }
    
    var metadata: Node? {
        return nil
    }
}
