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

final class User: Model {
    let storage = Storage()
    let userName: String
    init(userName: String){
        self.userName = userName
    }
    
    required init(row: Row) throws {
        userName = try row.get("userName")
    }
    
    init(node: Node) throws {
        userName = try node.get("userName")
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set("userName", userName)
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

extension User: JSONConvertible {
    convenience init(json: JSON) throws {
        try self.init(
            userName: json.get("userName")
        )
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set("userName", userName)
        return json
    }
}
