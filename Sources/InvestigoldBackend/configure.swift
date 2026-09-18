import Vapor
import Fluent
import FluentPostgresDriver

func configure(_ app: Application) async throws {

    app.databases.use(
        DatabaseConfigurationFactory.postgres(
            configuration: .init(
                hostname: Environment.get("DATABASE_HOSTNAME") ?? "localhost",
                port: Environment.get("DATABASE_PORT").flatMap(Int.init) ?? 5432,
                username: Environment.get("DATABASE_USERNAME") ?? "",
                password: Environment.get("DATABASE_PASSWORD") ?? "",
                database: Environment.get("DATABASE_NAME") ?? ""
            )
        ),
        as: .psql
    )

    app.migrations.add(CreateUser())
    app.migrations.add(CreateWallet())
    app.migrations.add(CreateTransaction())

    try routes(app)
}