import SecureStorage

/// `@Keychain` property wrapper.
@propertyWrapper
open class Keychain<Value>: StorePropertyWrapper<KeychainStorage> {
    /**
     Create a `Keychain` property wrapper.

     - Parameter key: `StoreKey` to store the value.
     */
    public convenience init(_ key: StoreKey) {
        self.init(KeychainStorage.standard, key)
    }

    /**
     Create a `Keychain` property wrapper.

     - Parameter wrappedValue: Default value.
     - Parameter key: `StoreKey` to store the value.
     */
    public convenience init(wrappedValue: Value?, _ key: StoreKey) {
        self.init(key)
        self.wrappedValue = wrappedValue
    }

    /// Property wrapper stored value.
    open var wrappedValue: Value? {
        get { storage.value(forKey: key) }
        set { storage.set(newValue, forKey: key) }
    }
}

/// `@UnwrappedKeychain` property wrapper.
@propertyWrapper
open class UnwrappedKeychain<Value>: StorePropertyWrapperProtocol {
    /// `Storage` used by property wrapper.
    open var storage: KeychainStorage
    /// `StoreKey` to store the value.
    open var key: StoreKey
    /// Default value.
    open var defaultValue: Value

    /**
     Create a `UnwrappedKeychain` property wrapper.

     - Parameter wrappedValue: Default value.
     - Parameter key: `StoreKey` to store the value.
     */
    public required init(wrappedValue: Value, _ key: StoreKey) {
        storage = KeychainStorage.standard
        self.key = key
        defaultValue = wrappedValue
    }

    /// Property wrapper stored value.
    open var wrappedValue: Value {
        get { storage.value(forKey: key) ?? defaultValue }
        set { storage.set(newValue, forKey: key) }
    }
}

/// `@CodableKeychain` property wrapper.
@propertyWrapper
open class CodableKeychain<Value: Codable>: StorePropertyWrapper<KeychainStorage> {
    /**
     Create a `CodableKeychain` property wrapper.

     - Parameter key: `StoreKey` to store the value.
     */
    public convenience init(_ key: StoreKey) {
        self.init(KeychainStorage.standard, key)
    }

    /**
     Create a `CodableKeychain` property wrapper.

     - Parameter wrappedValue: Default value.
     - Parameter key: `StoreKey` to store the value.
     */
    public convenience init(wrappedValue: Value?, _ key: StoreKey) {
        self.init(key)
        self.wrappedValue = wrappedValue
    }

    /// Property wrapper stored value.
    open var wrappedValue: Value? {
        get { storage.decodable(forKey: key) }
        set { storage.set(encodable: newValue, forKey: key) }
    }
}

/// `@UnwrappedCodableKeychain` property wrapper.
@propertyWrapper
open class UnwrappedCodableKeychain<Value: Codable>: StorePropertyWrapperProtocol {
    /// `Storage` used by property wrapper.
    open var storage: KeychainStorage
    /// `StoreKey` to store the value.
    open var key: StoreKey
    /// Default value.
    open var defaultValue: Value

    /**
     Create a `UnwrappedCodableKeychain` property wrapper.

     - Parameter wrappedValue: Default value.
     - Parameter key: `StoreKey` to store the value.
     */
    public required init(wrappedValue: Value, _ key: StoreKey) {
        storage = KeychainStorage.standard
        self.key = key
        defaultValue = wrappedValue
    }

    /// Property wrapper stored value.
    open var wrappedValue: Value {
        get { storage.decodable(forKey: key) ?? defaultValue }
        set { storage.set(encodable: newValue, forKey: key) }
    }
}
