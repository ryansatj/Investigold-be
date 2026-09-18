import Fluent

struct CreateTransaction: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("transactions")
            .id()
            .field("wallet_id", .uuid, .required)
            .field("type", .string, .required)
            .field("asset", .string, .required)
            .field("amount", .double, .required)
            .field("price-per-unit", .double, .required)
            .field("total-amount", .double, .required)
            .field("status", .string, .required)
            .field("created_at", .datetime, .required)
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("transactions").delete()
    }
}