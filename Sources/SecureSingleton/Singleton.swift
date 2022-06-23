import SecureStorage

/// `@Singleton` property wrapper.
@propertyWrapper
open class Singleton<Value>: StorePropertyWrapper<SingletonStorage> {
    /**
     Create a `Singleton` property wrapper.

     - Parameter key: `StoreKey` to store the value.
     */
    public convenience init(_ key: StoreKey) {
        self.init(SingletonStorage.standard, key)
    }

    /**
     Create a `Singleton` property wrapper.

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

/// `@UnwrappedSingleton` property wrapper.
@propertyWrapper
open class UnwrappedSingleton<Value>: StorePropertyWrapperProtocol {
    /// `Storage` used by property wrapper.
    open var storage: SingletonStorage
    /// `StoreKey` to store the value.
    open var key: StoreKey
    /// Default value.
    open var defaultValue: Value

    /**
     Create a `UnwrappedSingleton` property wrapper.

     - Parameter wrappedValue: Default value.
     - Parameter key: `StoreKey` to store the value.
     */
    public required init(wrappedValue: Value, _ key: StoreKey) {
        storage = SingletonStorage.standard
        self.key = key
        defaultValue = wrappedValue
    }

    /// Property wrapper stored value.
    open var wrappedValue: Value {
        get { storage.value(forKey: key) ?? defaultValue }
        set { storage.set(newValue, forKey: key) }
    }
}

/// `@CodableSingleton` property wrapper.
@propertyWrapper
open class CodableSingleton<Value: Codable>: StorePropertyWrapper<SingletonStorage> {
    /**
     Create a `CodableSingleton` property wrapper.

     - Parameter key: `StoreKey` to store the value.
     */
    public convenience init(_ key: StoreKey) {
        self.init(SingletonStorage.standard, key)
    }

    /**
     Create a `CodableSingleton` property wrapper.

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

/// `@UnwrappedCodableSingleton` property wrapper.
@propertyWrapper
open class UnwrappedCodableSingleton<Value: Codable>: StorePropertyWrapperProtocol {
    /// `Storage` used by property wrapper.
    open var storage: SingletonStorage
    /// `StoreKey` to store the value.
    open var key: StoreKey
    /// Default value.
    open var defaultValue: Value

    /**
     Create a `UnwrappedCodableSingleton` property wrapper.

     - Parameter wrappedValue: Default value.
     - Parameter key: `StoreKey` to store the value.
     */
    public required init(wrappedValue: Value, _ key: StoreKey) {
        storage = SingletonStorage.standard
        self.key = key
        defaultValue = wrappedValue
    }

    /// Property wrapper stored value.
    open var wrappedValue: Value {
        get { storage.decodable(forKey: key) ?? defaultValue }
        set { storage.set(encodable: newValue, forKey: key) }
    }
}
