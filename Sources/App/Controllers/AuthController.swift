import Vapor
import HTTP
import FluentProvider


final class AuthController : ResourceRepresentable{
    var user: User?
    
    func index(req: Request) throws -> ResponseRepresentable{
        return try User.all().makeNode(in: nil).converted(to: JSON.self)
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
