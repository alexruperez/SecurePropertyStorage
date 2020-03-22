import Storage

@propertyWrapper
public struct Keychain<Value> {
    private let key: StoreKey

    public init(_ key: String) {
        self.key = key
    }

    public var wrappedValue: Value? {
        get { KeychainStorage.standard.value(forKey: key) }
        set { KeychainStorage.standard.set(newValue, forKey: key) }
    }
}
