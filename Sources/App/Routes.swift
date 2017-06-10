import Vapor
extension Droplet {
    func setupRoutes() throws {
        post("gitpush"){ req in
            ShellHelper.shell(launchPath: "sh ~/deployScript.sh",
                                arguments: ["-p"])
            return "OK"
        }
        
        try resource("posts", PostController.self)
        try resource("auth", AuthController.self)
    }
    
    
}
