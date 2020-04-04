import Storage

@propertyWrapper
open class Singleton<Value>: StorePropertyWrapper {
    public convenience init(_ key: StoreKey) {
        self.init(SingletonStorage.standard, key)
    }

    open var wrappedValue: Value? {
        get { storage.value(forKey: key) }
        set { storage.set(newValue, forKey: key) }
    }
}
