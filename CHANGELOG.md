# Change Log

## Next Version

## 0.9.0

#### ⚠️ Breaking changes
- Minimum deployment targets raised: **iOS 15.0** (was 13.0), **macOS 12.0** (was 11.5), **tvOS 15.0** (was 13.0), **watchOS 9.0** (was 6.0). visionOS 1.0 is unchanged.
  Projects that need older OS versions must stay on `0.8.2`.
- There are **no public API changes**.

#### Improvements
- Xcode 27.1 / Swift 6.4 compatibility; the Xcode project now builds in Swift 6 language mode (`SWIFT_VERSION = 6.0`), matching `Package.swift`.
- Replaced the deprecated `NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(_:)` in `DelegatedStorage.object(forKey:)` with the non-deprecated unarchiver API, keeping the same behavior (archived `NSCoding` objects keep decoding). The library now builds without deprecation warnings.
- Added GitHub Actions CI (`.github/workflows/ci.yml`) on the `xcode-27` runner image using Xcode 27.1: SwiftPM resolve + clean build + tests on macOS, tests on iPhone 17 Simulator (iOS 27.0), build checks for macOS, Mac Catalyst, iOS, tvOS, watchOS and visionOS, and an external-consumer integration check. Added Dependabot for the workflow actions.

#### Tests
- `swift test` compiles and runs again with Swift 6 (it failed to compile before): test classes are isolated to `@StorageActor`, expectations use `fulfillment(of:)`, and the non-isolated `allTests` lists were removed.
- Removed the dead Linux scaffolding (`Tests/LinuxMain.swift`, `XCTestManifests.swift`), which referenced a non-existent module and is not used by SwiftPM on current toolchains.
- Added `StorageTests` (18 tests): primitive/codable/`NSCoding` round trips, missing keys, removal, `register(defaults:)`, key hashing and value encryption, wrong key / authentication tag errors, corrupted data, `DataConvertible` edge cases and `SymmetricKey` round trip. Total: 56 tests.

#### Documentation
- Clarify that `SingletonStorageDelegate` uses in-memory storage. [#42](https://github.com/alexruperez/SecurePropertyStorage/pull/42) Thanks [@dajiaohuang](https://github.com/dajiaohuang)!

#### Tooling
- Disabled the `wrapPropertyBodies`, `wrapFunctionBodies`, `blankLinesBetweenScopes` and `wrapArguments` SwiftFormat rules, which newer SwiftFormat versions flag on the existing code style.

[Commits](https://github.com/alexruperez/SecurePropertyStorage/compare/0.8.2...0.9.0)

## 0.8.2

#### Fixed
- Make StorageActor.shared immutable. [#41](https://github.com/alexruperez/SecurePropertyStorage/pull/41) Thanks [@dineshvijaykumar
](https://github.com/dineshvijaykumar
)!

[Commits](https://github.com/alexruperez/SecurePropertyStorage/compare/0.8.1...0.8.2)

## 0.8.1

#### Improvements
- Fix ContiguousBytes.data memory issue (#39)
- Fix memory safety issue in ContiguousBytes data extension
- Updated Jazzy.
- Ensure thread-safe access to grouped dependencies in Inject module. (#38)
- Ensure thread-safe access to grouped dependencies in Inject module.
- I've made some enhancements to improve Sendable conformance, documentation.
- I updated example classes in InjectTests.swift to conform to Sendable.
- I added a new section to README.md explaining Sendable requirements for concurrent safety.

[Commits](https://github.com/alexruperez/SecurePropertyStorage/compare/0.8.0...0.8.1)

## 0.8.0

#### Added
- Configurable Symmetric Key Naming. [#31](https://github.com/alexruperez/SecurePropertyStorage/pull/31) Thanks [@nuomi1](https://github.com/nuomi1)!

#### Fixed
- Fixed concurrency issues in Swift 6. [#30](https://github.com/alexruperez/SecurePropertyStorage/issues/30) Thanks [Manu-Globant](https://github.com/Manu-Globant)!

#### Improvements
- visionOS Compatible.
- Swift Package Manager tools version update to 6.0
- Xcode version update to 16.0
- macOS Deployment Target update to 11.5

[Commits](https://github.com/alexruperez/SecurePropertyStorage/compare/0.7.1...0.8.0)

## 0.7.1

#### Fixed
- `kSecReturnAttributes` nil by default. [#27](https://github.com/alexruperez/SecurePropertyStorage/issues/27) Thanks [@davidknight-seequent](https://github.com/davidknight-seequent)!

[Commits](https://github.com/alexruperez/SecurePropertyStorage/compare/0.7.0...0.7.1)

## 0.7.0

#### Added
- Customizable `kSecClass`.
- `kSecReturnAttributes` by default.

[Commits](https://github.com/alexruperez/SecurePropertyStorage/compare/0.6.0...0.7.0)

## 0.6.0 (In memory of my friend **[Haldo Spontón](https://linktr.ee/haldosponton)**. Rest in peace. 😢)

#### Added
- [Register](https://github.com/alexruperez/SecurePropertyStorage/blob/main/README.md#-dependency-injection-usage) dependencies on error closure.
- More information in [InjectError](http://github.alexruperez.com/SecurePropertyStorage/Enums/InjectError.html).

#### Improvements

- Swift Package Manager tools version update to 5.5

[Commits](https://github.com/alexruperez/SecurePropertyStorage/compare/0.5.0...0.6.0)

## 0.5.0

#### Added
- Dependency Injection [Groups](https://github.com/alexruperez/SecurePropertyStorage/blob/main/README.md#-dependency-injection-usage).
- [Set](https://developer.apple.com/documentation/swift/set) support.

[Commits](https://github.com/alexruperez/SecurePropertyStorage/compare/0.4.2...0.5.0)

## 0.4.2

#### Fixed
- Carthage compatible fix. [#20](https://github.com/alexruperez/SecurePropertyStorage/pull/20) Thanks [@AlbGarciam](https://github.com/AlbGarciam)!

#### Improvements

- Swift Package Manager tools version update to 5.3

[Commits](https://github.com/alexruperez/SecurePropertyStorage/compare/0.4.1...0.4.2)

## 0.4.1

#### Fixed
- `Unwrapped` always return defaultValue after restart app. [#15](https://github.com/alexruperez/SecurePropertyStorage/issues/15) Thanks [@qchenqizhi](https://github.com/qchenqizhi)!

[Commits](https://github.com/alexruperez/SecurePropertyStorage/compare/0.4.0...0.4.1)

## 0.4.0 (**SECURITY UPDATE!**)

#### Fixed
- Nonce [shouldn't be reused](https://www.elttam.com/blog/key-recovery-attacks-on-gcm). [#13](https://github.com/alexruperez/SecurePropertyStorage/issues/13) Thanks [@shphilippe](https://github.com/shphilippe)!

[Commits](https://github.com/alexruperez/SecurePropertyStorage/compare/0.3.2...0.4.0)

## 0.3.2

#### Fixed
- Xcode 12.

[Commits](https://github.com/alexruperez/SecurePropertyStorage/compare/0.3.1...0.3.2)

## 0.3.1

#### Added
- Register builder closures.
- Register builder closures with parameters.
- `@InjectWith` and `@UnwrappedInjectWith` parameters property wrappers. [#6](https://github.com/alexruperez/SecurePropertyStorage/pull/6)
- Instance inject scope.
- Mock qualifier for testing.
- `KeychainStorage` access, group and synchronizable properties. Thanks for the feedback [@JesusAntonioGil](https://github.com/JesusAntonioGil)!

#### Fixed
- Strong typing on non-`@Store` property wrappers to avoid mixing. Thanks for the feedback [@JesusAntonioGil](https://github.com/JesusAntonioGil)!

[Commits](https://github.com/alexruperez/SecurePropertyStorage/compare/0.3.0...0.3.1)

## 0.3.0

#### Added
- Added `@Inject`, `@UnwrappedInject` and `@Register` property wrappers for dependency injection with qualifiers. [#4](https://github.com/alexruperez/SecurePropertyStorage/pull/4)

[Commits](https://github.com/alexruperez/SecurePropertyStorage/compare/0.2.0...0.3.0)

## 0.2.0

#### Added
- Added `Codable` and `Unwrapped` property wrapper variations. [#3](https://github.com/alexruperez/SecurePropertyStorage/pull/3) Thanks for the feedback [@th-mustache-dk](https://github.com/th-mustache-dk)!

[Commits](https://github.com/alexruperez/SecurePropertyStorage/compare/0.1.3...0.2.0)

## 0.1.3

#### Fixed
- `KeychainStorage` and `SingletonStorage` returns their own type in `standard` class var.

[Commits](https://github.com/alexruperez/SecurePropertyStorage/compare/0.1.2...0.1.3)

## 0.1.2

#### Changes
- Renamed to SecurePropertyStorage.

[Commits](https://github.com/alexruperez/SecurePropertyStorage/compare/0.1.1...0.1.2)

## 0.1.1

#### Added
- Carthage compatible.

[Commits](https://github.com/alexruperez/SecurePropertyStorage/compare/0.1.0...0.1.1)

## 0.1.0
First official release
