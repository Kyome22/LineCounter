// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "LineCounter",
    platforms: [
        .macOS(.v10_15)
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
        .package(
            name: "swift-argument-parser",
            url: "https://github.com/apple/swift-argument-parser.git",
            from: "1.0.3"
        )
    ],
    targets: [
        .executableTarget(
            name: "lc",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "LineCounterFramework"
            ]
        ),
        .target(
            name: "LineCounterFramework"
        ),
        .testTarget(
            name: "LineCounterFrameworkTests",
            dependencies: ["LineCounterFramework"]
        )
    ]
)
