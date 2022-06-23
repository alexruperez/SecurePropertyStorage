import Foundation

/// `StoreKey` definition aka. `String`.
public typealias StoreKey = String

/// `Storage` protocol.
public protocol Storage: StorageDelegate {
    /**
     Adds the contents of the specified dictionary to the registration domain.

     - Parameter defaults: The dictionary of keys and values you want to register.
     */
    func register(defaults registration: [StoreKey: Any])

    /**
     Returns the generic value associated with the specified `StoreKey`.

     - Parameter key: A `StoreKey` in storage.
     */
    func value<V>(forKey key: StoreKey) -> V?

    /**
     Returns the `Decodable` associated with the specified `StoreKey`.

     - Parameter key: A `StoreKey` in storage.
     */
    func decodable<D: Decodable>(forKey key: StoreKey) -> D?

    /**
     Returns the `StorageData` associated with the specified `StoreKey`.

     - Parameter key: A `StoreKey` in storage.
     */
    func data<D: StorageData>(forKey key: StoreKey) -> D?

    /**
     Returns the `String` associated with the specified `StoreKey`.

     - Parameter key: A `StoreKey` in storage.
     */
    func string(forKey key: StoreKey) -> String?

    /**
     Returns the `[Any]` associated with the specified `StoreKey`.

     - Parameter key: A `StoreKey` in storage.
     */
    func array(forKey key: StoreKey) -> [Any]?

    /**
     Returns the `Set<AnyHashable>` associated with the specified `StoreKey`.

     - Parameter key: A `StoreKey` in storage.
     */
    func set(forKey key: StoreKey) -> Set<AnyHashable>?

    /**
     Returns the `[String: Any]` associated with the specified `StoreKey`.

     - Parameter key: A `StoreKey` in storage.
     */
    func dictionary(forKey key: StoreKey) -> [String: Any]?

    /**
     Returns the `[String]` associated with the specified `StoreKey`.

     - Parameter key: A `StoreKey` in storage.
     */
    func stringArray(forKey key: StoreKey) -> [String]?

    /**
     Returns the `Int` associated with the specified `StoreKey`.

     - Parameter key: A `StoreKey` in storage.
     */
    func integer(forKey key: StoreKey) -> Int

    /**
     Returns the `Float` associated with the specified `StoreKey`.

     - Parameter key: A `StoreKey` in storage.
     */
    func float(forKey key: StoreKey) -> Float

    /**
     Returns the `Double` associated with the specified `StoreKey`.

     - Parameter key: A `StoreKey` in storage.
     */
    func double(forKey key: StoreKey) -> Double

    /**
     Returns the `Bool` associated with the specified `StoreKey`.

     - Parameter key: A `StoreKey` in storage.
     */
    func bool(forKey key: StoreKey) -> Bool

    /**
     Returns the `URL` associated with the specified `StoreKey`.

     - Parameter key: A `StoreKey` in storage.
     */
    func url(forKey key: StoreKey) -> URL?

    /**
     Sets the value of the specified `StoreKey` to the specified `Int`.

     - Parameter value: `Int` to store.
     - Parameter key: The `StoreKey` with which to associate the value.
     */
    func set(_ value: Int, forKey key: StoreKey)

    /**
     Sets the value of the specified `StoreKey` to the specified `Float`.

     - Parameter value: `Float` to store.
     - Parameter key: The `StoreKey` with which to associate the value.
     */
    func set(_ value: Float, forKey key: StoreKey)

    /**
     Sets the value of the specified `StoreKey` to the specified `Double`.

     - Parameter value: `Double` to store.
     - Parameter key: The `StoreKey` with which to associate the value.
     */
    func set(_ value: Double, forKey key: StoreKey)
    /**
     Sets the value of the specified `StoreKey` to the specified `Bool`.

     - Parameter value: `Bool` to store.
     - Parameter key: The `StoreKey` with which to associate the value.
     */
    func set(_ value: Bool, forKey key: StoreKey)

    /**
     Sets the value of the specified `StoreKey` to the specified `URL`.

     - Parameter url: `URL` to store.
     - Parameter key: The `StoreKey` with which to associate the value.
     */
    func set(_ url: URL?, forKey key: StoreKey)

    /**
     Sets the value of the specified `StoreKey` to the specified `String`.

     - Parameter string: `String` to store.
     - Parameter key: The `StoreKey` with which to associate the value.
     */
    func set(_ string: String, forKey key: StoreKey)

    /**
     Sets the value of the specified `StoreKey` to the specified generic value.

     - Parameter value: Generic value to store.
     - Parameter key: The `StoreKey` with which to associate the value.
     */
    func set<V>(_ value: V?, forKey key: StoreKey)

    /**
     Sets the value of the specified `StoreKey` to the specified `Encodable`.

     - Parameter encodable: `Encodable` to store.
     - Parameter key: The `StoreKey` with which to associate the value.
     */
    func set(encodable: Encodable?, forKey key: StoreKey)

    /**
     Sets the value of the specified `StoreKey` to the specified `StorageData`.

     - Parameter data: `StorageData` to store.
     - Parameter key: The `StoreKey` with which to associate the value.
     */
    func set<D: StorageData>(_ data: D?, forKey key: StoreKey)

    /**
     Removes the value of the specified `StoreKey`.

     - Parameter key: The `StoreKey` whose value you want to remove.
     */
    func remove(forKey key: StoreKey)
}
