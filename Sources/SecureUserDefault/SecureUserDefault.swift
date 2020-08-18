import Storage

/// `@SecureUserDefault` property wrapper.
@propertyWrapper
open class SecureUserDefault<Value>: StorePropertyWrapper<SecureUserDefaultsStorage> {
    /**
     Create a `SecureUserDefault` property wrapper.

     - Parameter key: `StoreKey` to store the value.
     */
    public convenience init(_ key: StoreKey) {
        self.init(SecureUserDefaultsStorage.standard, key)
    }

    /**
     Create a `SecureUserDefault` property wrapper.

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

/// `@UnwrappedSecureUserDefault` property wrapper.
@propertyWrapper
open class UnwrappedSecureUserDefault<Value>: StorePropertyWrapperProtocol {
    /// `Storage` used by property wrapper.
    open var storage: SecureUserDefaultsStorage
    /// `StoreKey` to store the value.
    open var key: StoreKey
    /// Default value.
    open var defaultValue: Value

    /**
     Create a `UnwrappedSecureUserDefault` property wrapper.

     - Parameter wrappedValue: Default value.
     - Parameter key: `StoreKey` to store the value.
     */
    public required init(wrappedValue: Value, _ key: StoreKey) {
        storage = SecureUserDefaultsStorage.standard
        self.key = key
        defaultValue = wrappedValue
        self.wrappedValue = defaultValue
    }

    /// Property wrapper stored value.
    open var wrappedValue: Value {
        get { storage.value(forKey: key) ?? defaultValue }
        set { storage.set(newValue, forKey: key) }
    }
}

/// `@CodableSecureUserDefault` property wrapper.
@propertyWrapper
open class CodableSecureUserDefault<Value: Codable>: StorePropertyWrapper<SecureUserDefaultsStorage> {
    /**
     Create a `CodableSecureUserDefault` property wrapper.

     - Parameter key: `StoreKey` to store the value.
     */
    public convenience init(_ key: StoreKey) {
        self.init(SecureUserDefaultsStorage.standard, key)
    }

    /**
     Create a `CodableSecureUserDefault` property wrapper.

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

/// `@UnwrappedCodableSecureUserDefault` property wrapper.
@propertyWrapper
open class UnwrappedCodableSecureUserDefault<Value: Codable>: StorePropertyWrapperProtocol {
    /// `Storage` used by property wrapper.
    open var storage: SecureUserDefaultsStorage
    /// `StoreKey` to store the value.
    open var key: StoreKey
    /// Default value.
    open var defaultValue: Value

    /**
     Create a `UnwrappedCodableSecureUserDefault` property wrapper.

     - Parameter wrappedValue: Default value.
     - Parameter key: `StoreKey` to store the value.
     */
    public required init(wrappedValue: Value, _ key: StoreKey) {
        storage = SecureUserDefaultsStorage.standard
        self.key = key
        defaultValue = wrappedValue
        self.wrappedValue = defaultValue
    }

    /// Property wrapper stored value.
    open var wrappedValue: Value {
        get { storage.decodable(forKey: key) ?? defaultValue }
        set { storage.set(encodable: newValue, forKey: key) }
    }
}
