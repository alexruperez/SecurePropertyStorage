// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "SecurePropertyStorage",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "SecurePropertyStorage",
            targets: ["SecureStorage", "SecureUserDefault", "SecureSingleton", "SecureKeychain", "SecureInject"]
        ),
        .library(
            name: "SecureStorage",
            targets: ["SecureStorage"]
        ),
        .library(
            name: "SecureUserDefault",
            targets: ["SecureStorage", "SecureUserDefault"]
        ),
        .library(
            name: "SecureSingleton",
            targets: ["SecureStorage", "SecureSingleton"]
        ),
        .library(
            name: "SecureKeychain",
            targets: ["SecureStorage", "SecureKeychain"]
        ),
        .library(
            name: "SecureInject",
            targets: ["SecureStorage", "SecureInject"]
        ),
        .library(
            name: "SecurePropertyStorageDynamic",
            type: .dynamic,
            targets: ["SecureStorage", "SecureUserDefault", "SecureSingleton", "SecureKeychain", "SecureInject"]
        ),
        .library(
            name: "SecureStorageDynamic",
            type: .dynamic,
            targets: ["SecureStorage"]
        ),
        .library(
            name: "SecureUserDefaultDynamic",
            type: .dynamic,
            targets: ["SecureStorage", "SecureUserDefault"]
        ),
        .library(
            name: "SecureSingletonDynamic",
            type: .dynamic,
            targets: ["SecureStorage", "SecureSingleton"]
        ),
        .library(
            name: "SecureKeychainDynamic",
            type: .dynamic,
            targets: ["SecureStorage", "SecureKeychain"]
        ),
        .library(
            name: "SecureInjectDynamic",
            type: .dynamic,
            targets: ["SecureStorage", "SecureInject"]
        )
    ],
    targets: [
        .target(
            name: "SecureStorage"),
        .target(
            name: "SecureUserDefault",
            dependencies: ["SecureStorage", "SecureKeychain"]
        ),
        .target(
            name: "SecureSingleton",
            dependencies: ["SecureStorage", "SecureKeychain"]
        ),
        .target(
            name: "SecureKeychain",
            dependencies: ["SecureStorage"]
        ),
        .target(
            name: "SecureInject",
            dependencies: ["SecureStorage"]
        ),
        .testTarget(
            name: "SecurePropertyStorageTests",
            dependencies: ["SecureStorage", "SecureUserDefault", "SecureSingleton", "SecureKeychain", "SecureInject"]
        )
    ]
)
