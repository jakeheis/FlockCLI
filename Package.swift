import PackageDescription

let package = Package(
    name: "FlockCLI",
    dependencies: [
        .Package(url: "https://github.com/jakeheis/SwiftCLI", majorVersion: 3),
        .Package(url: "https://github.com/onevcat/Rainbow", majorVersion: 2, minor: 0),
        .Package(url: "https://github.com/kylef/PathKit", majorVersion: 0, minor: 7),
        .Package(url: "https://github.com/jakeheis/Spawn", majorVersion: 0, minor: 0)
    ]
)
