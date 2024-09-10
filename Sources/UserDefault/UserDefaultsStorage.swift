import CryptoKit
import Foundation
import Keychain
import Storage

/// `UserDefaultsStorage` subclass of `UserDefaults` that uses a `DelegatedStorage`.
open class UserDefaultsStorage: Storage {
    /// `UserDefaultsStorage` shared instance.
    open class var standard: UserDefaultsStorage { shared }
    private static let shared = UserDefaultsStorage()
    private var storage: Storage!
    private let userDefaults: UserDefaults

    /**
     Create a `UserDefaultsStorage`.

     - Parameter authenticationTag: Custom additional `Data` to be authenticated.
     */
    public convenience init(authenticationTag: Data? = nil) {
        self.init(suiteName: nil,
                  symmetricKey: SymmetricKey.generate(),
                  authenticationTag: authenticationTag)!
    }

    /**
     Create a `UserDefaultsStorage`.

     - Parameter suiteName: The domain identifier of the search list.
     - Parameter symmetricKey: A cryptographic key used to seal the message.
     - Parameter authenticationTag: Custom additional `Data` to be authenticated.
     */
    public init?(suiteName suitename: String?,
                 symmetricKey: SymmetricKey,
                 authenticationTag: Data? = nil) {
        guard 
            let userDefaults = UserDefaults(suiteName: suitename)
        else {
            fatalError(
                "Unable to initialize UserDefaults. Please check that the suite name is valid and that the app has the appropriate entitlements"
            )
        }
        self.userDefaults = userDefaults
        storage = DelegatedStorage(self,
                                   symmetricKey: symmetricKey,
                                   authenticationTag: authenticationTag)
    }

    /**
     Returns the `StorageData` associated with the specified `StoreKey`.

     - Parameter key: A `StoreKey` in storage.
     */
    open func data<D: StorageData>(forKey key: StoreKey) -> D? {
        userDefaults.data(forKey: key) as? D
    }

    /**
     Sets the value of the specified `StoreKey` to the specified `StorageData`.

     - Parameter data: `StorageData` to store.
     - Parameter defaultName: The `StoreKey` with which to associate the value.
     */
    open func set(_ data: (some StorageData)?, forKey defaultName: StoreKey) {
        userDefaults.set(data, forKey: defaultName)
    }

    /**
     Removes the value of the specified `StoreKey`.

     - Parameter key: The `StoreKey` whose value you want to remove.
     */
    open func remove(forKey key: StoreKey) {
        userDefaults.removeObject(forKey: key)
    }

    /**
     Adds the contents of the specified dictionary to the registration domain.

     - Parameter defaults: The dictionary of keys and values you want to register.
     */
    open func register(defaults registrationDictionary: [StoreKey: Any]) {
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
    open func set(_ value: (some Any)?, forKey key: StoreKey) {
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

     - Parameter defaultName: A `StoreKey` in storage.
     */
    open func string(forKey defaultName: StoreKey) -> String? {
        storage.string(forKey: defaultName)
    }

    /**
     Returns the `[Any]` associated with the specified `StoreKey`.

     - Parameter defaultName: A `StoreKey` in storage.
     */
    open func array(forKey defaultName: StoreKey) -> [Any]? {
        storage.array(forKey: defaultName)
    }

    /**
     Returns the `Set<AnyHashable>` associated with the specified `StoreKey`.

     - Parameter defaultName: A `StoreKey` in storage.
     */
    open func set(forKey defaultName: StoreKey) -> Set<AnyHashable>? {
        storage.set(forKey: defaultName)
    }

    /**
     Returns the `[String: Any]` associated with the specified `StoreKey`.

     - Parameter defaultName: A `StoreKey` in storage.
     */
    open func dictionary(forKey defaultName: StoreKey) -> [String: Any]? {
        storage.dictionary(forKey: defaultName)
    }

    /**
     Returns the `[String]` associated with the specified `StoreKey`.

     - Parameter defaultName: A `StoreKey` in storage.
     */
    open func stringArray(forKey defaultName: StoreKey) -> [String]? {
        storage.stringArray(forKey: defaultName)
    }

    /**
     Returns the `Int` associated with the specified `StoreKey`.

     - Parameter defaultName: A `StoreKey` in storage.
     */
    open func integer(forKey defaultName: StoreKey) -> Int {
        storage.integer(forKey: defaultName)
    }

    /**
     Returns the `Float` associated with the specified `StoreKey`.

     - Parameter defaultName: A `StoreKey` in storage.
     */
    open func float(forKey defaultName: StoreKey) -> Float {
        storage.float(forKey: defaultName)
    }

    /**
     Returns the `Double` associated with the specified `StoreKey`.

     - Parameter defaultName: A `StoreKey` in storage.
     */
    open func double(forKey defaultName: StoreKey) -> Double {
        storage.double(forKey: defaultName)
    }

    /**
     Returns the `Bool` associated with the specified `StoreKey`.

     - Parameter defaultName: A `StoreKey` in storage.
     */
    open func bool(forKey defaultName: StoreKey) -> Bool {
        storage.bool(forKey: defaultName)
    }

    /**
     Returns the `URL` associated with the specified `StoreKey`.

     - Parameter defaultName: A `StoreKey` in storage.
     */
    open func url(forKey defaultName: StoreKey) -> URL? {
        storage.url(forKey: defaultName)
    }

    /**
     Sets the value of the specified `StoreKey` to the specified `Int`.

     - Parameter value: `Int` to store.
     - Parameter defaultName: The `StoreKey` with which to associate the value.
     */
    open func set(_ value: Int, forKey defaultName: StoreKey) {
        storage.set(value, forKey: defaultName)
    }

    /**
     Sets the value of the specified `StoreKey` to the specified `Float`.

     - Parameter value: `Float` to store.
     - Parameter defaultName: The `StoreKey` with which to associate the value.
     */
    open func set(_ value: Float, forKey defaultName: StoreKey) {
        storage.set(value, forKey: defaultName)
    }

    /**
     Sets the value of the specified `StoreKey` to the specified `Double`.

     - Parameter value: `Double` to store.
     - Parameter defaultName: The `StoreKey` with which to associate the value.
     */
    open func set(_ value: Double, forKey defaultName: StoreKey) {
        storage.set(value, forKey: defaultName)
    }

    /**
     Sets the value of the specified `StoreKey` to the specified `Bool`.

     - Parameter value: `Bool` to store.
     - Parameter defaultName: The `StoreKey` with which to associate the value.
     */
    open func set(_ value: Bool, forKey defaultName: StoreKey) {
        storage.set(value, forKey: defaultName)
    }

    /**
     Sets the value of the specified `StoreKey` to the specified `URL`.

     - Parameter url: `URL` to store.
     - Parameter defaultName: The `StoreKey` with which to associate the value.
     */
    open func set(_ url: URL?, forKey defaultName: StoreKey) {
        storage.set(url, forKey: defaultName)
    }
}
