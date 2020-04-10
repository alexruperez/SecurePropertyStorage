import Foundation

protocol DataConvertible {
    init?(_ data: Data)
    var data: Data { get }
}

extension DataConvertible {
    var data: Data { withUnsafeBytes(of: self) { Data($0) } }
}

extension DataConvertible where Self: ExpressibleByBooleanLiteral {
    init?(_ data: Data) {
        var value: Self = false
        guard data.count == MemoryLayout.size(ofValue: value) else {
            return nil
        }
        _ = withUnsafeMutableBytes(of: &value) { data.copyBytes(to: $0) }
        self = value
    }
}

extension DataConvertible where Self: ExpressibleByIntegerLiteral {
    init?(_ data: Data) {
        var value: Self = 0
        guard data.count == MemoryLayout.size(ofValue: value) else {
            return nil
        }
        _ = withUnsafeMutableBytes(of: &value) { data.copyBytes(to: $0) }
        self = value
    }
}

extension Bool: DataConvertible {}
extension Int: DataConvertible {}
extension Float: DataConvertible {}
extension Double: DataConvertible {}
extension String: DataConvertible {
    init?(_ data: Data) {
        self.init(data: data, encoding: .utf8)
    }

    var data: Data { Data(utf8) }
}
