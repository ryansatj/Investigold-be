import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }

    try app.register(collection: UserController())
    try app.register(collection: WalletController())
    try app.register(collection: TransactionController())
    try app.register(collection: GoldAPIController())
}
