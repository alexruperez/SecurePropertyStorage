import CryptoKit
import Foundation
import Storage

extension SymmetricKey: StorageData {
    /**
     Create a `SymmetricKey`.

     - Parameter bytes: `StorageData` of `SymmetricKey`.

     - Throws: `CipherError` errors.
     */
    public init(bytes: some StorageData) throws {
        self.init(data: bytes)
    }

    /// Generate a `SymmetricKey` and store it on the keychain.
    public static func generate(key: String = "SecurePropertyStorage.SymmetricKey",
                                accessible: CFString = kSecAttrAccessibleWhenUnlocked,
                                accessGroup: String? = nil,
                                synchronizable: Bool = false,
                                secClass: CFString = kSecClassGenericPassword) -> SymmetricKey {
        let keychainStorage = KeychainStorageDelegate()
        do {
            guard let symmetricKey: SymmetricKey = try keychainStorage.read(key: key,
                                                                            accessGroup: accessGroup,
                                                                            synchronizable: synchronizable,
                                                                            secClass: secClass) else {
                let symmetricKey = SymmetricKey(size: .bits256)
                try keychainStorage.store(symmetricKey,
                                          key: key,
                                          accessible: accessible,
                                          accessGroup: accessGroup,
                                          synchronizable: synchronizable,
                                          secClass: secClass)
                return symmetricKey
            }
            return symmetricKey
        } catch {
            if let error = error as? KeychainError {
                print(error.description)
            } else {
                assertionFailure(error.localizedDescription)
            }
            return SymmetricKey(size: .bits256)
        }
    }
}
