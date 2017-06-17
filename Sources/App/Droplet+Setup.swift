@_exported import Vapor
import AuthProvider
extension Droplet {
    public func setup() throws {
        try setupPasswordVerifier()
        try setupRoutes()
        try setupAuth()
        // Do any additional droplet setup
    }
    
    private func setupPasswordVerifier() throws {
        /// the BCrypt hasher (as specified in droplet.json)
        /// already conforms to PasswordVerifier.
        guard let verifier = hash as? PasswordVerifier else {
            throw Abort(.internalServerError, reason: "\(type(of: hash)) must conform to PasswordVerifier.")
        }
        
        User.passwordVerifier = verifier
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
