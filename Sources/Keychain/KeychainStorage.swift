import CryptoKit
import Foundation
import Storage

/// `KeychainStorage` subclass of `DelegatedStorage` that uses a `KeychainStorageDelegate`.
open class KeychainStorage: DelegatedStorage {
    /// `KeychainStorage` shared instance.
    open class var standard: KeychainStorage { shared }
    nonisolated(unsafe) private static let shared = KeychainStorage()
    private var keychainDelegate: KeychainStorageDelegate? { delegate as? KeychainStorageDelegate }

    /// Access group where `StorageData` is in.
    open var accessGroup: String? {
        get { keychainDelegate?.accessGroup }
        set { keychainDelegate?.accessGroup = newValue }
    }

    /// Whether the `StorageData` can be synchronized.
    open var synchronizable: Bool {
        get { keychainDelegate?.synchronizable ?? false }
        set { keychainDelegate?.synchronizable = newValue }
    }

    /// When `StorageData` can be accessed in the keychain.
    open var accessible: CFString {
        get { keychainDelegate?.accessible ?? kSecAttrAccessibleWhenUnlocked }
        set { keychainDelegate?.accessible = newValue }
    }

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
                  authenticationTag: authenticationTag,
                  errorClosure: errorClosure)
    }
}

/// `KeychainStorageDelegate` conforming `StorageDelegate` protocol.
open class KeychainStorageDelegate: StorageDelegate {
    /// Access group where `StorageData` is in.
    open var accessGroup: String?
    /// Whether the `StorageData` can be synchronized.
    open var synchronizable = false
    /// When `StorageData` can be accessed in the keychain.
    open var accessible: CFString = kSecAttrAccessibleWhenUnlocked
    /// Specifies item class used.
    open var secClass: CFString = kSecClassGenericPassword

    /// Create a `KeychainStorageDelegate`.
    public init() {}

    /**
     Get `StorageData` for `StoreKey` from the keychain.

     - Parameter key: `StoreKey` to store the `StorageData`.

     - Throws: `KeychainError.error`.

     - Returns: `StorageData` for `StoreKey`.
     */
    open func data<D: StorageData>(forKey key: StoreKey) throws -> D? {
        try read(key: key,
                 accessGroup: accessGroup,
                 synchronizable: synchronizable,
                 secClass: secClass,
                 returnAttributes: nil,
                 returnData: true)
    }

    /**
     Set `StorageData` for `StoreKey` in the keychain.

     - Parameter data: `StorageData` to store.
     - Parameter key: `StoreKey` to store the `StorageData`.

     - Throws: `KeychainError.error`.
     */
    open func set(_ data: (some StorageData)?, forKey key: StoreKey) throws {
        try? remove(forKey: key)
        if let data {
            try store(data,
                      key: key,
                      accessible: accessible,
                      accessGroup: accessGroup,
                      synchronizable: synchronizable,
                      secClass: secClass)
        }
    }

    /**
     Remove `StorageData` for `StoreKey` from the keychain.

     - Parameter key: `StoreKey` to remove.

     - Throws: `KeychainError.error`.
     */
    open func remove(forKey key: StoreKey) throws {
        try delete(key: key,
                   accessGroup: accessGroup,
                   synchronizable: synchronizable,
                   secClass: secClass)
    }

    /**
     Store `StorageData` for account in the keychain.

     - Parameter value: `StorageData` to store.
     - Parameter account: Item's account name.
     - Parameter accessible: When the keychain item is accessible.
     - Parameter accessGroup: Access group where `StorageData` is in.
     - Parameter synchronizable: Whether the `StorageData` can be synchronized.
     - Parameter secClass: Specifies item class used.

     - Throws: `KeychainError.error`.
     */
    open func store(_ value: some StorageData,
                    key: String,
                    accessible: CFString = kSecAttrAccessibleWhenUnlocked,
                    accessGroup: String? = nil,
                    synchronizable: Bool = false,
                    secClass: CFString = kSecClassGenericPassword) throws {
        var query = [kSecClass: secClass,
                     kSecAttrAccount: key,
                     kSecAttrAccessible: accessible,
                     kSecUseDataProtectionKeychain: true,
                     kSecValueData: value.data] as [CFString: Any]
        if let accessGroup {
            query[kSecAttrAccessGroup] = accessGroup
        }
        if synchronizable {
            query[kSecAttrSynchronizable] = kCFBooleanTrue
        }

        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainError.error("Unable to store item: \(status.message)")
        }
    }

    /**
     Read `StorageData` for account from the keychain.

     - Parameter account: Item's account name.
     - Parameter accessGroup: Access group where `StorageData` is in.
     - Parameter synchronizable: Whether the `StorageData` can be synchronized.
     - Parameter secClass: Specifies item class used.
     - Parameter returnAttributes: Return item attributes.
     - Parameter returnData: Return item data.

     - Throws: `KeychainError.error`.

     - Returns: `StorageData` for account.
     */
    open func read<D: StorageData>(key: String,
                                   accessGroup: String? = nil,
                                   synchronizable: Bool = false,
                                   secClass: CFString = kSecClassGenericPassword,
                                   returnAttributes: Bool? = nil,
                                   returnData: Bool = true) throws -> D? {
        var query = [kSecClass: secClass,
                     kSecAttrAccount: key,
                     kSecUseDataProtectionKeychain: true,
                     kSecReturnData: returnData] as [CFString: Any]
        if let accessGroup {
            query[kSecAttrAccessGroup] = accessGroup
        }
        if synchronizable {
            query[kSecAttrSynchronizable] = kCFBooleanTrue
        }
        if let returnAttributes {
            query[kSecReturnAttributes] = returnAttributes
        }

        var item: CFTypeRef?
        switch SecItemCopyMatching(query as CFDictionary, &item) {
        case errSecSuccess:
            guard let bytes = item as? Data else {
                return nil
            }
            return try D(bytes: bytes)
        case errSecItemNotFound:
            return nil
        case let status:
            throw KeychainError.error("Keychain read failed: \(status.message)")
        }
    }

    /**
     Delete item for account from the keychain.

     - Parameter account: Item's account name.
     - Parameter accessGroup: Access group where `StorageData` is in.
     - Parameter synchronizable: Whether the `StorageData` can be synchronized.
     - Parameter secClass: Specifies item class used.

     - Throws: `KeychainError.error`.
     */
    open func delete(key: String,
                     accessGroup: String? = nil,
                     synchronizable: Bool = false,
                     secClass: CFString = kSecClassGenericPassword) throws {
        var query = [kSecClass: secClass,
                     kSecUseDataProtectionKeychain: true,
                     kSecAttrAccount: key] as [CFString: Any]
        if let accessGroup {
            query[kSecAttrAccessGroup] = accessGroup
        }
        if synchronizable {
            query[kSecAttrSynchronizable] = kCFBooleanTrue
        }

        switch SecItemDelete(query as CFDictionary) {
        case errSecItemNotFound, errSecSuccess:
            break
        case let status:
            throw KeychainError.error("Unexpected deletion error: \(status.message)")
        }
    }
}
