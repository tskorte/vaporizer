import Vapor
import HTTP
import FluentProvider
import AuthProvider

final class UserController : ResourceRepresentable{

    func index(req: Request) throws -> ResponseRepresentable{
        throw Abort.badRequest
    }
    
    func create(req: Request) throws -> ResponseRepresentable{
        let user = try req.user()
        try user.save()
        return user
    }
    
    func makeResource() -> Resource<User> {
        return Resource(index: index,
                        create: create,
                        store: nil)
    }
}
