import Vapor


/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example
    router.get { req in
        return try req.view().render("index")
    }
    router.get("about") { req -> Future<View> in
      return try req.view().render("about")
    }
    router.get("activity") { req -> Future<View> in
      return try req.view().render("activity")
    }
    router.get("project") { req -> Future<View> in
      return try req.view().render("project")
    }
    router.get("recruit") { req -> Future<View> in
      return try req.view().render("recruit")
    }
    router.get("contact") { req -> Future<View> in
      return try req.view().render("contact")
    }

    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!"
    }
    
    router.get("users") { req in
        return User.query(on: req).all()
    }
    
    router.get("example") { req -> Future<View> in
      return try req.view().render("example")
    }

    router.get("bonus") { req -> Future<View> in
      let data = ["name": "junhyeon", "age": "26"]
      return try req.view().render("whoami", data)
    }
    
    try router.register(collection: UserController())
    
}


