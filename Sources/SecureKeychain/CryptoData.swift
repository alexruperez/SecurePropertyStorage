import CryptoKit
import Foundation
import SecureStorage

extension SymmetricKey: StorageData {
    /**
     Create a `SymmetricKey`.

     - Parameter bytes: `StorageData` of `SymmetricKey`.

     - Throws: `CipherError` errors.
     */
    public init<B: StorageData>(bytes: B) throws {
        self.init(data: bytes)
    }

    /// Generate a `SymmetricKey` and store it on the keychain.
    public static func generate(accessible: CFString = kSecAttrAccessibleWhenUnlocked,
                                accessGroup: String? = nil,
                                synchronizable: Bool = false) -> SymmetricKey {
        let account = "SecurePropertyStorage.SymmetricKey"
        let keychainStorage = KeychainStorageDelegate()
        do {
            guard let symmetricKey: SymmetricKey = try keychainStorage.read(account: account,
                                                                            accessGroup: accessGroup,
                                                                            synchronizable: synchronizable) else {
                let symmetricKey = SymmetricKey(size: .bits256)
                try keychainStorage.store(symmetricKey,
                                          account: account,
                                          accessible: accessible,
                                          accessGroup: accessGroup,
                                          synchronizable: synchronizable)
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
