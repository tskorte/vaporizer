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

private var _userPasswordVerifier: PasswordVerifier? = nil

public final class User: Model {
    public let storage = Storage()
    public let userName: String
    public let email: String
    public var password: String?
    
    init(name: String, email: String, password: String? = nil) {
        self.userName = name
        self.email = email
        self.password = password
    }

    required public init(row: Row) throws {
        userName = try row.get("name")
        email = try row.get("email")
        password = try row.get("password")
    }
    
    public func makeRow() throws -> Row {
        var row = Row()
        try row.set("name", userName)
        try row.set("email", email)
        try row.set("password", password)
        return row
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
            name: json.get("name"),
            email: json.get("email")
        )
        id = try json.get("id")
    }
    
    public func makeJSON() throws -> JSON {
        var json = JSON()   
        try json.set("id", id)
        try json.set("name", userName)
        try json.set("email", email)
        return json
    }
}

extension User: Preparation{
    public static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string("name")
            builder.string("email")
            builder.string("password")
        }
    }
    
    public static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

extension User: PasswordAuthenticatable {
    public var hashedPassword: String? {
        return password
    }
    
    public static var passwordVerifier: PasswordVerifier? {
        get { return _userPasswordVerifier }
        set { _userPasswordVerifier = newValue }
    }
}
