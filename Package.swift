// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SplatNet3",
    products: [
        .library(
            name: "SplatNet3",
            targets: ["SplatNet3"]),
        .library(
            name: "SplatNet3API",
            targets: ["SplatNet3API"]),
    ],
    dependencies: [
        .package(url: "https://github.com/imink-app/InkMoya.git", branch: "main"),
        .package(url: "https://github.com/scinfu/SwiftSoup.git", from: "2.4.3"),
    ],
    targets: [
        .target(
            name: "SplatNet3",
            dependencies: []),
        .target(
            name: "SplatNet3API",
            dependencies: [
                "SplatNet3", 
                .product(name: "InkMoya", package: "InkMoya"),
                ],
            resources: [.copy("SampleData")]),
        .target(name: "SplatNet3Helper",
            dependencies: [
                "SplatNet3API",
                .product(name: "SwiftSoup", package: "SwiftSoup"),
                ]),
        .testTarget(
            name: "SplatNet3Tests",
            dependencies: ["SplatNet3", "SplatNet3API", "SplatNet3Helper"]),
    ]
)
