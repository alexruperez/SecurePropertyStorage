import CryptoKit
import Foundation
import Storage

extension SymmetricKey: StorageData {
    public init<B: ContiguousBytes>(bytes: B) throws {
        self.init(data: bytes)
    }

    public static func generate() -> SymmetricKey {
        let account = "SecurePropertyStorage.SymmetricKey"
        let keychainStorage = KeychainStorageDelegate()
        do {
            guard let symmetricKey: SymmetricKey = try keychainStorage.read(account: account) else {
                let symmetricKey = SymmetricKey(size: .bits256)
                print("Symmetric key created. \(symmetricKey.description)")
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
    public init<B: ContiguousBytes>(bytes: B) throws {
        try self.init(data: bytes.data)
    }

    public static func generate() -> AES.GCM.Nonce {
        let account = "SecurePropertyStorage.Nonce"
        let keychainStorage = KeychainStorageDelegate()
        do {
            guard let nonce: AES.GCM.Nonce = try keychainStorage.read(account: account) else {
                let nonce = AES.GCM.Nonce()
                print("Nonce created. \(nonce.description)")
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
