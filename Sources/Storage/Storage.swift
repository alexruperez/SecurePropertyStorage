import Foundation

public protocol Storage: StorageDelegate {
    func register(defaults registration: [String: Any])
    func value<V>(forKey key: String) -> V?
    func string(forKey key: String) -> String?
    func array(forKey key: String) -> [Any]?
    func dictionary(forKey key: String) -> [String: Any]?
    func stringArray(forKey key: String) -> [String]?
    func integer(forKey key: String) -> Int
    func float(forKey key: String) -> Float
    func double(forKey key: String) -> Double
    func bool(forKey key: String) -> Bool
    func url(forKey key: String) -> URL?
    func set(_ value: Int, forKey key: String)
    func set(_ value: Float, forKey key: String)
    func set(_ value: Double, forKey key: String)
    func set(_ value: Bool, forKey key: String)
    func set(_ url: URL?, forKey key: String)
    func set(_ string: String, forKey key: String)
    func set<V>(_ value: V?, forKey key: String)
}
