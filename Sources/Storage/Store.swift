public typealias StoreKey = String

@propertyWrapper
public struct Store<Value> {
    private let storage: Storage
    private let key: StoreKey

    public init(_ storage: Storage, _ key: String) {
        self.storage = storage
        self.key = key
    }

    public var wrappedValue: Value? {
        get { storage.value(forKey: key) }
        set { storage.set(newValue, forKey: key) }
    }
}
