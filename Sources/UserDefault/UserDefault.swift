import Storage

@propertyWrapper
open class UserDefault<Value>: StorePropertyWrapper {
    public convenience init(_ key: StoreKey) {
        self.init(UserDefaultsStorage.standard, key)
    }

    open var wrappedValue: Value? {
        get { storage.value(forKey: key) }
        set { storage.set(newValue, forKey: key) }
    }
}
