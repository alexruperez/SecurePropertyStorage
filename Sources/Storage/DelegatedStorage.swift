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

    open func register(defaults registrationDictionary: [String: Any]) {
        registrationDictionary.forEach { key, value in
            if let _: Data = try? data(forKey: key) { return }
            set(value, forKey: key)
        }
    }

    open func value<V>(forKey key: String) -> V? {
        do {
            return try object(forKey: key) as? V
        } catch {
            errorClosure?(error)
            return nil
        }
    }

    open func object(forKey key: String) throws -> Any? {
        guard let data: Data = try data(forKey: key),
            let object = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) else {
                return nil
        }
        return object
    }

    open func string(forKey key: String) -> String? {
        guard let data: Data = try? data(forKey: key),
            let string = String(data) else {
                return nil
        }
        return string
    }

    open func array(forKey key: String) -> [Any]? {
        value(forKey: key)
    }

    open func dictionary(forKey key: String) -> [String: Any]? {
        value(forKey: key)
    }

    open func stringArray(forKey key: String) -> [String]? {
        value(forKey: key)
    }

    open func integer(forKey key: String) -> Int {
        guard let data: Data = try? data(forKey: key),
            let integer = Int(data) else {
                return 0
        }
        return integer
    }

    open func float(forKey key: String) -> Float {
        guard let data: Data = try? data(forKey: key),
            let float = Float(data) else {
                return 0
        }
        return float
    }

    open func double(forKey key: String) -> Double {
        guard let data: Data = try? data(forKey: key),
            let double = Double(data) else {
                return 0
        }
        return double
    }

    open func bool(forKey key: String) -> Bool {
        guard let data: Data = try? data(forKey: key),
            let bool = Bool(data) else {
                return false
        }
        return bool
    }

    open func url(forKey key: String) -> URL? {
        guard let data: Data = try? data(forKey: key) else {
            return nil
        }
        return URL(dataRepresentation: data, relativeTo: nil)
    }

    open func data<D: StorageData>(forKey key: String) throws -> D? {
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

    open func set(_ value: Int, forKey key: String) {
        try? set(value.data, forKey: key)
    }

    open func set(_ value: Float, forKey key: String) {
        try? set(value.data, forKey: key)
    }

    open func set(_ value: Double, forKey key: String) {
        try? set(value.data, forKey: key)
    }

    open func set(_ value: Bool, forKey key: String) {
        try? set(value.data, forKey: key)
    }

    open func set(_ url: URL?, forKey key: String) {
        try? set(url?.dataRepresentation, forKey: key)
    }

    open func set(_ string: String, forKey key: String) {
        try? set(string.data, forKey: key)
    }

    open func set<V>(_ value: V?, forKey key: String) {
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

    open func set<D: StorageData>(_ data: D?, forKey key: String) throws {
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

    open func remove(forKey key: String) throws {
        try delegate.remove(forKey: hash(key))
    }

    private func hash(_ key: String) -> String {
        return SHA512.hash(string: key)
    }
}
