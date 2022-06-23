import Foundation

/// Keychain error enum.
public enum KeychainError: Error, CustomStringConvertible {
    /// Error with message.
    case error(_ message: String)

    public var description: String {
        switch self {
        case let .error(message):
            return message
        }
    }
}

public extension OSStatus {
    /// Returns a string explaining the meaning of a security result code.
    var message: String { SecCopyErrorMessageString(self, nil) as String? ?? String(self) }
}
