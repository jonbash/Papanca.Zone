// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "PapancaZone",
    platforms: [.macOS(.v10_15)],
    products: [
        .executable(
            name: "PapancaZone",
            targets: ["PapancaZone"]
        )
    ],
    dependencies: [
        .package(name: "Publish", url: "https://github.com/johnsundell/publish.git", from: "0.6.0")
    ],
    targets: [
        .target(
            name: "PapancaZone",
            dependencies: ["Publish"]
        )
    ]
)
