// swift-tools-version:4.0
//===----------------------------------------------------------------------===//
//
// This source file is part of the Swack open source project
//
// Copyright (c) 2018 e-Sixt
// Licensed under MIT
//
// See LICENSE.txt for license information
//
//===----------------------------------------------------------------------===//
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

