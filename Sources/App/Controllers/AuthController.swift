import Vapor
import HTTP
import FluentProvider
import AuthProvider

final class AuthController : ResourceRepresentable{
    
    func index(req: Request) throws -> ResponseRepresentable{
        return try User.all().makeNode(in: nil).converted(to: JSON.self)
    }
    
    
    func makeResource() -> Resource<User> {
        return Resource(index: index,
                        create: nil,
                        store: nil,
                        show: nil,
                        edit: nil)
    }
}

extension AuthController: EmptyInitializable{}
extension Request {
    func user() throws -> User {
        return try auth.assertAuthenticated()
    }
}
