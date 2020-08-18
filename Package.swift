// swift-tools-version:5.1

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
            targets: ["Storage", "SecureUserDefault", "Singleton", "Keychain", "Inject"]
        ),
        .library(
            name: "Storage",
            targets: ["Storage"]
        ),
        .library(
            name: "SecureUserDefault",
            targets: ["Storage", "SecureUserDefault"]
        ),
        .library(
            name: "Singleton",
            targets: ["Storage", "Singleton"]
        ),
        .library(
            name: "Keychain",
            targets: ["Storage", "Keychain"]
        ),
        .library(
            name: "Inject",
            targets: ["Storage", "Inject"]
        ),
        .library(
            name: "SecurePropertyStorageDynamic",
            type: .dynamic,
            targets: ["Storage", "SecureUserDefault", "Singleton", "Keychain", "Inject"]
        ),
        .library(
            name: "StorageDynamic",
            type: .dynamic,
            targets: ["Storage"]
        ),
        .library(
            name: "UserDefaultDynamic",
            type: .dynamic,
            targets: ["Storage", "SecureUserDefault"]
        ),
        .library(
            name: "SingletonDynamic",
            type: .dynamic,
            targets: ["Storage", "Singleton"]
        ),
        .library(
            name: "KeychainDynamic",
            type: .dynamic,
            targets: ["Storage", "Keychain"]
        ),
        .library(
            name: "InjectDynamic",
            type: .dynamic,
            targets: ["Storage", "Inject"]
        )
    ],
    targets: [
        .target(
            name: "Storage"),
        .target(
            name: "SecureUserDefault",
            dependencies: ["Storage", "Keychain"]
        ),
        .target(
            name: "Singleton",
            dependencies: ["Storage", "Keychain"]
        ),
        .target(
            name: "Keychain",
            dependencies: ["Storage"]
        ),
        .target(
            name: "Inject",
            dependencies: ["Storage"]
        ),
        .testTarget(
            name: "SecurePropertyStorageTests",
            dependencies: ["Storage", "SecureUserDefault", "Singleton", "Keychain", "Inject"]
        )
    ]
)
