// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "GithubChecks",
    platforms: [
        .macOS(.v12),
    ],
    products: [
        .executable(name: "ghchecks", targets: [
            "GHCheckCommand",
        ]),
        .library(
            name: "GithubChecks",
            targets: ["GithubChecks"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.2"),
    ],
    targets: [
        .target(name: "GithubChecks"),
        .target(name: "Reports"),
        .executableTarget(
            name: "GHCheckCommand",
            dependencies: [
                "GithubChecks",
                "Reports",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]),
        .testTarget(
            name: "GithubChecksTests",
            dependencies: ["GithubChecks"]),
        .testTarget(
            name: "SummaryRendererTests",
            dependencies: ["GHCheckCommand"]),
    ]
)
