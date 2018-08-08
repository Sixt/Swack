// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "Swack",
    products: [
        .library(
            name: "Swack",
            targets: ["Swack"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),
    ],
    targets: [
        .target(name: "Swack", dependencies: ["Vapor"]),
        .testTarget(name: "SwackTests", dependencies: ["Swack"])
    ]
)

