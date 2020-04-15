import CryptoKit
import Foundation

/// Indicates that the conforming type is a contiguous collection of raw bytes
/// whose underlying storage is directly accessible by withUnsafeBytes.
public protocol StorageData: ContiguousBytes {
    /**
     Create a `StorageData`.

     - Parameter bytes: `ContiguousBytes` of `StorageData`.
     */
    init<B: StorageData>(bytes: B) throws
}

public extension ContiguousBytes {
    /// `Data` representation.
    var data: Data {
        withUnsafeBytes {
            let pointer = $0.baseAddress?.assumingMemoryBound(to: UInt8.self)
            let cfdata = CFDataCreateWithBytesNoCopy(nil,
                                                     pointer,
                                                     $0.count,
                                                     kCFAllocatorNull)
            return ((cfdata as NSData?) as Data?) ?? Data()
        }
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
    public init<B: StorageData>(bytes: B) {
        self = bytes.data
    }

    func decode<D: Decodable>(_ type: D.Type) throws -> D {
        try JSONDecoder().decode(type, from: self)
    }
}
