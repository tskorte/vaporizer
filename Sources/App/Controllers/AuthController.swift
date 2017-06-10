import Vapor
import HTTP
import FluentProvider


final class AuthController : ResourceRepresentable{
    var user: User?
    
    func index(req: Request) throws -> ResponseRepresentable{
        if let user = user {
            return try User.all().makeNode(in: nil).converted(to: JSON.self)
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
