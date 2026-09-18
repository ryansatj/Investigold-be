import Fluent
import Vapor

final class Wallet: Model, Content, @unchecked Sendable {
    static let schema = "wallets"

    @ID
    var id: UUID?

    @Field(key: "user_id")
    var userId: UUID

    @Field(key: "gold_balance")
    var goldBalance: Double

    @Field(key: "silver_balance")
    var silverBalance: Double

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?

    init() {}

    init(
        id: UUID? = nil,
        userId: UUID,
        goldBalance: Double,
        silverBalance: Double
    ) {
        self.id = id
        self.userId = userId
        self.goldBalance = goldBalance
        self.silverBalance = silverBalance
    }
}