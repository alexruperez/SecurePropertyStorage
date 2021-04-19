/// Property wrapper protocol.
public protocol StorePropertyWrapperProtocol {
    /// `Storage` type used by property wrapper.
    associatedtype StorageType: Storage
    /// `Storage` used by property wrapper.
    var storage: StorageType { get }
    /// `StoreKey` to store the value.
    var key: StoreKey { get }
}

/// Property wrapper reusable init class.
open class StorePropertyWrapper<StorageType: Storage>: StorePropertyWrapperProtocol {
    /// `Storage` used by property wrapper.
    open var storage: StorageType
    /// `StoreKey` to store the value.
    open var key: StoreKey

    /**
     Create a property wrapper.

     - Parameter storage: `Storage` used by property wrapper.
     - Parameter key: `StoreKey` to store the value.
     */
    public required init(_ storage: StorageType, _ key: StoreKey) {
        self.storage = storage
        self.key = key
    }
}

/// `@Store` property wrapper.
@propertyWrapper
open class Store<Value, StorageType: Storage>: StorePropertyWrapper<StorageType> {
    /**
     Create a `Store` property wrapper.

     - Parameter wrappedValue: Default value.
     - Parameter storage: `Storage` used by property wrapper.
     - Parameter key: `StoreKey` to store the value.
     */
    public convenience init(wrappedValue: Value?, _ storage: StorageType, _ key: StoreKey) {
        self.init(storage, key)
        self.wrappedValue = wrappedValue
    }

    /// Property wrapper stored value.
    open var wrappedValue: Value? {
        get { storage.value(forKey: key) }
        set { storage.set(newValue, forKey: key) }
    }
}

/// `@UnwrappedStore` property wrapper.
@propertyWrapper
open class UnwrappedStore<Value, StorageType: Storage>: StorePropertyWrapperProtocol {
    /// `Storage` used by property wrapper.
    open var storage: StorageType
    /// `StoreKey` to store the value.
    open var key: StoreKey
    /// Default value.
    open var defaultValue: Value

    /**
     Create a `UnwrappedStore` property wrapper.

     - Parameter wrappedValue: Default value.
     - Parameter storage: `Storage` used by property wrapper.
     - Parameter key: `StoreKey` to store the value.
     */
    public required init(wrappedValue: Value, _ storage: StorageType, _ key: StoreKey) {
        self.storage = storage
        self.key = key
        defaultValue = wrappedValue
    }

    /// Property wrapper stored value.
    open var wrappedValue: Value {
        get { storage.value(forKey: key) ?? defaultValue }
        set { storage.set(newValue, forKey: key) }
    }
}

/// `@CodableStore` property wrapper.
@propertyWrapper
open class CodableStore<Value: Codable, StorageType: Storage>: StorePropertyWrapper<StorageType> {
    /**
     Create a `CodableStore` property wrapper.

     - Parameter wrappedValue: Default value.
     - Parameter storage: `Storage` used by property wrapper.
     - Parameter key: `StoreKey` to store the value.
     */
    public convenience init(wrappedValue: Value?, _ storage: StorageType, _ key: StoreKey) {
        self.init(storage, key)
        self.wrappedValue = wrappedValue
    }

    /// Property wrapper stored value.
    open var wrappedValue: Value? {
        get { storage.decodable(forKey: key) }
        set { storage.set(encodable: newValue, forKey: key) }
    }
}

/// `@UnwrappedCodableStore` property wrapper.
@propertyWrapper
open class UnwrappedCodableStore<Value: Codable, StorageType: Storage>: StorePropertyWrapperProtocol {
    /// `Storage` used by property wrapper.
    open var storage: StorageType
    /// `StoreKey` to store the value.
    open var key: StoreKey
    /// Default value.
    open var defaultValue: Value

    /**
     Create a `UnwrappedCodableStore` property wrapper.

     - Parameter wrappedValue: Default value.
     - Parameter storage: `Storage` used by property wrapper.
     - Parameter key: `StoreKey` to store the value.
     */
    public required init(wrappedValue: Value, _ storage: StorageType, _ key: StoreKey) {
        self.storage = storage
        self.key = key
        defaultValue = wrappedValue
    }

    /// Property wrapper stored value.
    open var wrappedValue: Value {
        get { storage.decodable(forKey: key) ?? defaultValue }
        set { storage.set(encodable: newValue, forKey: key) }
    }
}
