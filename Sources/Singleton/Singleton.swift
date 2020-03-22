import Storage

@propertyWrapper
public struct Singleton<Value> {
    private let key: StoreKey

    public init(_ key: String) {
        self.key = key
    }

    public var wrappedValue: Value? {
        get { SingletonStorage.standard.value(forKey: key) }
        set { SingletonStorage.standard.set(newValue, forKey: key) }
    }
}
