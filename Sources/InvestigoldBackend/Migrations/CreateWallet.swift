import Fluent
import SQLKit
import FluentSQL
import Vapor

struct CreateWallet: AsyncMigration {
  func prepare(on database: any Database) async throws {
    try await database.schema("wallets")
      .id()
      .field("user_id", .uuid, .required)
      .field("gold_balance", .double, .required, .sql(.default(0)))
      .field("silver_balance", .double, .required, .sql(.default(0)))
      .field("created_at", .datetime, .required)
      .field("updated_at", .datetime, .required)
      .create()
  }

  func revert(on database: any Database) async throws {
    try await database.schema("wallets").delete()
  }
}
