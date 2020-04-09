import CryptoKit
import Foundation
import Storage

/// `KeychainStorage` subclass of `DelegatedStorage` that uses a `KeychainStorageDelegate`.
open class KeychainStorage: DelegatedStorage {
    /// `KeychainStorage` shared instance.
    open class var standard: KeychainStorage { shared }
    private static let shared = KeychainStorage()

    /**
     Create a `KeychainStorage`.

     - Parameter delegate: `StorageDelegate`, defaults `KeychainStorageDelegate`.
     - Parameter authenticationTag: Custom additional `Data` to be authenticated.
     - Parameter errorClosure: Closure to handle `KeychainStorageDelegate` errors.
     */
    public convenience init(_ delegate: StorageDelegate = KeychainStorageDelegate(),
                            authenticationTag: Data? = nil,
                            errorClosure: StorageErrorClosure? = nil) {
        self.init(delegate,
                  symmetricKey: SymmetricKey.generate(),
                  nonce: AES.GCM.Nonce.generate(),
                  authenticationTag: authenticationTag,
                  errorClosure: errorClosure)
    }
}

/// `KeychainStorageDelegate` conforming `StorageDelegate` protocol.
open class KeychainStorageDelegate: StorageDelegate {
    /// Create a `KeychainStorageDelegate`.
    public init() {}

    /**
     Get `StorageData` for `StoreKey` from the keychain.

     - Parameter key: `StoreKey` to store the `StorageData`.

     - Throws: `KeychainError.error`.

     - Returns: `StorageData` for `StoreKey`.
     */
    open func data<D: StorageData>(forKey key: StoreKey) throws -> D? {
        try read(account: key)
    }

    /**
     Set `StorageData` for `StoreKey` in the keychain.

     - Parameter data: `StorageData` to store.
     - Parameter key: `StoreKey` to store the `StorageData`.

     - Throws: `KeychainError.error`.
     */
    open func set<D: StorageData>(_ data: D?, forKey key: StoreKey) throws {
        try remove(forKey: key)
        if let data = data {
            try store(data, account: key)
        }
    }

    /**
     Remove `StorageData` for `StoreKey` from the keychain.

     - Parameter key: `StoreKey` to remove.

     - Throws: `KeychainError.error`.
     */
    open func remove(forKey key: StoreKey) throws {
        try delete(account: key)
    }

    /**
     Store `StorageData` for account in the keychain.

     - Parameter value: `StorageData` to store.
     - Parameter account: Item's account name.
     - Parameter accessible: When the keychain item is accessible.

     - Throws: `KeychainError.error`.
     */
    open func store<D: StorageData>(_ value: D,
                                    account: String,
                                    accessible: CFString = kSecAttrAccessibleWhenUnlocked) throws {
        let query = [kSecClass: kSecClassGenericPassword,
                     kSecAttrAccount: account,
                     kSecAttrAccessible: accessible,
                     kSecUseDataProtectionKeychain: true,
                     kSecValueData: value.data] as [String: Any]
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainError.error("Unable to store item: \(status.message)")
        }
    }

    /**
     Read `StorageData` for account from the keychain.

     - Parameter account: Item's account name.

     - Throws: `KeychainError.error`.

     - Returns: `StorageData` for account.
     */
    open func read<D: StorageData>(account: String) throws -> D? {
        let query = [kSecClass: kSecClassGenericPassword,
                     kSecAttrAccount: account,
                     kSecUseDataProtectionKeychain: true,
                     kSecReturnData: true] as [String: Any]

        var item: CFTypeRef?
        switch SecItemCopyMatching(query as CFDictionary, &item) {
        case errSecSuccess:
            guard let bytes = item as? Data else { return nil }
            return try D(bytes: bytes)
        case errSecItemNotFound: return nil
        case let status: throw KeychainError.error("Keychain read failed: \(status.message)")
        }
    }

    /**
     Delete item for account from the keychain.

     - Parameter account: Item's account name.

     - Throws: `KeychainError.error`.
     */
    open func delete(account: String) throws {
        let query = [kSecClass: kSecClassGenericPassword,
                     kSecUseDataProtectionKeychain: true,
                     kSecAttrAccount: account] as [String: Any]
        switch SecItemDelete(query as CFDictionary) {
        case errSecItemNotFound, errSecSuccess: break
        case let status:
            throw KeychainError.error("Unexpected deletion error: \(status.message)")
        }
    }
}
