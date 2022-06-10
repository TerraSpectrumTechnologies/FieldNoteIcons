// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FieldNoteIcons",
    platforms: [.iOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "FieldNoteIcons",
            targets: ["FieldNoteIcons"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/exyte/Macaw", from: "0.9.10"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "FieldNoteIcons",
            dependencies: [.product(name: "Macaw", package: "Macaw")]),
        .testTarget(
            name: "FieldNoteIconsTests",
            dependencies: ["FieldNoteIcons"]),
    ]
)