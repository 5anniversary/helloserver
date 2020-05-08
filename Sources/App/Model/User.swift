import Vapor
import FluentMySQL

struct User {
    var id: Int?
    var name: String?
}

extension User: Content {}
extension User: Migration {}
extension User: MySQLModel {
    typealias Database = MySQLDatabase
}
