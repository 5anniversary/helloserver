import Vapor
import FluentMySQL

struct Article {
    var id: Int?
    var title: String?
    var content: String?
}

extension Article: Content {}
extension Article: Migration {}
extension Article: MySQLModel {
    typealias Database = MySQLDatabase
}
