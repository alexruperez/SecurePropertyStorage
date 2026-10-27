# 🔐 Secure Property Storage
> Helps you define secure storages for your properties using Swift *property wrappers*.

[![Twitter](https://img.shields.io/badge/me-%40alexruperez-blue)](http://alexruperez.com)
[![CI](https://github.com/alexruperez/SecurePropertyStorage/actions/workflows/ci.yml/badge.svg)](https://github.com/alexruperez/SecurePropertyStorage/actions/workflows/ci.yml)
[![Swift](https://img.shields.io/badge/swift-6-orange)](https://swift.org)
[![License](https://img.shields.io/github/license/alexruperez/SecurePropertyStorage)](LICENSE)
[![Swift Package Manager](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-4BC51D.svg?style=flat)](https://swift.org/package-manager)
[![Carthage](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Bitrise](https://app.bitrise.io/app/4fed1af31836d3bc/status.svg?token=bYImtoKj0hxqCxnORhdgyg&branch=master)](https://app.bitrise.io/app/4fed1af31836d3bc)
[![Maintainability](https://api.codeclimate.com/v1/badges/bbf38ddca9a26703cefd/maintainability)](https://codeclimate.com/github/alexruperez/SecurePropertyStorage/maintainability)
[![codecov](https://codecov.io/gh/alexruperez/SecurePropertyStorage/graph/badge.svg?token=T3NNtLnmsA)](https://codecov.io/gh/alexruperez/SecurePropertyStorage)
[![Quality](https://api.codacy.com/project/badge/Grade/53a23dd2feca4b7ca8357c918c7d49c9)](https://app.codacy.com/gh/alexruperez/SecurePropertyStorage/dashboard)

## 🌟 Features

All keys are hashed using [SHA512](https://en.wikipedia.org/wiki/SHA-2) and all values are encrypted using [AES](https://en.wikipedia.org/wiki/Advanced_Encryption_Standard)-[GCM](https://en.wikipedia.org/wiki/Galois/Counter_Mode) to keep user information safe, auto*magic*ally.
Symmetric key is stored in Keychain in a totally secure way.

## 🐒 Basic usage

### @UserDefault

This property wrapper will store your property in [UserDefaults](https://developer.apple.com/documentation/foundation/userdefaults) using `StoreKey` (any `String` but i recommend you a String typed enum).
Optionally, you can assign a default value to the property that will be secure stored at initialization.

```swift
@UserDefault(<#StoreKey#>)
var yourProperty: YourType? = yourDefaultValueIfNeeded
```

[`UserDefaultsStorage`](Sources/UserDefault/UserDefaultsStorage.swift) is also available, a subclass of [`UserDefaults`](https://developer.apple.com/documentation/foundation/userdefaults) with all the security provided by this library, where you can customize suite name.

### @Keychain

This property wrapper will store your property in [Keychain](https://developer.apple.com/documentation/security/keychain_services) using `StoreKey`.

```swift
@Keychain(<#StoreKey#>)
var yourProperty: YourType? = yourDefaultValueIfNeeded
```

As `UserDefaultsStorage`, [`KeychainStorage`](Sources/Keychain/KeychainStorage.swift) is also available, where you can customize access, group and synchronize it with iCloud.

### @Singleton

This property wrapper will store your property in a memory [singleton](https://en.wikipedia.org/wiki/Singleton_pattern),  every property with the same wrapper and key can access or modify the value from wherever it is.

```swift
@Singleton(<#StoreKey#>)
var yourProperty: YourType? = yourDefaultValueIfNeeded
```

As `KeychainStorage`, [`SingletonStorage`](Sources/Singleton/SingletonStorage.swift) is also available.

### @Inject

This property wrapper is similar to `@Singleton` but, together with `@Register`, will inject your dependencies. More details in [Dependency Injection usage](#-dependency-injection-usage) guide.

```swift
@Inject
var yourDependency: YourProtocol?
```

As `SingletonStorage`, [`InjectStorage`](Sources/Inject/InjectStorage.swift) is also available.

### @Store

This is a custom wrapper, you can define your own [`Storage`](Sources/Storage/Storage.swift) protocol implementation.

```swift
@Store(<#YourStorage#>, <#StoreKey#>)
var yourProperty: YourType? = yourDefaultValueIfNeeded
```

As `InjectStorage`, [`DelegatedStorage`](Sources/Storage/DelegatedStorage.swift) is also available with all the magic of this library.

## 🧙‍♂️ Codable usage

If your property conforms [`Codable`](https://developer.apple.com/documentation/swift/codable) protocol, just add `Codable` keyword as prefix of your property wrapper.

- **@CodableUserDefault**
- **@CodableKeychain**
- **@CodableSingleton**
- **@CodableStore**

## 🥡 Unwrapped usage

To avoid continually unwrapping your property, just add `Unwrapped` keyword as prefix of your property wrapper, assign a default value (mandatory except for `@UnwrappedInject`), and it will return stored value or default value, but your property will always be there for you.

- **@UnwrappedUserDefault**
- **@UnwrappedKeychain**
- **@UnwrappedSingleton**
- **@UnwrappedInject**
- **@UnwrappedStore**

## 🥡 + 🧙‍♂️ Combo usage

You can also combine previous cases in case you need it, unwrapped first please.

- **@UnwrappedCodableUserDefault**
- **@UnwrappedCodableKeychain**
- **@UnwrappedCodableSingleton**
- **@UnwrappedCodableStore**

## 💉 Dependency Injection usage

<details>
<summary><b>@Register</b> (<i>click to expand</i>)</summary>

This property wrapper will register the implementations of your dependencies.
Register them wherever you want before inject it, but be sure to do it only once (except if you use qualifiers), for example, in an `Injector` class.
You can register through a protocol or directly using your class implementation.

```swift
@Register
var yourDependency: YourProtocol = YourImplementation()

@Register
var yourDependency = YourImplementation()
```

You can also define a closure that builds your dependency.
Just remember cast your dependency if you are going to inject it through a protocol.

```swift
@Register
var yourDependency = {
    YourImplementation() as YourProtocol
}

@Register
var yourDependency = {
    YourImplementation()
}
```

You can also register your dependencies only after the moment someone tries to inject them and you haven't registered them yet,
for this you can use the error closure.

```swift
InjectStorage.standard.errorClosure = { error in
    if case InjectError.notFound = error {
        YourImplementation.register()
    }
}
```

You can get this syntactic sugar because you can now use property wrappers in function parameters.

```swift
static func register(@Register yourDependency: YourProtocol = YourImplementation()) {}
```

</details>

<details>
<summary><b>@Inject</b> and <b>@UnwrappedInject</b> (<i>click to expand</i>)</summary>

These property wrappers injects your dependencies `@Register` implementations.

```swift
@Inject
var yourDependency: YourProtocol?

@Inject
var yourDependency: YourImplementation?

@UnwrappedInject
var yourUnwrappedDependency: YourProtocol

@UnwrappedInject
var yourUnwrappedDependency: YourImplementation
```

#### Scope

Because these property wrappers works similarly to `@Singleton`, the default scope is `.singleton`, but if you use builder closures on `@Register`, you can modify them to inject a single instance.

```swift
@Inject(.instance)
var yourDependency: YourProtocol?

@UnwrappedInject(.instance)
var yourUnwrappedDependency: YourProtocol
```
</details>

<details>
<summary><b>@InjectWith</b> and <b>@UnwrappedInjectWith</b> (<i>click to expand</i>)</summary>

Your dependency may need parameters when injecting, you can pass them with these property wrappers.
Simply define a model with your dependency parameters  and pass it.
It will inject a new instance built with these parameters.

```swift
@Register
var yourDependency = { parameters in
    YourImplementation(parameters) as YourProtocol
}

@Inject(YourParameters())
var yourDependency: YourProtocol?

@UnwrappedInject(YourParameters())
var yourUnwrappedDependency: YourProtocol
```
</details>

<details>
<summary><b>Qualifiers</b> (<i>click to expand</i>)</summary>

You can use [qualifiers](https://javaee.github.io/tutorial/cdi-basic006.html) to provide various implementations of a particular dependency. A qualifier is just a `@objc protocol` that you apply to a `class`.

For example, you could declare `Dog` and `Cat` qualifier protocols and apply it to another class that conforms `Animal` protocol. To declare this qualifier, use the following code:

```swift
protocol Animal {
  func sound()
}

@objc protocol Dog {}

@objc protocol Cat {}
```

You can then define multiple classes that conforms `Animal` protocol and uses this qualifiers:

```swift
class DogImplementation: Animal, Dog {
    func sound() { print("Woof!") }
}

class CatImplementation: Animal, Cat {
    func sound() { print("Meow!") }
}
```

Both implementations of the class can now be `@Register`:

```swift
@Register
var registerDog: Animal = DogImplementation()

@Register
var registerCat: Animal = CatImplementation()
```

To inject one or the other implementation, simply add the qualifier(s) to your `@Inject`:

```swift
@UnwrappedInject(Dog.self)
var dog: Animal

@UnwrappedInject(Cat.self)
var cat: Animal

dog.sound() // prints Woof!
cat.sound() // prints Meow!
```
</details>

<details>
<summary><b>Testing</b> (<i>click to expand</i>)</summary>

One of the advantages of dependency injection is that the code can be easily testable with mock implementation.
That is why there is a `Mock` qualifier that has priority over all, so you can have your dependencies defined in the app and create your mock in the test target simply by adding this qualifier.

```swift
// App target

class YourImplementation: YourProtocol {}

@Register
var yourDependency: YourProtocol = YourImplementation()

@Inject
var yourDependency: YourProtocol?
```

```swift
// Test target

class YourMock: YourProtocol, Mock {}

@Register
var yourDependency: YourProtocol = YourMock()
```
</details>

<details>
<summary><b>Groups</b> (<i>click to expand</i>)</summary>

When you have **a lot** of dependencies in your app, you may want to optimize dependency resolution.

You can group them using `@Register(group:)` and a `DependencyGroupKey`:

```swift
@Register(group: <#DependencyGroupKey#>)
var yourDependency: YourProtocol = YourImplementation()
```

`@Inject(group:)` will look for those dependencies only in that group:

```swift
@Inject(group: <#DependencyGroupKey#>)
var yourDependency: YourProtocol?
```
</details>

## 🔒 Concurrency and `Sendable`

This library is designed with Swift's modern concurrency features in mind. Access to the underlying storage mechanisms (UserDefaults, Keychain, etc.) is serialized through a global actor (`StorageActor`), preventing data races during read and write operations performed by the library itself.

However, for your application to be fully concurrency-safe when using this library, it is crucial that **the types you store and retrieve are `Sendable`**.

*   **Generic Types**: When using generic property wrappers or methods like `@Store var item: MyType?`, `storage.value(forKey: "key") as? MyType`, or `storage.decodable(forKey: "key") as? MyDecodableType`, ensure that `MyType` and `MyDecodableType` conform to the `Sendable` protocol.
*   **Object Archiving**: If you use methods that rely on `NSKeyedArchiver` (such as `storage.set(object: myNSObject, forKey: "key")`), the class `myNSObject` should conform to `NSSecureCoding` for security and also be `Sendable` for concurrency safety.
*   **Why is `Sendable` important?**: While the library ensures that the act of storing or retrieving data is safe, if the data itself (e.g., a class instance) is not `Sendable`, then passing it across different concurrent tasks or actors after retrieval can lead to data races if the data is mutable. Conforming to `Sendable` helps Swift enforce that such types can be safely shared.

Enabling strict concurrency checking in your project's build settings (e.g., "Strict Concurrency Checking" set to "Complete" in Xcode) is highly recommended to help identify potential concurrency issues at compile time.


## 👀 Examples

> Talk is cheap. Show me the code.

```swift
    // Securely stored in UserDefaults.
    @UserDefault("username")
    var username: String?

    // Securely stored in Keychain.
    @Keychain("password")
    var password: String?

    // Securely stored in a Singleton storage.
    @Singleton("sessionToken")
    var sessionToken: String?

    // Securely stored in a Singleton storage.
    // Always has a value, the stored or the default.
    @UnwrappedSingleton("refreshToken")
    var refreshToken: String = "B0610306-A33F"

    struct User: Codable {
        let username: String
        let password: String?
        let sessionToken: String?
    }

    // Codable model securely stored in UserDefaults.
    @CodableUserDefault("user")
    var user: User?
```

## 🛠 Compatibility

| Platform | Minimum deployment target |
|---|---|
| iOS / iPadOS | 15.0 |
| macOS | 12.0 |
| tvOS | 15.0 |
| watchOS | 9.0 |
| visionOS | 1.0 |

- Developed and tested with **Xcode 27.1** and **Swift 6.4** (`swift-tools-version:6.0`, Swift 6 language mode).
- Mac Catalyst builds are supported as well.
- Continuous integration (see [`.github/workflows/ci.yml`](.github/workflows/ci.yml)) runs the full test suite on an **iPhone 17 Simulator (iOS 27.0)** and on macOS (`swift test`),
  and verifies that the package builds for macOS, Mac Catalyst, iOS, tvOS, watchOS and visionOS and that it can be consumed as an external Swift Package.
- tvOS, watchOS and visionOS are **compile-verified only**: the test suite is not executed on those platforms.
- If you need to support older OS versions, use the previous releases (`0.8.2` supports iOS 13, macOS 11.5, tvOS 13 and watchOS 6).

## ⚙️ Installation

#### You can use the [Swift Package Manager](https://github.com/apple/swift-package-manager) by declaring SecurePropertyStorage as a dependency in your `Package.swift` file:

```swift
.package(url: "https://github.com/alexruperez/SecurePropertyStorage", from: "0.8.2")
```

By default, all property wrappers are installed and you can `import` them, but if you want, you can install only some of them:

- **UserDefault**: @*UserDefault property wrappers.
- **Keychain**: @*Keychain property wrappers.
- **Singleton**: @*Singleton property wrappers.
- **Storage**: @*Store property wrappers.
- **Inject**: @*Inject property wrappers.

Then add the products you need to your target dependencies:

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "SecurePropertyStorage", package: "SecurePropertyStorage")
        // or only some of them: "UserDefault", "Keychain", "Singleton", "Inject", "Storage"
    ]
)
```

In Xcode: **File ▸ Add Package Dependencies…** and enter `https://github.com/alexruperez/SecurePropertyStorage`.

*For more information, see [the Swift Package Manager documentation](https://github.com/apple/swift-package-manager/tree/master/Documentation).*

#### Or you can use [Carthage](https://github.com/Carthage/Carthage):

```ogdl
github "alexruperez/SecurePropertyStorage"
```

## 🧪 Development

```bash
swift build                      # Build all targets
swift test                       # Run the test suite on macOS

# Run the test suite on the iPhone 17 Simulator (iOS 27.0), as the CI does
xcodebuild test \
  -project SecurePropertyStorage.xcodeproj \
  -scheme SecurePropertyStorage-Package \
  -destination 'platform=iOS Simulator,name=iPhone 17,OS=27.0'

# Compile-check another platform
xcodebuild build \
  -project SecurePropertyStorage.xcodeproj \
  -scheme SecurePropertyStorage-Package \
  -destination 'generic/platform=watchOS Simulator'
```

Notes for contributors:

- Test classes are isolated to `@StorageActor` and their test methods are `async`, so XCTest runs them on that actor.
- The Keychain needs entitlements that are not available to `swift test` on macOS; the Keychain tests therefore assert the error path there.
  `StorageTests` use an in-memory delegate and cover the encryption logic deterministically.
- Please keep the public API source compatible and add a [CHANGELOG](CHANGELOG.md) entry for every user-facing change.

## 🍻 Etc.

- Featured in [Dave Verwer](https://twitter.com/daveverwer)'s iOS Dev Weekly - [Issue 450](https://iosdevweekly.com/issues/450?#ll98q5s), thanks Dave!
- Contributions are very welcome. Thanks [Alberto Garcia](https://github.com/AlbGarciam), [Manu](https://github.com/Manu-Globant) and [Chen](https://github.com/qchenqizhi)!
- Attribution is appreciated (let's spread the word!), but not mandatory.

## 👨‍💻 Author

Alex Rupérez – [@alexruperez](https://twitter.com/alexruperez)

## 👮‍♂️ License

*SecurePropertyStorage* is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
