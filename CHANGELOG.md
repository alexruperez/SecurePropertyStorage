# Change Log

## Next Version

## 0.3.1

#### Added
- Register builder closures.
- Register builder closures with parameters.
- `@InjectWith` and `@UnwrappedInjectWith` parameters property wrappers. [#6](https://github.com/alexruperez/SecurePropertyStorage/pull/6)
- Instance inject scope.
- Mock qualifier for testing.
- `KeychainStorage` access group and synchronizable properties. Thanks for the feedback [@JesusAntonioGil](https://github.com/JesusAntonioGil)!

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
