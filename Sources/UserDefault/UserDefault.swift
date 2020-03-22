import Storage

@propertyWrapper
public struct UserDefault<Value> {
    private let key: StoreKey

    public init(_ key: String) {
        self.key = key
    }

    public var wrappedValue: Value? {
        get { UserDefaultsStorage.standard.value(forKey: key) }
        set { UserDefaultsStorage.standard.set(newValue, forKey: key) }
    }
}
