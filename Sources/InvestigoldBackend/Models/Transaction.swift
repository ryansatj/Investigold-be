import Fluent
import Vapor

final class Transaction: Model, Content, @unchecked Sendable {
    static let schema = "transactions"

    @ID
    var id: UUID?

    @Field(key: "wallet_id")
    var walletId: UUID

    @Field(key: "type")
    var type: String

    @Field(key: "asset")
    var asset: String

    @Field(key: "amount")
    var amount: Double

    @Field(key: "price-per-unit")
    var pricePerUnit: Double

    @Field(key: "total-amount")
    var totalAmount: Double

    @Field(key: "status")
    var status: String

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    init() {}

    init(
        id: UUID? = nil,
        walletId: UUID,
        type: String,
        asset: String,
        amount: Double,
        pricePerUnit: Double,
        totalAmount: Double,
        status: String
    ) {
        self.id = id
        self.walletId = walletId
        self.type = type
        self.asset = asset
        self.amount = amount
        self.pricePerUnit = pricePerUnit
        self.totalAmount = totalAmount
        self.status = status
    }
}