import CryptoKit
import Foundation

/// Indicates that the conforming type is a contiguous collection of raw bytes
/// whose underlying storage is directly accessible by withUnsafeBytes.
public protocol StorageData: ContiguousBytes {
    /**
     Create a `StorageData`.

     - Parameter bytes: `ContiguousBytes` of `StorageData`.
     */
    init(bytes: some StorageData) throws
}

public extension ContiguousBytes {
    /// `Data` representation.
    var data: Data {
        withUnsafeBytes { Data($0) }
    }
}

extension HashFunction {
    static func hash(string: String) -> String {
        hash(data: string.data).compactMap { String(format: "%02x", $0) }.joined()
    }
}

extension Encodable {
    func encode() throws -> Data {
        try JSONEncoder().encode(self)
    }
}

extension Data: StorageData {
    /**
     Create a `Data`.

     - Parameter bytes: `StorageData` of `Data`.
     */
    public init(bytes: some StorageData) {
        self = bytes.data
    }

    func decode<D: Decodable>(_ type: D.Type) throws -> D {
        try JSONDecoder().decode(type, from: self)
    }
}
