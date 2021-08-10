// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LineCounter",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "LineCounterLibrary",
            targets: ["LineCounterLibrary"]
        ),
        .executable(
            name: "lc",
            targets: ["LineCounter"]
        )
    ],
    targets: [
        .target(
            name: "LineCounterLibrary",
            dependencies: []
        ),
        .target(
            name: "LineCounter",
            dependencies: ["LineCounterLibrary"]
        ),
        .testTarget(
            name: "LineCounterLibraryTests",
            dependencies: ["LineCounterLibrary"]
        )
    ]
)
