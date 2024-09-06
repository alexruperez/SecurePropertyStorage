import Storage

/// `InjectStorage` subclass of `DelegatedStorage` that uses a `[AnyHashable: Any]`.
open class InjectStorage: DelegatedStorage {
    /// `InjectStorage` shared instance.
    open class var standard: InjectStorage { shared }
    private static let shared = InjectStorage()
    var groups = [DependencyGroupKey: InjectStorage]()
    var storage = [StoreKey: [Any]]()

    /**
     Returns the `[Any]` of dependencies associated with the specified `StoreKey`.

     - Parameter key: A `StoreKey` in storage.
     */
    override open func array(forKey key: StoreKey) -> [Any]? { storage[hash(key)] }

    override open func set(object: Any?, forKey key: StoreKey) {
        let storeKey = hash(key)
        if let dependency = object {
            if storage[storeKey] == nil {
                storage[storeKey] = [Any]()
            }
            storage[storeKey]?.append(dependency)
        }
    }
}
