import CryptoKit
import Foundation
import Keychain
import Storage

/// `UserDefaultsStorage` subclass of `UserDefaults` that uses a `DelegatedStorage`.
open class UserDefaultsStorage: UserDefaults, Storage {
    /// `UserDefaultsStorage` shared instance.
    open override class var standard: UserDefaultsStorage { shared }
    private static let shared = UserDefaultsStorage()
    private var storage: Storage!

    /**
    Create a `UserDefaultsStorage`.

    - Parameter authenticationTag: Custom additional `Data` to be authenticated.
    */
    public convenience init(authenticationTag: Data? = nil) {
        self.init(suiteName: nil,
                  symmetricKey: SymmetricKey.generate(),
                  nonce: AES.GCM.Nonce.generate(),
                  authenticationTag: authenticationTag)!
    }

    /**
    Create a `UserDefaultsStorage`.

    - Parameter suiteName: The domain identifier of the search list.
    - Parameter symmetricKey: A cryptographic key used to seal the message.
    - Parameter nonce: A nonce used during the sealing process.
    - Parameter authenticationTag: Custom additional `Data` to be authenticated.
    */
    public init?(suiteName suitename: String?,
                 symmetricKey: SymmetricKey,
                 nonce: AES.GCM.Nonce? = nil,
                 authenticationTag: Data? = nil) {
        super.init(suiteName: suitename)
        storage = DelegatedStorage(self,
                                   symmetricKey: symmetricKey,
                                   nonce: nonce,
                                   authenticationTag: authenticationTag)
    }

    /**
    Returns the `StorageData` associated with the specified `StoreKey`.

    - Parameter key: A `StoreKey` in storage.
    */
    open func data<D: StorageData>(forKey key: StoreKey) -> D? {
        super.data(forKey: key) as? D
    }

    /**
    Sets the value of the specified `StoreKey` to the specified `StorageData`.

    - Parameter data: `StorageData` to store.
    - Parameter key: The `StoreKey` with which to associate the value.
    */
    open func set<D: StorageData>(_ data: D?, forKey defaultName: StoreKey) {
        super.set(data, forKey: defaultName)
    }

    /**
    Removes the value of the specified `StoreKey`.

    - Parameter key: The `StoreKey` whose value you want to remove.
    */
    open func remove(forKey key: StoreKey) {
        super.removeObject(forKey: key)
    }

    /**
    Adds the contents of the specified dictionary to the registration domain.

    - Parameter defaults: The dictionary of keys and values you want to register.
    */
    open override func register(defaults registrationDictionary: [StoreKey: Any]) {
        storage.register(defaults: registrationDictionary)
    }

    /**
    Returns the generic value associated with the specified `StoreKey`.

    - Parameter key: A `StoreKey` in storage.
    */
    open func value<V>(forKey key: StoreKey) -> V? {
        storage.value(forKey: key)
    }

    /**
    Returns the `Decodable` associated with the specified `StoreKey`.

    - Parameter key: A `StoreKey` in storage.
    */
    open func decodable<D: Decodable>(forKey key: StoreKey) -> D? {
        storage.decodable(forKey: key)
    }

    /**
    Sets the value of the specified `StoreKey` to the specified `String`.

    - Parameter string: `String` to store.
    - Parameter key: The `StoreKey` with which to associate the value.
    */
    open func set(_ string: String, forKey key: StoreKey) {
        storage.set(string, forKey: key)
    }

    /**
    Sets the value of the specified `StoreKey` to the specified generic value.

    - Parameter value: Generic value to store.
    - Parameter key: The `StoreKey` with which to associate the value.
    */
    open func set<V>(_ value: V?, forKey key: StoreKey) {
        storage.set(value, forKey: key)
    }

    /**
    Sets the value of the specified `StoreKey` to the specified `Encodable`.

    - Parameter encodable: `Encodable` to store.
    - Parameter key: The `StoreKey` with which to associate the value.
    */
    open func set(encodable: Encodable?, forKey key: StoreKey) {
        storage.set(encodable: encodable, forKey: key)
    }

    /**
    Returns the `String` associated with the specified `StoreKey`.

    - Parameter key: A `StoreKey` in storage.
    */
    open override func string(forKey defaultName: StoreKey) -> String? {
        storage.string(forKey: defaultName)
    }

    /**
    Returns the `[Any]` associated with the specified `StoreKey`.

    - Parameter key: A `StoreKey` in storage.
    */
    open override func array(forKey defaultName: StoreKey) -> [Any]? {
        storage.array(forKey: defaultName)
    }

    /**
    Returns the `[String: Any]` associated with the specified `StoreKey`.

    - Parameter key: A `StoreKey` in storage.
    */
    open override func dictionary(forKey defaultName: StoreKey) -> [String: Any]? {
        storage.dictionary(forKey: defaultName)
    }

    /**
    Returns the `[String]` associated with the specified `StoreKey`.

    - Parameter key: A `StoreKey` in storage.
    */
    open override func stringArray(forKey defaultName: StoreKey) -> [String]? {
        storage.stringArray(forKey: defaultName)
    }

    /**
    Returns the `Int` associated with the specified `StoreKey`.

    - Parameter key: A `StoreKey` in storage.
    */
    open override func integer(forKey defaultName: StoreKey) -> Int {
        storage.integer(forKey: defaultName)
    }

    /**
    Returns the `Float` associated with the specified `StoreKey`.

    - Parameter key: A `StoreKey` in storage.
    */
    open override func float(forKey defaultName: StoreKey) -> Float {
        storage.float(forKey: defaultName)
    }

    /**
    Returns the `Double` associated with the specified `StoreKey`.

    - Parameter key: A `StoreKey` in storage.
    */
    open override func double(forKey defaultName: StoreKey) -> Double {
        storage.double(forKey: defaultName)
    }

    /**
    Returns the `Bool` associated with the specified `StoreKey`.

    - Parameter key: A `StoreKey` in storage.
    */
    open override func bool(forKey defaultName: StoreKey) -> Bool {
        storage.bool(forKey: defaultName)
    }

    /**
    Returns the `URL` associated with the specified `StoreKey`.

    - Parameter key: A `StoreKey` in storage.
    */
    open override func url(forKey defaultName: StoreKey) -> URL? {
        storage.url(forKey: defaultName)
    }

    /**
    Sets the value of the specified `StoreKey` to the specified `Int`.

    - Parameter value: `Int` to store.
    - Parameter key: The `StoreKey` with which to associate the value.
    */
    open override func set(_ value: Int, forKey defaultName: StoreKey) {
        storage.set(value, forKey: defaultName)
    }

    /**
    Sets the value of the specified `StoreKey` to the specified `Float`.

    - Parameter value: `Float` to store.
    - Parameter key: The `StoreKey` with which to associate the value.
    */
    open override func set(_ value: Float, forKey defaultName: StoreKey) {
        storage.set(value, forKey: defaultName)
    }

    /**
    Sets the value of the specified `StoreKey` to the specified `Double`.

    - Parameter value: `Double` to store.
    - Parameter key: The `StoreKey` with which to associate the value.
    */
    open override func set(_ value: Double, forKey defaultName: StoreKey) {
        storage.set(value, forKey: defaultName)
    }

    /**
    Sets the value of the specified `StoreKey` to the specified `Bool`.

    - Parameter value: `Bool` to store.
    - Parameter key: The `StoreKey` with which to associate the value.
    */
    open override func set(_ value: Bool, forKey defaultName: StoreKey) {
        storage.set(value, forKey: defaultName)
    }

    /**
    Sets the value of the specified `StoreKey` to the specified `URL`.

    - Parameter url: `URL` to store.
    - Parameter key: The `StoreKey` with which to associate the value.
    */
    open override func set(_ url: URL?, forKey defaultName: StoreKey) {
        storage.set(url, forKey: defaultName)
    }
}
