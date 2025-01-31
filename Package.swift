// swift-tools-version: 6.0

import PackageDescription

let swiftSettings: [SwiftSetting] = [
    .enableUpcomingFeature("ExistentialAny"),
]

let package = Package(
    name: "LineCounter",
    platforms: [
        .macOS(.v12),
    ],
    products: [
        .executable(
            name: "lc",
            targets: ["lc"]
        ),
        .library(
            name: "LineCounterFramework",
            targets: ["LineCounterFramework"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", exact: "1.5.0")
    ],
    targets: [
        .executableTarget(
            name: "lc",
            dependencies: [
                "LineCounterFramework",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        ),
        .target(
            name: "LineCounterFramework",
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "LineCounterFrameworkTests",
            dependencies: [.target(name: "LineCounterFramework")],
            resources: [.process("../../Sources")],
            swiftSettings: swiftSettings
        )
    ]
)
