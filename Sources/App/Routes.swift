import Vapor
import AuthProvider
extension Droplet {
    func setupRoutes() throws {
	print("Testing git push hook")
        setupUserRoutes()
        
        post("gitpush"){ req in
            return "OK"
        }
        
        try resource("posts", PostController.self)
        let secretGroup = grouped(ClientSecretMiddleWare())
        secretGroup.post("user") { req in
            guard let json = req.json else {
                throw Abort(.badRequest)
            }
            
            let user = try User(json: json)
            try self.checkIfUserExists(user: user)
            
            // require a plaintext password is supplied
            guard let password = json["password"]?.string else {
                throw Abort(.badRequest)
            }
            
            // hash the password and set it on the user
            user.password = try self.hash.make(password.makeBytes()).makeString()
            
            // save and return the new user
            try user.save()
            return user
        }
        let authController = AuthController()
        let passwordGroup = grouped([PasswordAuthenticationMiddleware(User.self)])
        passwordGroup.post("login", handler: authController.authenticate)
    }
    
    func checkIfUserExists(user: User) throws{
        guard try User.makeQuery().filter("email", user.email).first() == nil else {
            throw Abort(.badRequest, reason: "A user with that email already exists.")
        }
        try setupUnauthenticatedRoutes()
        
    }
    
    func setupUserRoutes(){
        get("user", ":id"){ request in
            let user = try request.user()
            print(request.parameters["id"]!.string)
            throw Abort.unauthorized
        }
    }
    
    private func setupUnauthenticatedRoutes() throws {
        
        get("test"){
            req in
            return "ok"
        }
        
        // a simple json example response
        
        get("users") { req in
            return try User.all().makeJSON()
        }
        
        get("hello") { req in
            var json = JSON()
            try json.set("hello", "world")
            return json
        }
        
        // a simple plaintext example response
        get("plaintext") { req in
            return "Hello, world!"
        }
        
        // response to requests to /info domain
        // with a description of the request
        get("info") { req in
            return req.description
        }
        
        // create a new user
        //
        // POST /users
        // <json containing new user information>
        
    }
    
    /// Sets up all routes that can be accessed using
    /// username + password authentication.
    /// Since we want to minimize how often the username + password
    /// is sent, we will only use this form of authentication to
    /// log the user in.
    /// After the user is logged in, they will receive a token that
    /// they can use for further authentication.
    private func setupPasswordProtectedRoutes() throws {
        // creates a route group protected by the password middleware.
        // the User type can be passed to this middleware since it
        // conforms to PasswordAuthenticatable
        let password = grouped([
            PasswordAuthenticationMiddleware(User.self)
            ])
        
        // verifies the user has been authenticated using the password
        // middleware, then generates, saves, and returns a new access token.
        //
        // POST /login
        // Authorization: Basic <base64 email:password>
        password.post("login") { req in
            let user = try req.user()
            let token = try Token.generate(for: user)
            try token.save()
            return token
        }
    }
    
    /// Sets up all routes that can be accessed using
    /// the authentication token received during login.
    /// All of our secure routes will go here.
    private func setupTokenProtectedRoutes() throws {
        // creates a route group protected by the token middleware.
        // the User type can be passed to this middleware since it
        // conforms to TokenAuthenticatable
        let token = grouped([
            TokenAuthenticationMiddleware(User.self)
        ])
        
        // simply returns a greeting to the user that has been authed
        // using the token middleware.
        //
        // GET /me
        // Authorization: Bearer <token from /login>
        token.get("me") { req in
            let user = try req.user()
            return "Hello, \(user.userName)"
        }
    }
}
