import Fluent
import Vapor

struct UserController: RouteCollection {

  func boot(routes: any RoutesBuilder) throws {
    let users = routes.grouped("users")

    users.get(use: getAllUsers)
    users.put(":id", use: updateUser)
    users.post(use: createUser)
    users.post("login", use: getLoginUser)
  }

  func getAllUsers(req: Request) async throws -> [User] {
    try await User.query(on: req.db).all()
  }

  func getLoginUser(req: Request) async throws -> LoginResponse {
    let input = try req.content.decode(LoginRequest.self)

    guard
      let user = try await User.query(on: req.db)
        .filter(\.$email == input.email)
        .first()
    else {
      throw Abort(.notFound, reason: "User not found")
    }

    if user.passwordHash != input.password {
      throw Abort(.unauthorized, reason: "Invalid password")
    }

    return LoginResponse(
      id: user.id,
      email: user.email,
      fullName: user.fullName
    )
  }

  func updateUser(req: Request) async throws -> User {
    guard let id = req.parameters.get("id", as: UUID.self) else {
      throw Abort(.badRequest, reason: "Invalid user ID")
    }

    guard let user = try await User.find(id, on: req.db) else {
      throw Abort(.notFound, reason: "User not found")
    }

    let input = try req.content.decode(UpdateUserRequest.self)

    user.email = input.email
    user.fullName = input.fullName

    try await user.save(on: req.db)

    return user
  }

  func createUser(req: Request) async throws -> User {
    let input = try req.content.decode(CreateUserRequest.self)

    if try await User.query(on: req.db)
      .filter(\.$email == input.email)
      .first() != nil
    {
      throw Abort(
        .conflict,
        reason: "Email already exists"
      )
    }

    let user = User(
      email: input.email,
      passwordHash: input.passwordHash,
      fullName: input.fullName
    )

    try await user.save(on: req.db)

    guard let userID = user.id else {
      throw Abort(.internalServerError, reason: "Failed to create user ID")
    }

    let wallet = Wallet(
      userId: userID,
      goldBalance: 0,
      silverBalance: 0
    )

    try await wallet.save(on: req.db)

    return user
  }

}

struct CreateUserRequest: Content {
  let email: String
  let passwordHash: String
  let fullName: String
}

struct UpdateUserRequest: Content {
  let email: String
  let fullName: String
}

struct LoginRequest: Content {
  let email: String
  let password: String
}

struct LoginResponse: Content {
  let id: UUID?
  let email: String
  let fullName: String
}
