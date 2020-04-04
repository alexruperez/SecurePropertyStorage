import CryptoKit
import Foundation

public typealias StorageErrorClosure = (Error) -> Void

open class DelegatedStorage: Storage {
    private let delegate: StorageDelegate
    private let symmetricKey: SymmetricKey
    private let nonce: AES.GCM.Nonce?
    private let authenticationTag: Data?
    open var errorClosure: StorageErrorClosure?

    public init(_ delegate: StorageDelegate,
                symmetricKey: SymmetricKey,
                nonce: AES.GCM.Nonce? = nil,
                authenticationTag: Data? = nil,
                errorClosure: StorageErrorClosure? = nil) {
        self.delegate = delegate
        self.symmetricKey = symmetricKey
        self.nonce = nonce
        self.authenticationTag = authenticationTag
        self.errorClosure = errorClosure
    }

    open func register(defaults registrationDictionary: [StoreKey: Any]) {
        registrationDictionary.forEach { key, value in
            if let _: Data = try? data(forKey: key) { return }
            set(value, forKey: key)
        }
    }

    open func value<V>(forKey key: StoreKey) -> V? {
        do {
            return try object(forKey: key) as? V
        } catch {
            errorClosure?(error)
            return nil
        }
    }

    open func object(forKey key: StoreKey) throws -> Any? {
        guard let data: Data = try data(forKey: key),
            let object = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) else {
                return nil
        }
        return object
    }

    open func string(forKey key: StoreKey) -> String? {
        guard let data: Data = try? data(forKey: key),
            let string = String(data) else {
                return nil
        }
        return string
    }

    open func array(forKey key: StoreKey) -> [Any]? {
        value(forKey: key)
    }

    open func dictionary(forKey key: StoreKey) -> [String: Any]? {
        value(forKey: key)
    }

    open func stringArray(forKey key: StoreKey) -> [String]? {
        value(forKey: key)
    }

    open func integer(forKey key: StoreKey) -> Int {
        guard let data: Data = try? data(forKey: key),
            let integer = Int(data) else {
                return 0
        }
        return integer
    }

    open func float(forKey key: StoreKey) -> Float {
        guard let data: Data = try? data(forKey: key),
            let float = Float(data) else {
                return 0
        }
        return float
    }

    open func double(forKey key: StoreKey) -> Double {
        guard let data: Data = try? data(forKey: key),
            let double = Double(data) else {
                return 0
        }
        return double
    }

    open func bool(forKey key: StoreKey) -> Bool {
        guard let data: Data = try? data(forKey: key),
            let bool = Bool(data) else {
                return false
        }
        return bool
    }

    open func url(forKey key: StoreKey) -> URL? {
        guard let data: Data = try? data(forKey: key) else {
            return nil
        }
        return URL(dataRepresentation: data, relativeTo: nil)
    }

    open func data<D: StorageData>(forKey key: StoreKey) throws -> D? {
        guard let data: Data = try delegate.data(forKey: hash(key)) else {
            return nil
        }
        let sealedBox = try AES.GCM.SealedBox(combined: data)
        if let authenticationTag = authenticationTag {
            return try AES.GCM.open(sealedBox,
                                    using: symmetricKey,
                                    authenticating: authenticationTag) as? D
        }
        return try AES.GCM.open(sealedBox,
                                using: symmetricKey) as? D
    }

    open func set(_ value: Int, forKey key: StoreKey) {
        try? set(value.data, forKey: key)
    }

    open func set(_ value: Float, forKey key: StoreKey) {
        try? set(value.data, forKey: key)
    }

    open func set(_ value: Double, forKey key: StoreKey) {
        try? set(value.data, forKey: key)
    }

    open func set(_ value: Bool, forKey key: StoreKey) {
        try? set(value.data, forKey: key)
    }

    open func set(_ url: URL?, forKey key: StoreKey) {
        try? set(url?.dataRepresentation, forKey: key)
    }

    open func set(_ string: String, forKey key: StoreKey) {
        try? set(string.data, forKey: key)
    }

    open func set<V>(_ value: V?, forKey key: StoreKey) {
        do {
            guard let value = value else {
                try remove(forKey: key)
                return
            }
            let data = try NSKeyedArchiver.archivedData(withRootObject: value,
                                                        requiringSecureCoding: value is NSSecureCoding)
            try set(data, forKey: key)
        } catch {
            errorClosure?(error)
        }
    }

    open func set<D: StorageData>(_ data: D?, forKey key: StoreKey) throws {
        guard let bytes = data else {
            try remove(forKey: key)
            return
        }
        if let authenticationTag = authenticationTag {
            let sealedBox = try AES.GCM.seal(bytes.data,
                                             using: symmetricKey,
                                             nonce: nonce,
                                             authenticating: authenticationTag)
            try delegate.set(sealedBox.combined, forKey: hash(key))
        } else {
            let sealedBox = try AES.GCM.seal(bytes.data,
                                             using: symmetricKey,
                                             nonce: nonce)
            try delegate.set(sealedBox.combined, forKey: hash(key))
        }
    }

    open func remove(forKey key: StoreKey) throws {
        try delegate.remove(forKey: hash(key))
    }

    private func hash(_ key: StoreKey) -> String {
        return SHA512.hash(string: key)
    }
}
