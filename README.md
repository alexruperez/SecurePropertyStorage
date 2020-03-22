# 🎁 PropertyWrappers
> Helps you define storages for your properties using Swift *property wrappers*.

[![Twitter](https://img.shields.io/badge/contact-%40alexruperez-blue)](http://twitter.com/alexruperez)
[![Swift](https://img.shields.io/badge/swift-5-orange)](https://swift.org)
[![License](https://img.shields.io/github/license/alexruperez/PropertyWrappers)](LICENSE)
[![Build Status](https://travis-ci.com/alexruperez/PropertyWrappers.svg?branch=master)](https://travis-ci.com/alexruperez/PropertyWrappers)
[![Coverage](https://img.shields.io/codecov/c/github/alexruperez/PropertyWrappers)](https://codecov.io/gh/alexruperez/PropertyWrappers)

## 🌟 Features

All keys are hashed using [SHA512](https://en.wikipedia.org/wiki/SHA-2) and all values are encrypted using [AES](https://en.wikipedia.org/wiki/Advanced_Encryption_Standard)-[GCM](https://en.wikipedia.org/wiki/Galois/Counter_Mode) to keep user information safe, auto*magic*ally. Symmetric key and nonce, are stored in Keychain in a totally secure way.

### @UserDefault

This property wrapper will store your property in UserDefaults using `StoreKey` (any `String` but i recommend you a String typed enum).

```swift
@UserDefault(<#StoreKey#>) var yourProperty: YourType?
```

`UserDefaultsStorage` is also available, a subclass of `UserDefaults` with all the security provided by this library.

### @Keychain

This property wrapper will store your property in Keychain using `StoreKey`.

```swift
@Keychain(<#StoreKey#>) var yourProperty: YourType?
```

As `UserDefaultsStorage`, `KeychainStorage` is also available.

### @Singleton

This property wrapper will store your property in a memory singleton,  every property with the same wrapper and key can access or modify the value from wherever it is.

```swift
@Singleton(<#StoreKey#>) var yourProperty: YourType?
```

As `KeychainStorage`, `SingletonStorage` is also available.

### @Store

This is a custom wrapper, you can define your own `Storage` protocol implementation.

```swift
@Store(<#Storage#>, <#StoreKey#>) var yourProperty: YourType?
```

As `SingletonStorage`, `DelegatedStorage` is also available with all the magic of this library.

## 🛠 Compatibility

- macOS 10.15+
- iOS 13.0+
- tvOS 13.0+
- watchOS 6.0+

## ⚙️ Installation

You can use the [Swift Package Manager](https://github.com/apple/swift-package-manager) by declaring PropertyWrappers as a dependency in your `Package.swift` file:

```swift
.package(url: "https://github.com/alexruperez/PropertyWrappers", from: "0.1.0")
```

You have a series of products that you can choose:

- **PropertyWrappers**: All property wrappers, by default.
- **UserDefault**: @UserDefault property wrapper.
- **Keychain**: @Keychain property wrapper.
- **Singleton**: @Singleton property wrapper.
- **Storage**: @Store property wrapper.

*For more information, see [the Swift Package Manager documentation](https://github.com/apple/swift-package-manager/tree/master/Documentation).*

## 👨‍💻 Author

Alex Rupérez – [@alexruperez](https://twitter.com/alexruperez) – contact@alexruperez.com
