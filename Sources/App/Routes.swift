import Vapor
extension Droplet {
    func setupRoutes() throws {
        post("gitpush"){ req in
            ShellHelper.shell(launchPath: "echo launching",
                                arguments: [""])
            return "OK"
        }
        
        try resource("posts", PostController.self)
        try resource("auth", AuthController.self)
    }
    
    
}
