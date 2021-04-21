// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LineCounter",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .executable(name: "lc", targets: ["LineCounter"])
    ],
    targets: [
        .target(
            name: "LineCounter",
            dependencies: []),
        .testTarget(
            name: "LineCounterTests",
            dependencies: ["LineCounter"]),
    ]
)
