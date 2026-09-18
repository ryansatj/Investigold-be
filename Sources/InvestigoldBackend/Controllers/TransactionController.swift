import Fluent
import Vapor

struct TransactionController: RouteCollection {
  func boot(routes: any RoutesBuilder) throws {
    let transactions = routes.grouped("transactions")

    transactions.get(use: getAllTransactions)
    transactions.post("buy-gold", use: addGoldTransaction)
    transactions.post("buy-silver", use: addSilverTransaction)
    transactions.post("sell-gold", use: deductGoldTransaction)
    transactions.post("sell-silver", use: deductSilverTransaction)
  }

  func getAllTransactions(req: Request) async throws -> [Transaction] {
    try await Transaction.query(on: req.db).all()
  }

  func addGoldTransaction(req: Request) async throws -> Transaction {
    let input = try req.content.decode(CreateTransactionRequest.self)

    let wallet = try await Wallet.find(input.walletId, on: req.db)
    guard let wallet = wallet else {
      throw Abort(.notFound, reason: "Wallet not found")
    }

    let transaction = Transaction(
      walletId: input.walletId,
      type: "BUY",
      asset: "GOLD",
      amount: input.amount,
      pricePerUnit: input.pricePerUnit,
      totalAmount: input.amount * input.pricePerUnit,
      status: "PENDING"
    )

    try await transaction.save(on: req.db)

    wallet.goldBalance += input.amount

    try await wallet.save(on: req.db)

    transaction.status = "COMPLETED"
    try await transaction.save(on: req.db)

    return transaction
  }

  func addSilverTransaction(req: Request) async throws -> Transaction {
    let input = try req.content.decode(CreateTransactionRequest.self)

    let wallet = try await Wallet.find(input.walletId, on: req.db)
    guard let wallet = wallet else {
      throw Abort(.notFound, reason: "Wallet not found")
    }

    let transaction = Transaction(
      walletId: input.walletId,
      type: "BUY",
      asset: "SILVER",
      amount: input.amount,
      pricePerUnit: input.pricePerUnit,
      totalAmount: input.amount * input.pricePerUnit,
      status: "PENDING"
    )

    try await transaction.save(on: req.db)

    wallet.silverBalance += input.amount

    try await wallet.save(on: req.db)
    
    transaction.status = "COMPLETED"
    try await transaction.save(on: req.db)

    return transaction
  }

  func deductGoldTransaction(req: Request) async throws -> Transaction {
    let input = try req.content.decode(CreateTransactionRequest.self)

    let wallet = try await Wallet.find(input.walletId, on: req.db)
    guard let wallet = wallet else {
      throw Abort(.notFound, reason: "Wallet not found")
    }

    if wallet.goldBalance < input.amount {
      throw Abort(.badRequest, reason: "Insufficient gold balance")
    }

    let transaction = Transaction(
      walletId: input.walletId,
      type: "SELL",
      asset: "GOLD",
      amount: input.amount,
      pricePerUnit: input.pricePerUnit,
      totalAmount: input.amount * input.pricePerUnit,
      status: "PENDING"
    )

    try await transaction.save(on: req.db)

    wallet.goldBalance -= input.amount

    try await wallet.save(on: req.db)

    transaction.status = "COMPLETED"
    try await transaction.save(on: req.db)

    return transaction
  }

  func deductSilverTransaction(req: Request) async throws -> Transaction {
    let input = try req.content.decode(CreateTransactionRequest.self)

    let wallet = try await Wallet.find(input.walletId, on: req.db)
    guard let wallet = wallet else {
      throw Abort(.notFound, reason: "Wallet not found")
    }

    if wallet.silverBalance < input.amount {
      throw Abort(.badRequest, reason: "Insufficient silver balance")
    }

    let transaction = Transaction(
      walletId: input.walletId,
      type: "SELL",
      asset: "SILVER",
      amount: input.amount,
      pricePerUnit: input.pricePerUnit,
      totalAmount: input.amount * input.pricePerUnit,
      status: "PENDING"
    )

    try await transaction.save(on: req.db)

    wallet.silverBalance -= input.amount

    try await wallet.save(on: req.db)

    transaction.status = "COMPLETED"
    try await transaction.save(on: req.db)

    return transaction
  }
}

struct CreateTransactionRequest: Content {
  let walletId: UUID
  let amount: Double
  let pricePerUnit: Double
}
