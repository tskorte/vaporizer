//
//  User.swift
//  HelloVapor
//
//  Created by Karl Kristian Forfang on 10.06.2017.
//
//
import Vapor
import Foundation
import FluentProvider
import AuthProvider

public final class User: Model {
    public let storage = Storage()
    public let userName: String
    public let userId: Identifier
    init(userName: String, userId: Identifier){
        self.userId = userId
        self.userName = userName
    }
    
    required public init(row: Row) throws {
        userName = try row.get("userName")
        userId = try row.get("userId")
    }
    
    init(node: Node) throws {
        userName = try node.get("userName")
        userId = try node.get("userId")
    }
    
    public func makeRow() throws -> Row {
        var row = Row()
        try row.set("userName", userName)
        try row.set("userId", userId)
        return row
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "userName" : userName
            ])
    }
}


extension User: ResponseRepresentable {
}

extension User: TokenAuthenticatable{
    public typealias TokenType = Token
}

extension User: JSONConvertible {
    convenience public init(json: JSON) throws {
        try self.init(
            userName: json.get("userName"),
            userId: json.get("userId")
        )
    }
    
    public func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set("userName", userName)
        try json.set("userId", userId)
        return json
    }
}

extension User: Preparation{
    public static func prepare(_ database: Database) throws {
        try database.create(self){ users in
            users.id()
            users.string("userName")
            users.int("userId")
        }
    }
    
    public static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}
