@_exported import Vapor
import AuthProvider
extension Droplet {
    public func setup() throws {
        try setupRoutes()
        try setupAuth()
        
        // Do any additional droplet setup
    }
}

extension Droplet{
    func setupAuth() throws {
        let tokenMiddleware = TokenAuthenticationMiddleware(User.self)
        let authed = self.grouped(tokenMiddleware)
        authed.get("me"){ req in
            return try req.user()
        }
    }
}
