import Storage

@propertyWrapper
open class Keychain<Value>: StorePropertyWrapper {
    public convenience init(_ key: StoreKey) {
        self.init(KeychainStorage.standard, key)
    }

    public convenience init(wrappedValue: Value?, _ key: StoreKey) {
        self.init(key)
        self.wrappedValue = wrappedValue
    }

    open var wrappedValue: Value? {
        get { storage.value(forKey: key) }
        set { storage.set(newValue, forKey: key) }
    }
}

@propertyWrapper
open class UnwrappedKeychain<Value>: StorePropertyWrapperProtocol {
    open var storage: Storage
    open var key: StoreKey
    open var defaultValue: Value

    public required init(wrappedValue: Value, _ key: StoreKey) {
        storage = KeychainStorage.standard
        self.key = key
        defaultValue = wrappedValue
        self.wrappedValue = defaultValue
    }

    open var wrappedValue: Value {
        get { storage.value(forKey: key) ?? defaultValue }
        set { storage.set(newValue, forKey: key) }
    }
}

@propertyWrapper
open class CodableKeychain<Value: Codable>: StorePropertyWrapper {
    public convenience init(_ key: StoreKey) {
        self.init(KeychainStorage.standard, key)
    }

    public convenience init(wrappedValue: Value?, _ key: StoreKey) {
        self.init(key)
        self.wrappedValue = wrappedValue
    }

    open var wrappedValue: Value? {
        get { storage.decodable(forKey: key) }
        set { storage.set(encodable: newValue, forKey: key) }
    }
}

@propertyWrapper
open class UnwrappedCodableKeychain<Value: Codable>: StorePropertyWrapperProtocol {
    open var storage: Storage
    open var key: StoreKey
    open var defaultValue: Value

    public required init(wrappedValue: Value, _ key: StoreKey) {
        storage = KeychainStorage.standard
        self.key = key
        defaultValue = wrappedValue
        self.wrappedValue = defaultValue
    }

    open var wrappedValue: Value {
        get { storage.decodable(forKey: key) ?? defaultValue }
        set { storage.set(encodable: newValue, forKey: key) }
    }
}
