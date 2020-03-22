import CryptoKit
import Foundation
import Keychain
import Storage

open class UserDefaultsStorage: UserDefaults, Storage {
    open override class var standard: UserDefaultsStorage { shared }
    private static let shared = UserDefaultsStorage()
    private var storage: Storage!

    public convenience init(authenticationTag: Data? = nil) {
        self.init(suiteName: nil,
                  symmetricKey: SymmetricKey.generate(),
                  nonce: AES.GCM.Nonce.generate(),
                  authenticationTag: authenticationTag)!
    }

    public init?(suiteName suitename: String?,
                 symmetricKey: SymmetricKey,
                 nonce: AES.GCM.Nonce? = nil,
                 authenticationTag: Data? = nil) {
        super.init(suiteName: suitename)
        storage = DelegatedStorage(self,
                                   symmetricKey: symmetricKey,
                                   nonce: nonce,
                                   authenticationTag: authenticationTag)
    }

    open func data<D: StorageData>(forKey key: String) throws -> D? {
        super.data(forKey: key) as? D
    }

    open func set<D: StorageData>(_ data: D?, forKey defaultName: String) throws {
        super.set(data, forKey: defaultName)
    }

    open func remove(forKey key: String) throws {
        super.removeObject(forKey: key)
    }

    open override func register(defaults registrationDictionary: [String: Any]) {
        storage.register(defaults: registrationDictionary)
    }

    public func value<V>(forKey key: String) -> V? {
        storage.value(forKey: key)
    }

    open func set(_ string: String, forKey key: String) {
        storage.set(string, forKey: key)
    }

    public func set<V>(_ value: V?, forKey key: String) {
        storage.set(value, forKey: key)
    }

    open override func string(forKey defaultName: String) -> String? {
        storage.string(forKey: defaultName)
    }

    open override func array(forKey defaultName: String) -> [Any]? {
        storage.array(forKey: defaultName)
    }

    open override func dictionary(forKey defaultName: String) -> [String: Any]? {
        storage.dictionary(forKey: defaultName)
    }

    open override func stringArray(forKey defaultName: String) -> [String]? {
        storage.stringArray(forKey: defaultName)
    }

    open override func integer(forKey defaultName: String) -> Int {
        storage.integer(forKey: defaultName)
    }

    open override func float(forKey defaultName: String) -> Float {
        storage.float(forKey: defaultName)
    }

    open override func double(forKey defaultName: String) -> Double {
        storage.double(forKey: defaultName)
    }

    open override func bool(forKey defaultName: String) -> Bool {
        storage.bool(forKey: defaultName)
    }

    open override func url(forKey defaultName: String) -> URL? {
        storage.url(forKey: defaultName)
    }

    open override func set(_ value: Int, forKey defaultName: String) {
        storage.set(value, forKey: defaultName)
    }

    open override func set(_ value: Float, forKey defaultName: String) {
        storage.set(value, forKey: defaultName)
    }

    open override func set(_ value: Double, forKey defaultName: String) {
        storage.set(value, forKey: defaultName)
    }

    open override func set(_ value: Bool, forKey defaultName: String) {
        storage.set(value, forKey: defaultName)
    }

    open override func set(_ url: URL?, forKey defaultName: String) {
        storage.set(url, forKey: defaultName)
    }
}
