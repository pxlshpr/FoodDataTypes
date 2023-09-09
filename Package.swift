// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FoodDataTypes",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "FoodDataTypes",
            targets: ["FoodDataTypes"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pxlshpr/SwiftSugar", from: "0.0.97"),
        .package(url: "https://github.com/pxlshpr/VisionSugar", from: "0.0.80"),
        .package(url: "https://github.com/pxlshpr/ColorSugar", from: "0.0.8"),
        .package(url: "https://github.com/marmelroy/Zip", from: "2.1.2"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "FoodDataTypes",
            dependencies: [
                .product(name: "SwiftSugar", package: "SwiftSugar"),
                .product(name: "VisionSugar", package: "VisionSugar"),
                .product(name: "ColorSugar", package: "ColorSugar"),
                .product(name: "Zip", package: "Zip"),
            ]
        ),
        .testTarget(
            name: "FoodDataTypesTests",
            dependencies: ["FoodDataTypes"]),
    ]
)
