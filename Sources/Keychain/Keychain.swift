import Storage

@propertyWrapper
open class Keychain<Value>: StorePropertyWrapper {
    public convenience init(_ key: StoreKey) {
        self.init(KeychainStorage.standard, key)
    }

    open var wrappedValue: Value? {
        get { storage.value(forKey: key) }
        set { storage.set(newValue, forKey: key) }
    }
}
