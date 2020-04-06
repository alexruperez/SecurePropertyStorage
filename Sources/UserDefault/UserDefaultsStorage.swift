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

    open func data<D: StorageData>(forKey key: StoreKey) -> D? {
        super.data(forKey: key) as? D
    }

    open func set<D: StorageData>(_ data: D?, forKey defaultName: StoreKey) {
        super.set(data, forKey: defaultName)
    }

    open func remove(forKey key: StoreKey) {
        super.removeObject(forKey: key)
    }

    open override func register(defaults registrationDictionary: [StoreKey: Any]) {
        storage.register(defaults: registrationDictionary)
    }

    open func value<V>(forKey key: StoreKey) -> V? {
        storage.value(forKey: key)
    }

    open func decodable<D: Decodable>(forKey key: StoreKey) -> D? {
        storage.decodable(forKey: key)
    }

    open func set(_ string: String, forKey key: StoreKey) {
        storage.set(string, forKey: key)
    }

    open func set<V>(_ value: V?, forKey key: StoreKey) {
        storage.set(value, forKey: key)
    }

    open func set(encodable: Encodable?, forKey key: StoreKey) {
        storage.set(encodable: encodable, forKey: key)
    }

    open override func string(forKey defaultName: StoreKey) -> String? {
        storage.string(forKey: defaultName)
    }

    open override func array(forKey defaultName: StoreKey) -> [Any]? {
        storage.array(forKey: defaultName)
    }

    open override func dictionary(forKey defaultName: StoreKey) -> [String: Any]? {
        storage.dictionary(forKey: defaultName)
    }

    open override func stringArray(forKey defaultName: StoreKey) -> [String]? {
        storage.stringArray(forKey: defaultName)
    }

    open override func integer(forKey defaultName: StoreKey) -> Int {
        storage.integer(forKey: defaultName)
    }

    open override func float(forKey defaultName: StoreKey) -> Float {
        storage.float(forKey: defaultName)
    }

    open override func double(forKey defaultName: StoreKey) -> Double {
        storage.double(forKey: defaultName)
    }

    open override func bool(forKey defaultName: StoreKey) -> Bool {
        storage.bool(forKey: defaultName)
    }

    open override func url(forKey defaultName: StoreKey) -> URL? {
        storage.url(forKey: defaultName)
    }

    open override func set(_ value: Int, forKey defaultName: StoreKey) {
        storage.set(value, forKey: defaultName)
    }

    open override func set(_ value: Float, forKey defaultName: StoreKey) {
        storage.set(value, forKey: defaultName)
    }

    open override func set(_ value: Double, forKey defaultName: StoreKey) {
        storage.set(value, forKey: defaultName)
    }

    open override func set(_ value: Bool, forKey defaultName: StoreKey) {
        storage.set(value, forKey: defaultName)
    }

    open override func set(_ url: URL?, forKey defaultName: StoreKey) {
        storage.set(url, forKey: defaultName)
    }
}
