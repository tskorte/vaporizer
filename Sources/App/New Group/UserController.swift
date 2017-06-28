//
//  UserController.swift
//  Bits
//
//  Created by Karl Kristian Forfang on 23.06.2017.
//

import Foundation
import Vapor
import HTTP
import AuthProvider

final class UserController: ResourceRepresentable{
    func makeResource() -> Resource<User> {
        return Resource()
    }
    
    typealias Model = User
    
    func create(_ req: Request) throws -> User {
        guard let json = req.json else {
            throw Abort(.badRequest)
        }
        
        let user = try User(json: json)
        
        guard
            try User.makeQuery().filter("email", user.email).first() == nil
        else{
            throw Abort(.badRequest, reason: "A user with that email already exists.")
        }
        
        guard
            let password = json["password"]?.string
        else {
            throw Abort(.badRequest)
        }
        
        user.password = PasswordHelper.generateHashedPassword(from: password)
        
        try user.save()
        return user
    }
}
