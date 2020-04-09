import CryptoKit
import Foundation
import Keychain
import Storage

/// `SingletonStorage` subclass of `DelegatedStorage` that uses a `SingletonStorageDelegate`.
open class SingletonStorage: DelegatedStorage {
    /// `SingletonStorage` shared instance.
    open class var standard: SingletonStorage { shared }
    private static let shared = SingletonStorage()

    /**
    Create a `SingletonStorage`.

    - Parameter delegate: `StorageDelegate`, defaults `SingletonStorageDelegate`.
    - Parameter authenticationTag: Custom additional `Data` to be authenticated.
    */
    public convenience init(_ delegate: StorageDelegate = SingletonStorageDelegate(),
                            authenticationTag: Data? = nil) {
        self.init(delegate,
                  symmetricKey: SymmetricKey.generate(),
                  nonce: AES.GCM.Nonce.generate(),
                  authenticationTag: authenticationTag)
    }
}

/// `SingletonStorageDelegate` conforming `StorageDelegate` protocol.
open class SingletonStorageDelegate: StorageDelegate {
    private var storage = [AnyHashable: Any]()

    /// Create a `SingletonStorageDelegate`.
    public init() {}

    /**
    Get `StorageData` for `StoreKey` from the keychain.

    - Parameter key: `StoreKey` to store the `StorageData`.

    - Returns: `StorageData` for `StoreKey`.
    */
    open func data<D: StorageData>(forKey key: StoreKey) -> D? { storage[key] as? D }

    /**
    Set `StorageData` for `StoreKey` in the keychain.

    - Parameter data: `StorageData` to store.
    - Parameter key: `StoreKey` to store the `StorageData`.
    */
    open func set<D: StorageData>(_ data: D?, forKey key: StoreKey) { storage[key] = data }

    /**
    Remove `StorageData` for `StoreKey` from the keychain.

    - Parameter key: `StoreKey` to remove.
    */
    open func remove(forKey key: StoreKey) { storage.removeValue(forKey: key) }
}
