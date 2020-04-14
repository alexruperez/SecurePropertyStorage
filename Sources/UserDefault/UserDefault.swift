import Storage

/// `@UserDefault` property wrapper.
@propertyWrapper
open class UserDefault<Value>: StorePropertyWrapper<UserDefaultsStorage> {
    /**
     Create a `UserDefault` property wrapper.

     - Parameter key: `StoreKey` to store the value.
     */
    public convenience init(_ key: StoreKey) {
        self.init(UserDefaultsStorage.standard, key)
    }

    /**
     Create a `UserDefault` property wrapper.

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

/// `@UnwrappedUserDefault` property wrapper.
@propertyWrapper
open class UnwrappedUserDefault<Value>: StorePropertyWrapperProtocol {
    /// `Storage` used by property wrapper.
    open var storage: UserDefaultsStorage
    /// `StoreKey` to store the value.
    open var key: StoreKey
    /// Default value.
    open var defaultValue: Value

    /**
     Create a `UnwrappedUserDefault` property wrapper.

     - Parameter wrappedValue: Default value.
     - Parameter key: `StoreKey` to store the value.
     */
    public required init(wrappedValue: Value, _ key: StoreKey) {
        storage = UserDefaultsStorage.standard
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

/// `@CodableUserDefault` property wrapper.
@propertyWrapper
open class CodableUserDefault<Value: Codable>: StorePropertyWrapper<UserDefaultsStorage> {
    /**
     Create a `CodableUserDefault` property wrapper.

     - Parameter key: `StoreKey` to store the value.
     */
    public convenience init(_ key: StoreKey) {
        self.init(UserDefaultsStorage.standard, key)
    }

    /**
     Create a `CodableUserDefault` property wrapper.

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

/// `@UnwrappedCodableUserDefault` property wrapper.
@propertyWrapper
open class UnwrappedCodableUserDefault<Value: Codable>: StorePropertyWrapperProtocol {
    /// `Storage` used by property wrapper.
    open var storage: UserDefaultsStorage
    /// `StoreKey` to store the value.
    open var key: StoreKey
    /// Default value.
    open var defaultValue: Value

    /**
     Create a `UnwrappedCodableUserDefault` property wrapper.

     - Parameter wrappedValue: Default value.
     - Parameter key: `StoreKey` to store the value.
     */
    public required init(wrappedValue: Value, _ key: StoreKey) {
        storage = UserDefaultsStorage.standard
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
