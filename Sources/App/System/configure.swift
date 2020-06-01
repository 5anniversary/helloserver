import Vapor
import FluentMySQL
import Leaf


/// Called before your application initializes.
public func configure(_ config: inout Config,
                      _ env: inout Environment,
                      _ services: inout Services) throws {
    // Register providers first
    try services.register(FluentMySQLProvider())


    let leafProvider = LeafProvider()
    try services.register(leafProvider)
    config.prefer(LeafRenderer.self, for: ViewRenderer.self)

    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    // Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    // middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    middlewares.use(FileMiddleware.self)
    services.register(middlewares)
    
    var databases = DatabasesConfig()
    let hostname = Environment.get("DB_HOSTNAME") ?? "localhost"
    let username = Environment.get("DB_USERNAME") ?? "user1"
    let password = Environment.get("DB_PASSWORD") ?? "test123"
    let databaseName = Environment.get("DB_DBNAME") ?? "hello"
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
    migrations.add(model: Article.self, database: DatabaseIdentifier<MySQLDatabase>.mysql)
    services.register(migrations)
}
