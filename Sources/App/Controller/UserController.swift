import Vapor

final class UserController: RouteCollection {
    func boot(router: Router) throws {
        let group = router.grouped("user")
        
        group.get("getUserInfo", use: getUserHandler)
    }
}

extension UserController {
    // MARK: -query
    
    // Request
    func getUserHandler(_ req: Request) throws -> Future<Response> {
        
        return User
               .query(on: req)
               .all()
               .flatMap({ (result) in

                return try ResponseJSON<[User]>(data: result).encode(for: req)
        })
            
    }
    
    // Create
    
    // Read
    
    // find
    
    // query
    
    // range
    
    // sort
    
    // join
    
    // fetch
    
    // all
    
    // chunk
    
    // first
    
    // update
    
    // delete
    
}

struct UserInfoContainer: Content {
    var id: Int?
    var name: String?
}
