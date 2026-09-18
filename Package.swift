// swift-tools-version:6.3
import PackageDescription

let package = Package(
  name: "InvestigoldBackend",
  platforms: [
    .macOS(.v13)
  ],
  dependencies: [
    // 💧 A server-side Swift web framework.
    .package(url: "https://github.com/vapor/vapor.git", from: "4.121.4"),
    // 🔵 Non-blocking, event-driven networking for Swift. Used for custom executors
    .package(url: "https://github.com/apple/swift-nio.git", from: "2.101.0"),
    .package(url: "https://github.com/vapor/fluent.git", from: "4.11.0"),
    .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.9.0"),
  ],
  targets: [
    .executableTarget(
      name: "InvestigoldBackend",
      dependencies: [
        .product(name: "Vapor", package: "vapor"),
        .product(name: "NIOCore", package: "swift-nio"),
        .product(name: "NIOPosix", package: "swift-nio"),
        .product(name: "Fluent", package: "fluent"),
        .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
      ],
      swiftSettings: swiftSettings
    ),
    .testTarget(
      name: "InvestigoldBackendTests",
      dependencies: [
        .target(name: "InvestigoldBackend"),
        .product(name: "VaporTesting", package: "vapor"),
      ],
      swiftSettings: swiftSettings
    ),
  ]
)

var swiftSettings: [SwiftSetting] {
  [
    .enableUpcomingFeature("ExistentialAny"),
    .enableUpcomingFeature("InternalImportsByDefault"),
    .enableUpcomingFeature("MemberImportVisibility"),
    .enableUpcomingFeature("InferIsolatedConformances"),
    .enableUpcomingFeature("ImmutableWeakCaptures"),
  ]
}
