//
//  Token.swift
//  HelloVapor
//
//  Created by Karl Kristian Forfang on 10.06.2017.
//
//

import Foundation
import Vapor
import FluentProvider

public final class Token: Model {
    public let storage = Storage()
    public let token: String
    public let userId: Identifier
    
    var user: Parent<Token, User> {
        return parent(id: userId)
    }
    
    public init(row: Row) throws {
        token = try row.get("token")
        userId = try row.get("userId")
    }
    
    init(userId: Identifier, token: String){
        self.userId = userId
        self.token = token
    }
}

extension Token: RowRepresentable{
    public func makeRow() throws -> Row {
        var row = Row()
        try row.set("token", token)
        try row.set("userId", userId)
        return row
    }
}

extension Token: Preparation{
    public static func prepare(_ database: Database) throws {
        try database.create(self){ tokens in
            tokens.id()
            tokens.string("token")
            tokens.int("userId")
        }
    }
    
    public static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}
