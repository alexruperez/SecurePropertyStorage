import Foundation

public typealias StoreKey = String

public protocol Storage: StorageDelegate {
    func register(defaults registration: [StoreKey: Any])
    func value<V>(forKey key: StoreKey) -> V?
    func decodable<D: Decodable>(forKey key: StoreKey) -> D?
    func string(forKey key: StoreKey) -> String?
    func array(forKey key: StoreKey) -> [Any]?
    func dictionary(forKey key: StoreKey) -> [String: Any]?
    func stringArray(forKey key: StoreKey) -> [String]?
    func integer(forKey key: StoreKey) -> Int
    func float(forKey key: StoreKey) -> Float
    func double(forKey key: StoreKey) -> Double
    func bool(forKey key: StoreKey) -> Bool
    func url(forKey key: StoreKey) -> URL?
    func set(_ value: Int, forKey key: StoreKey)
    func set(_ value: Float, forKey key: StoreKey)
    func set(_ value: Double, forKey key: StoreKey)
    func set(_ value: Bool, forKey key: StoreKey)
    func set(_ url: URL?, forKey key: StoreKey)
    func set(_ string: String, forKey key: StoreKey)
    func set<V>(_ value: V?, forKey key: StoreKey)
    func set(encodable: Encodable?, forKey key: StoreKey)
}
