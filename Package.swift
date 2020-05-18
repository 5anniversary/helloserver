// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "Hello",
    products: [
        .library(name: "Hello", targets: ["App"]),
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),

        .package(url: "https://github.com/vapor/fluent-mysql-driver.git",
                 from: "3.0.0"), // git 그리고 버전
        .package(url: "https://github.com/vapor/leaf.git", from: "3.0.0"),

    ],
    targets: [
        .target(name: "App", dependencies: ["Vapor","FluentMySQL","Leaf"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)

