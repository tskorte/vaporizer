import Vapor
import HTTP
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
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set("userName", userName)
        return row
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

final class AuthController : ResourceRepresentable{
    
    var user: User?
    
    func index(req: Request) throws -> ResponseRepresentable{
        if let user = user {
            return try user.makeJSON().makeResponse()
        }
        throw Abort.badRequest
    }
    
    func create(req: Request) throws -> ResponseRepresentable{
        let user = try req.user()
        self.user = user
        try user.save()
        return user
    }
    
    func makeResource() -> Resource<User> {
        return Resource(index: index,
                        create: create,
                        store: create,
                        show: nil,
                        edit: nil)
    }
}

extension AuthController: EmptyInitializable{}
extension Request {
    func user() throws -> User {
        guard let json = json else { throw Abort.badRequest }
        return try User(json: json)
    }
}
