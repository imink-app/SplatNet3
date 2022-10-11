// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SplatNet3",
    products: [
        .library(
            name: "SplatNet3",
            targets: ["SplatNet3"]),
    ],
    targets: [
        .target(
            name: "SplatNet3",
            dependencies: []),
        .testTarget(
            name: "SplatNet3Tests",
            dependencies: ["SplatNet3"]),
    ]
)
