// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SplatNet3",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "SplatNet3",
            targets: ["SplatNet3"]),
        .library(
            name: "SplatNet3API",
            targets: ["SplatNet3API"]),
        .library(
            name: "SplatNet3Helper",
            targets: ["SplatNet3Helper"]),
        .executable(
            name: "sn3",
            targets: ["SplatNet3CLI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/imink-app/InkMoya.git", .upToNextMinor(from: "0.1.0")),
        .package(url: "https://github.com/scinfu/SwiftSoup.git", from: "2.4.3"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "SplatNet3",
            dependencies: []),
        .target(
            name: "SplatNet3API",
            dependencies: [
                "SplatNet3", 
                "SplatNet3Helper",
                .product(name: "InkMoya", package: "InkMoya"),
                ],
            resources: [.copy("SampleData")]),
        .target(name: "SplatNet3Helper",
            dependencies: [
                .product(name: "InkMoya", package: "InkMoya"),
                .product(name: "SwiftSoup", package: "SwiftSoup"),
                ]),
        .executableTarget(
            name: "SplatNet3CLI",
            dependencies: [
                "SplatNet3Helper",
                .product(name: "InkMoya", package: "InkMoya"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]),
        .testTarget(
            name: "SplatNet3Tests",
            dependencies: ["SplatNet3", "SplatNet3API", "SplatNet3Helper"]),
    ]
)
