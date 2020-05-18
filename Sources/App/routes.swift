import Vapor


/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example
    router.get { req in
        return "It works!"
    }
    
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!"
    }
    
    router.get("users") { req in
        return User.query(on: req).all()
    }
    
    router.get("view") { req -> Future<View> in
      return try req.view().render("index")
    }

    router.get("bonus") { req -> Future<View> in
      let data = ["name": "junhyeon", "age": "26"]
      return try req.view().render("whoami", data)
    }

}
