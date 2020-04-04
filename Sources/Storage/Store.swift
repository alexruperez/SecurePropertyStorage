open class StorePropertyWrapper {
    open var storage: Storage
    open var key: StoreKey

    public required init(_ storage: Storage, _ key: StoreKey) {
        self.storage = storage
        self.key = key
    }
}

@propertyWrapper
open class Store<Value>: StorePropertyWrapper {
    open var wrappedValue: Value? {
        get { storage.value(forKey: key) }
        set { storage.set(newValue, forKey: key) }
    }
}
