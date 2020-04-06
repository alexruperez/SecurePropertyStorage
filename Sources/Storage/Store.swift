public protocol StorePropertyWrapperProtocol {
    var storage: Storage { get }
    var key: StoreKey { get }
}

open class StorePropertyWrapper: StorePropertyWrapperProtocol {
    open var storage: Storage
    open var key: StoreKey

    public required init(_ storage: Storage, _ key: StoreKey) {
        self.storage = storage
        self.key = key
    }
}

@propertyWrapper
open class Store<Value>: StorePropertyWrapper {
    public convenience init(wrappedValue: Value?, _ storage: Storage, _ key: StoreKey) {
        self.init(storage, key)
        self.wrappedValue = wrappedValue
    }

    open var wrappedValue: Value? {
        get { storage.value(forKey: key) }
        set { storage.set(newValue, forKey: key) }
    }
}

@propertyWrapper
open class UnwrappedStore<Value>: StorePropertyWrapperProtocol {
    open var storage: Storage
    open var key: StoreKey
    open var defaultValue: Value

    public required init(wrappedValue: Value, _ storage: Storage, _ key: StoreKey) {
        self.storage = storage
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
open class CodableStore<Value: Codable>: StorePropertyWrapper {
    public convenience init(wrappedValue: Value?, _ storage: Storage, _ key: StoreKey) {
        self.init(storage, key)
        self.wrappedValue = wrappedValue
    }

    open var wrappedValue: Value? {
        get { storage.decodable(forKey: key) }
        set { storage.set(encodable: newValue, forKey: key) }
    }
}

@propertyWrapper
open class UnwrappedCodableStore<Value: Codable>: StorePropertyWrapperProtocol {
    open var storage: Storage
    open var key: StoreKey
    open var defaultValue: Value

    public required init(wrappedValue: Value, _ storage: Storage, _ key: StoreKey) {
        self.storage = storage
        self.key = key
        defaultValue = wrappedValue
        self.wrappedValue = defaultValue
    }

    open var wrappedValue: Value {
        get { storage.decodable(forKey: key) ?? defaultValue }
        set { storage.set(encodable: newValue, forKey: key) }
    }
}
