// swift-tools-version:4.0
// Managed by ice

import PackageDescription

let package = Package(
    name: "FlockCLI",
    products: [
        .executable(name: "flock", targets: ["FlockCLI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/yonaskolb/Beak", from: "0.4.0"),
        .package(url: "https://github.com/onevcat/Rainbow", from: "3.0.0"),
        .package(url: "https://github.com/jakeheis/SwiftCLI", from: "5.1.1"),
    ],
    targets: [
        .target(name: "FlockCLI", dependencies: ["BeakCore", "Rainbow", "SwiftCLI"]),
    ]
)
