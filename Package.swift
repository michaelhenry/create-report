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
            targets: ["GithubChecks"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.1.2"),
        .package(url: "https://github.com/michaelhenry/SimpleXMLParser", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "GithubChecks",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]),
        .target(name: "Reports", dependencies: [
            .product(name: "SimpleXMLParser", package: "SimpleXMLParser"),
        ]),
        .executableTarget(
            name: "GHCheckCommand",
            dependencies: [
                "GithubChecks",
                "Reports",
            ]
        ),
        .testTarget(
            name: "GithubChecksTests",
            dependencies: [
                "GithubChecks",
            ]
        ),
        .testTarget(
            name: "SummaryRendererTests",
            dependencies: ["GHCheckCommand"]
        ),
    ]
)
