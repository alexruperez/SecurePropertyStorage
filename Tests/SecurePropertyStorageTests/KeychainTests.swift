import Keychain
import Storage
import XCTest

enum KeychainCodable: String, Codable {
    case test
    case test2
}

let keychainTagStorage: DelegatedStorage = KeychainStorage(authenticationTag: Data())

final class KeychainTests: XCTestCase {
    @Store(keychainTagStorage, "keychainTagStore")
    var keychainTagStore: String?
    @Store(KeychainStorage.standard, "keychainStore")
    var keychainStore: String?
    @Keychain("keychain")
    var keychain: String?
    @Store(keychainTagStorage, "keychainTagDefault")
    var keychainTagDefault = "tagDefault"
    @Keychain("keychainDefault")
    var keychainDefault = "default"
    @CodableStore(keychainTagStorage, "keychainTagCodable")
    var keychainTagCodable = KeychainCodable.test
    @CodableKeychain("keychainCodable")
    var keychainCodable = KeychainCodable.test
    @UnwrappedStore(keychainTagStorage, "unwrappedKeychainTagDefault")
    var unwrappedKeychainTagDefault = "tagDefault"
    @UnwrappedKeychain("unwrappedKeychainDefault")
    var unwrappedKeychainDefault = "default"
    @UnwrappedCodableStore(keychainTagStorage, "unwrappedKeychainTagCodable")
    var unwrappedKeychainTagCodable = KeychainCodable.test
    @UnwrappedCodableKeychain("unwrappedKeychainCodable")
    var unwrappedKeychainCodable = KeychainCodable.test

    func testKeychainTagStoreError() {
        let keychainTagStoreError = expectation(description: "keychainTagStoreError")
        keychainTagStorage.errorClosure = { error in
            if case let KeychainError.error(message) = error {
                XCTAssertFalse(message.isEmpty)
                keychainTagStoreError.fulfill()
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

    func testKeychainTagStoreDefaultError() {
        let keychainTagStoreDefaultError = expectation(description: "keychainTagStoreDefaultError")
        keychainTagStorage.errorClosure = { error in
            if case let KeychainError.error(message) = error {
                XCTAssertFalse(message.isEmpty)
                keychainTagStoreDefaultError.fulfill()
            }
        }
        keychainTagDefault = "testKeychainTagStore"
        XCTAssertNil(keychainTagDefault)
        waitForExpectations(timeout: 1)
    }

    func testKeychainDefaultError() {
        let keychainDefaultError = expectation(description: "keychainDefaultError")
        KeychainStorage.standard.errorClosure = { error in
            if case let KeychainError.error(message) = error {
                XCTAssertFalse(message.isEmpty)
                keychainDefaultError.fulfill()
            }
        }
        keychainDefault = "testKeychain"
        XCTAssertNil(keychainDefault)
        waitForExpectations(timeout: 1)
    }

    func testKeychainTagStoreCodableError() {
        let keychainTagStoreCodableError = expectation(description: "keychainTagStoreCodableError")
        keychainTagStorage.errorClosure = { error in
            if case let KeychainError.error(message) = error {
                XCTAssertFalse(message.isEmpty)
                keychainTagStoreCodableError.fulfill()
            }
        }
        keychainTagCodable = .test
        XCTAssertNil(keychainTagCodable)
        waitForExpectations(timeout: 1)
    }

    func testKeychainCodableError() {
        let keychainCodableError = expectation(description: "keychainCodableError")
        KeychainStorage.standard.errorClosure = { error in
            if case let KeychainError.error(message) = error {
                XCTAssertFalse(message.isEmpty)
                keychainCodableError.fulfill()
            }
        }
        keychainCodable = .test
        XCTAssertNil(keychainCodable)
        waitForExpectations(timeout: 1)
    }

    func testUnwrappedKeychainTagStoreDefaultError() {
        let unwrappedKeychainTagStoreDefaultError = expectation(description: "unwrappedKeychainTagStoreDefaultError")
        keychainTagStorage.errorClosure = { error in
            if case let KeychainError.error(message) = error {
                XCTAssertFalse(message.isEmpty)
                unwrappedKeychainTagStoreDefaultError.fulfill()
            }
        }
        unwrappedKeychainTagDefault = "tagDefault2"
        XCTAssertEqual(unwrappedKeychainTagDefault, "tagDefault")
        waitForExpectations(timeout: 1)
    }

    func testUnwrappedKeychainDefaultError() {
        let unwrappedKeychainDefaultError = expectation(description: "unwrappedKeychainDefaultError")
        KeychainStorage.standard.errorClosure = { error in
            if case let KeychainError.error(message) = error {
                XCTAssertFalse(message.isEmpty)
                unwrappedKeychainDefaultError.fulfill()
            }
        }
        unwrappedKeychainDefault = "default2"
        XCTAssertEqual(unwrappedKeychainDefault, "default")
        waitForExpectations(timeout: 1)
    }

    func testUnwrappedKeychainTagStoreCodableError() {
        let unwrappedKeychainTagStoreCodableError = expectation(description: "unwrappedKeychainTagStoreCodableError")
        keychainTagStorage.errorClosure = { error in
            if case let KeychainError.error(message) = error {
                XCTAssertFalse(message.isEmpty)
                unwrappedKeychainTagStoreCodableError.fulfill()
            }
        }
        unwrappedKeychainTagCodable = .test2
        XCTAssertEqual(unwrappedKeychainTagCodable, .test)
        waitForExpectations(timeout: 1)
    }

    func testUnwrappedKeychainCodableError() {
        let unwrappedKeychainCodableError = expectation(description: "unwrappedKeychainCodableError")
        KeychainStorage.standard.errorClosure = { error in
            if case let KeychainError.error(message) = error {
                XCTAssertFalse(message.isEmpty)
                unwrappedKeychainCodableError.fulfill()
            }
        }
        unwrappedKeychainCodable = .test2
        XCTAssertEqual(unwrappedKeychainCodable, .test)
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

    func testKeychainCodableDeleteError() {
        let keychainCodableDeleteError = expectation(description: "keychainCodableDeleteError")
        KeychainStorage.standard.errorClosure = { error in
            if case let KeychainError.error(message) = error {
                XCTAssertFalse(message.isEmpty)
                keychainCodableDeleteError.fulfill()
            }
        }
        keychainCodable = nil
        XCTAssertNil(keychainCodable)
        waitForExpectations(timeout: 1)
    }

    static var allTests = [
        ("testKeychainStoreError", testKeychainStoreError),
        ("testKeychainTagStoreError", testKeychainTagStoreError),
        ("testKeychainError", testKeychainError),
        ("testKeychainDeleteError", testKeychainDeleteError),
        ("testKeychainTagStoreDefaultError", testKeychainTagStoreDefaultError),
        ("testKeychainDefaultError", testKeychainDefaultError),
        ("testKeychainTagStoreCodableError", testKeychainTagStoreCodableError),
        ("testKeychainCodableError", testKeychainCodableError),
        ("testKeychainCodableDeleteError", testKeychainCodableDeleteError),
        ("testUnwrappedKeychainTagStoreDefaultError", testUnwrappedKeychainTagStoreDefaultError),
        ("testUnwrappedKeychainDefaultError", testUnwrappedKeychainDefaultError),
        ("testUnwrappedKeychainTagStoreCodableError", testUnwrappedKeychainTagStoreCodableError),
        ("testUnwrappedKeychainCodableError", testUnwrappedKeychainCodableError)
    ]
}
