import CryptoKit
import Foundation
import Storage

open class KeychainStorage: DelegatedStorage {
    open class var standard: KeychainStorage { shared }
    private static let shared = KeychainStorage()

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

open class KeychainStorageDelegate: StorageDelegate {
    public init() {}

    open func data<D: StorageData>(forKey key: StoreKey) throws -> D? {
        try read(account: key)
    }

    open func set<D: StorageData>(_ data: D?, forKey key: StoreKey) throws {
        try remove(forKey: key)
        if let data = data {
            try store(data, account: key)
        }
    }

    open func remove(forKey key: StoreKey) throws {
        try delete(account: key)
    }

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
