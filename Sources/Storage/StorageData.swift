import Foundation
import CryptoKit

public protocol StorageData: ContiguousBytes, CustomStringConvertible {
    init<B: ContiguousBytes>(bytes: B) throws
}

public extension ContiguousBytes {
    var data: Data {
        withUnsafeBytes {
            let pointer = $0.baseAddress?.assumingMemoryBound(to: UInt8.self)
            let cfdata = CFDataCreateWithBytesNoCopy(nil,
                                                     pointer,
                                                     $0.count,
                                                     kCFAllocatorNull)
            return((cfdata as NSData?) as Data?) ?? Data()
        }
    }
}

public extension StorageData {
    var description: String {
        data.withUnsafeBytes { "Data representation contains \($0.count) bytes." }
    }
}

extension HashFunction {
    public static func hash(string: String) -> String {
        hash(data: string.data).compactMap { String(format: "%02x", $0) }.joined()
    }
}

extension Data: StorageData {
    public init<B: ContiguousBytes>(bytes: B) throws {
        self = bytes.data
    }
}
