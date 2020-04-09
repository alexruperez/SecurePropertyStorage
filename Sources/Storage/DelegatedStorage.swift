import CryptoKit
import Foundation

/// Error closure to handle `StorageDelegate` errors.
public typealias StorageErrorClosure = (Error) -> Void

/// Class with the main `CryptoKit` logic.
open class DelegatedStorage: Storage {
    private let delegate: StorageDelegate?
    private let symmetricKey: SymmetricKey?
    private let nonce: AES.GCM.Nonce?
    private let authenticationTag: Data?
    /// Error closure to handle `StorageDelegate` errors.
    open var errorClosure: StorageErrorClosure?

    /**
    Create a `DelegatedStorage`.

    - Parameter delegate: `StorageDelegate` that stores `StorageData`.
    - Parameter symmetricKey: A cryptographic key used to seal the message.
    - Parameter nonce: A nonce used during the sealing process.
    - Parameter authenticationTag: Custom additional `Data` to be authenticated.
    - Parameter errorClosure: Closure to handle `StorageDelegate` errors.
    */
    public init(_ delegate: StorageDelegate? = nil,
                symmetricKey: SymmetricKey? = nil,
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
            if let _: Data = data(forKey: key) { return }
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

    /**
    Returns the `NSCoding` conforming object associated with the specified `StoreKey`.

    - Parameter key: A `StoreKey` in storage.
    */
    open func object(forKey key: StoreKey) throws -> Any? {
        guard let data: Data = data(forKey: key),
            let object = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) else {
            return nil
        }
        return object
    }

    open func decodable<D: Decodable>(forKey key: StoreKey) -> D? {
        do {
            guard let data: Data = data(forKey: key) else {
                return nil
            }
            return try data.decode(D.self)
        } catch {
            errorClosure?(error)
            return nil
        }
    }

    open func string(forKey key: StoreKey) -> String? {
        guard let data: Data = data(forKey: key),
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
        guard let data: Data = data(forKey: key),
            let integer = Int(data) else {
            return 0
        }
        return integer
    }

    open func float(forKey key: StoreKey) -> Float {
        guard let data: Data = data(forKey: key),
            let float = Float(data) else {
            return 0
        }
        return float
    }

    open func double(forKey key: StoreKey) -> Double {
        guard let data: Data = data(forKey: key),
            let double = Double(data) else {
            return 0
        }
        return double
    }

    open func bool(forKey key: StoreKey) -> Bool {
        guard let data: Data = data(forKey: key),
            let bool = Bool(data) else {
            return false
        }
        return bool
    }

    open func url(forKey key: StoreKey) -> URL? {
        guard let data: Data = data(forKey: key) else {
            return nil
        }
        return URL(dataRepresentation: data, relativeTo: nil)
    }

    open func data<D: StorageData>(forKey key: StoreKey) -> D? {
        do {
            guard let data: Data = try delegate?.data(forKey: hash(key)),
                let symmetricKey = symmetricKey else {
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
        } catch {
            errorClosure?(error)
            return nil
        }
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
            try set(object: value, forKey: key)
        } catch {
            guard let encodable = value as? Encodable else {
                errorClosure?(error)
                return
            }
            set(encodable: encodable, forKey: key)
        }
    }

    /**
    Sets the value of the specified `StoreKey` to the specified `NSCoding` conforming object.

    - Parameter value: `NSCoding` conforming object.
    - Parameter key: The `StoreKey` with which to associate the value.
    */
    open func set(object: Any?, forKey key: StoreKey) throws {
        guard let object = object else {
            remove(forKey: key)
            return
        }
        let data = try NSKeyedArchiver.archivedData(withRootObject: object,
                                                    requiringSecureCoding: object is NSSecureCoding)
        try set(data, forKey: key)
    }

    open func set(encodable: Encodable?, forKey key: StoreKey) {
        guard let encodable = encodable else {
            remove(forKey: key)
            return
        }
        do {
            let data = try encodable.encode()
            try set(data, forKey: key)
        } catch {
            errorClosure?(error)
        }
    }

    open func set<D: StorageData>(_ data: D?, forKey key: StoreKey) throws {
        guard let bytes = data,
            let symmetricKey = symmetricKey else {
            remove(forKey: key)
            return
        }
        if let authenticationTag = authenticationTag {
            let sealedBox = try AES.GCM.seal(bytes.data,
                                             using: symmetricKey,
                                             nonce: nonce,
                                             authenticating: authenticationTag)
            try delegate?.set(sealedBox.combined, forKey: hash(key))
        } else {
            let sealedBox = try AES.GCM.seal(bytes.data,
                                             using: symmetricKey,
                                             nonce: nonce)
            try delegate?.set(sealedBox.combined, forKey: hash(key))
        }
    }

    open func remove(forKey key: StoreKey) {
        do {
            try delegate?.remove(forKey: hash(key))
        } catch {
            errorClosure?(error)
        }
    }

    /// Hash `StoreKey` using SHA-512.
    public func hash(_ key: StoreKey) -> String {
        SHA512.hash(string: key)
    }
}
