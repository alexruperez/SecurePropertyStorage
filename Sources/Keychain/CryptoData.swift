import CryptoKit
import Foundation
import Storage

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
    public static func generate() -> SymmetricKey {
        let account = "SecurePropertyStorage.SymmetricKey"
        let keychainStorage = KeychainStorageDelegate()
        do {
            guard let symmetricKey: SymmetricKey = try keychainStorage.read(account: account) else {
                let symmetricKey = SymmetricKey(size: .bits256)
                try keychainStorage.store(symmetricKey, account: account)
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

extension AES.GCM.Nonce: StorageData {
    /**
     Create a `AES.GCM.Nonce`.

     - Parameter bytes: `StorageData` of `AES.GCM.Nonce`.

     - Throws: `CipherError` errors.
     */
    public init<B: StorageData>(bytes: B) throws {
        try self.init(data: bytes.data)
    }

    /// Generate a `AES.GCM.Nonce` and store it on the keychain.
    public static func generate() -> AES.GCM.Nonce {
        let account = "SecurePropertyStorage.Nonce"
        let keychainStorage = KeychainStorageDelegate()
        do {
            guard let nonce: AES.GCM.Nonce = try keychainStorage.read(account: account) else {
                let nonce = AES.GCM.Nonce()
                try keychainStorage.store(nonce, account: account)
                return nonce
            }
            return nonce
        } catch {
            if let error = error as? KeychainError {
                print(error.description)
            } else {
                assertionFailure(error.localizedDescription)
            }
            return AES.GCM.Nonce()
        }
    }
}
