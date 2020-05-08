import Vapor
import FluentMySQL


/// Called before your application initializes.
public func configure(_ config: inout Config,
                      _ env: inout Environment,
                      _ services: inout Services) throws {
    // Register providers first
    try services.register(FluentMySQLProvider())

    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    // Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    // middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    var databases = DatabasesConfig()
    let hostname = "localhost"
    let username = "user1"
    let password = "test123"
    let databaseName = "hello"
    let databaseConfig = MySQLDatabaseConfig(
      hostname: hostname,
      port: 3306,
      username: username,
      password: password,
      database: databaseName)

    let database = MySQLDatabase(config: databaseConfig)
    databases.add(database: database, as: .mysql)
    services.register(databases)

    var migrations = MigrationConfig()
    migrations.add(model: User.self, database: DatabaseIdentifier<MySQLDatabase>.mysql)
    services.register(migrations)
}
