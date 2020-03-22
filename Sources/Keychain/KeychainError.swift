import Foundation

public enum KeychainError: Error, CustomStringConvertible {
    case error(_ message: String)

    public var description: String {
        switch self {
        case let .error(message):
            return message
        }
    }
}

public extension OSStatus {
    var message: String { SecCopyErrorMessageString(self, nil) as String? ?? String(self) }
}
