//
//  AuthController.swift
//  App
//
//  Created by Karl Kristian Forfang on 23.06.2017.
//
import Vapor
import HTTP
import FluentProvider
import AuthProvider

final class AuthController : ResourceRepresentable{
    
    func index(req: Request) throws -> ResponseRepresentable{
        return try User.all().makeNode(in: nil).converted(to: JSON.self)
    }
    
    func authenticate(_ req: Request) throws -> ResponseRepresentable{
        let user = try req.user()
        let token = try Token.generate(for: user)
        try token.save()
        return token
    }
    
    func makeResource() -> Resource<User> {
        return Resource(index: index)
    }
}

extension AuthController: EmptyInitializable{}
extension Request {
    func user() throws -> User {
        return try auth.assertAuthenticated()
    }
}

