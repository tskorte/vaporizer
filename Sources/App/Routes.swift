import Vapor
import AuthProvider
extension Droplet {
    func setupRoutes() throws {
        post("gitpush"){ req in
            return "OK"
        }
        
        
        try resource("posts", PostController.self)
        try resource("auth", AuthController.self)
    }
    
    
}
