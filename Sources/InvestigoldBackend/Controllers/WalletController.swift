import Fluent
import Vapor

struct WalletController: RouteCollection {
  func boot(routes: any RoutesBuilder) throws {
    let wallets = routes.grouped("wallets")

    wallets.get(use: getAllWallets)
    wallets.post(use: createWallet)
    wallets.get(":id", use: getOneWallet)
    wallets.post("add-gold", use: addGoldBalance)
    wallets.post("add-silver", use: addSilverBalance)
    wallets.post("deduct-gold", use: deductGoldBalance)
    wallets.post("deduct-silver", use: deductSilverBalance)
  }

  func getAllWallets(req: Request) async throws -> [Wallet] {
    try await Wallet.query(on: req.db).all()
  }

  func getOneWallet(req: Request) async throws -> Wallet {
    guard let id = req.parameters.get("id", as: UUID.self) else {
      throw Abort(.badRequest, reason: "Invalid wallet ID")
    }

    guard let wallet = try await Wallet.find(id, on: req.db) else {
      throw Abort(.notFound, reason: "Wallet not found")
    }

    return wallet
  }

  func createWallet(req: Request) async throws -> Wallet {
    let input = try req.content.decode(CreateWalletRequest.self)

    let wallet = Wallet(
      userId: input.userId,
      goldBalance: 0,
      silverBalance: 0
    )

    try await wallet.save(on: req.db)

    return wallet
  }

  func addGoldBalance(req: Request) async throws -> Wallet {
    let input = try req.content.decode(WalletTransaction.self)

    guard let wallet = try await Wallet.find(input.walletId, on: req.db) else {
      throw Abort(.notFound, reason: "Wallet not found")
    }

    wallet.goldBalance += input.amount
    try await wallet.save(on: req.db)

    return wallet
  }

  func addSilverBalance(req: Request) async throws -> Wallet {
    let input = try req.content.decode(WalletTransaction.self)

    guard let wallet = try await Wallet.find(input.walletId, on: req.db) else {
      throw Abort(.notFound, reason: "Wallet not found")
    }

    wallet.silverBalance += input.amount
    try await wallet.save(on: req.db)

    return wallet
  }

  func deductGoldBalance(req: Request) async throws -> Wallet {
    let input = try req.content.decode(WalletTransaction.self)

    guard let wallet = try await Wallet.find(input.walletId, on: req.db) else {
      throw Abort(.notFound, reason: "Wallet not found")
    }

    if wallet.goldBalance < input.amount {
      throw Abort(.badRequest, reason: "Insufficient gold balance")
    }

    wallet.goldBalance -= input.amount
    try await wallet.save(on: req.db)

    return wallet
  }

  func deductSilverBalance(req: Request) async throws -> Wallet {
    let input = try req.content.decode(WalletTransaction.self)

    guard let wallet = try await Wallet.find(input.walletId, on: req.db) else {
      throw Abort(.notFound, reason: "Wallet not found")
    }

    if wallet.silverBalance < input.amount {
      throw Abort(.badRequest, reason: "Insufficient silver balance")
    }

    wallet.silverBalance -= input.amount
    try await wallet.save(on: req.db)

    return wallet
  }

}

struct CreateWalletRequest: Content {
  let userId: UUID
  let goldBalance: Double
  let silverBalance: Double
}

struct WalletTransaction: Content {
  let walletId: UUID
  let amount: Double
}
