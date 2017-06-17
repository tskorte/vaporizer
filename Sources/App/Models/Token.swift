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
import Crypto

public final class Token: Model {
    public let storage = Storage()
    public let token: String
    public let userId: Identifier
    
    var user: Parent<Token, User> {
        return parent(id: userId)
    }
    
    public init(row: Row) throws {
        token = try row.get("token")
        userId = try row.get(User.foreignIdKey)
    }
    
    init(tokenString: String, user: User) throws {
        token = tokenString
        userId = try user.assertExists()
    }
}

extension Token {
    /// Generates a new token for the supplied User.
    static func generate(for user: User) throws -> Token {
        // generate 128 random bits using OpenSSL
        let random = try Crypto.Random.bytes(count: 16)
        
        // create and return the new token
        return try Token(tokenString: random.base64Encoded.makeString(), user: user)
    }
}

extension Token: RowRepresentable{
    public func makeRow() throws -> Row {
        var row = Row()
        try row.set("token", token)
        try row.set(User.foreignIdKey, userId)
        return row
    }
}

extension Token: Preparation{
    public static func prepare(_ database: Database) throws {
        try database.create(self){ tokens in
            tokens.id()
            tokens.string("token")
            tokens.foreignId(for: User.self)
        }
    }
    
    public static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

extension Token: ResponseRepresentable { }

extension Token: JSONRepresentable {
    public func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set("token", token)
        return json
    }
}
