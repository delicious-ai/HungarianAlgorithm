// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HungarianAlgorithm",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "HungarianAlgorithm",
            targets: ["HungarianAlgorithm"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/AlexanderTar/LASwift",
            .upToNextMajor(from: "0.3.2")
        ),
    ],
    targets: [
        .target(
            name: "HungarianAlgorithm",
            dependencies: [
                .product(name: "LASwift", package: "laswift"),
            ]),
        .testTarget(
            name: "HungarianAlgorithmTests",
            dependencies: ["HungarianAlgorithm"]),
    ]
)
