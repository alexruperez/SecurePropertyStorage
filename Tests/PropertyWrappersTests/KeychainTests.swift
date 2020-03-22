import XCTest
import Keychain
import Storage

let keychainTagStorage: DelegatedStorage = KeychainStorage(authenticationTag: Data())

final class KeychainTests: XCTestCase {
    @Store(keychainTagStorage, "keychainTagStore") var keychainTagStore: String?
    @Store(KeychainStorage.standard, "keychainStore") var keychainStore: String?
    @Keychain("keychain") var keychain: String?

    func testKeychainTagStoreError() {
        let keychainStoreError = expectation(description: "keychainTagStoreError")
        keychainTagStorage.errorClosure = { error in
            if case let KeychainError.error(message) = error {
                XCTAssertFalse(message.isEmpty)
                keychainStoreError.fulfill()
            }
        }
        keychainTagStore = "testKeychainTagStore"
        XCTAssertNil(keychainTagStore)
        waitForExpectations(timeout: 1)
    }

    func testKeychainStoreError() {
        let keychainStoreError = expectation(description: "keychainStoreError")
        KeychainStorage.standard.errorClosure = { error in
            if case let KeychainError.error(message) = error {
                XCTAssertFalse(message.isEmpty)
                keychainStoreError.fulfill()
            }
        }
        keychainStore = "testKeychainStore"
        XCTAssertNil(keychainStore)
        waitForExpectations(timeout: 1)
    }

    func testKeychainError() {
        let keychainError = expectation(description: "keychainError")
        KeychainStorage.standard.errorClosure = { error in
            if case let KeychainError.error(message) = error {
                XCTAssertFalse(message.isEmpty)
                keychainError.fulfill()
            }
        }
        keychain = "testKeychain"
        XCTAssertNil(keychain)
        waitForExpectations(timeout: 1)
    }

    func testKeychainDeleteError() {
        let keychainDeleteError = expectation(description: "keychainDeleteError")
        KeychainStorage.standard.errorClosure = { error in
            if case let KeychainError.error(message) = error {
                XCTAssertFalse(message.isEmpty)
                keychainDeleteError.fulfill()
            }
        }
        keychain = nil
        XCTAssertNil(keychain)
        waitForExpectations(timeout: 1)
    }

    static var allTests = [
        ("testKeychainStoreError", testKeychainStoreError),
        ("testKeychainTagStoreError", testKeychainTagStoreError),
        ("testKeychainError", testKeychainError),
        ("testKeychainDeleteError", testKeychainDeleteError)
    ]
}
