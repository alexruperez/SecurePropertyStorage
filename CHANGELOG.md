# Change Log

## Next Version

#### Added
- Configurable Symmetric Key Naming. [#31](https://github.com/alexruperez/SecurePropertyStorage/pull/31) Thanks [@nuomi1](https://github.com/nuomi1)!

#### Improvements
- visionOS Compatible.
- Swift Package Manager tools version update to 5.9
- Xcode version update to 15.4

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
- [Register](https://github.com/alexruperez/SecurePropertyStorage/blob/master/README.md#-dependency-injection-usage) dependencies on error closure.
- More information in [InjectError](http://github.alexruperez.com/SecurePropertyStorage/Enums/InjectError.html).

#### Improvements

- Swift Package Manager tools version update to 5.5

[Commits](https://github.com/alexruperez/SecurePropertyStorage/compare/0.5.0...0.6.0)

## 0.5.0

#### Added
- Dependency Injection [Groups](https://github.com/alexruperez/SecurePropertyStorage/blob/master/README.md#-dependency-injection-usage).
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
