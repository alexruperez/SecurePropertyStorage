import Keychain
import Storage
import XCTest

enum KeychainCodable: String, Codable {
    case test
    case test2
}

let keychainTagStorage: KeychainStorage = {
    let keychainStorage = KeychainStorage(authenticationTag: Data())
    keychainStorage.accessGroup = ""
    keychainStorage.synchronizable = true
    keychainStorage.accessible = kSecAttrAccessibleAfterFirstUnlock
    return keychainStorage
}()

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

    func testKeychainStorageAccessGroup() {
        XCTAssertEqual(keychainTagStorage.accessGroup, "")
    }

    func testKeychainStorageSynchronizable() {
        XCTAssertTrue(keychainTagStorage.synchronizable)
    }

    func testKeychainStorageAccessible() {
        XCTAssertEqual(keychainTagStorage.accessible, kSecAttrAccessibleAfterFirstUnlock)
    }

    @MainActor func testKeychainTagStoreError() {
        let keychainTagStoreError = expectation(description: "keychainTagStoreError")
        keychainTagStorage.errorClosure = { error in
            if case let KeychainError.error(message) = error {
                XCTAssertFalse(message.isEmpty)
                keychainTagStoreError.fulfill()
                keychainTagStorage.errorClosure = nil
            }
        }
        keychainTagStore = "testKeychainTagStore"
        XCTAssertNil(keychainTagStore)
        waitForExpectations(timeout: 1)
    }

    @MainActor func testKeychainStoreError() {
        var errorClosureCalled = false
        let keychainStoreError = expectation(description: "keychainStoreError")
        KeychainStorage.standard.errorClosure = { error in
            if case let KeychainError.error(message) = error,
               !errorClosureCalled {
                XCTAssertFalse(message.isEmpty)
                keychainStoreError.fulfill()
                errorClosureCalled = true
            }
        }
        keychainStore = "testKeychainStore"
        XCTAssertNil(keychainStore)
        waitForExpectations(timeout: 1)
    }

    @MainActor func testKeychainError() {
        var errorClosureCalled = false
        let keychainError = expectation(description: "keychainError")
        KeychainStorage.standard.errorClosure = { error in
            if case let KeychainError.error(message) = error,
               !errorClosureCalled {
                XCTAssertFalse(message.isEmpty)
                keychainError.fulfill()
                errorClosureCalled = true
            }
        }
        keychain = "testKeychain"
        XCTAssertNil(keychain)
        waitForExpectations(timeout: 1)
    }

    @MainActor func testKeychainTagStoreDefaultError() {
        let keychainTagStoreDefaultError = expectation(description: "keychainTagStoreDefaultError")
        keychainTagStorage.errorClosure = { error in
            if case let KeychainError.error(message) = error {
                XCTAssertFalse(message.isEmpty)
                keychainTagStoreDefaultError.fulfill()
                keychainTagStorage.errorClosure = nil
            }
        }
        keychainTagDefault = "testKeychainTagStore"
        XCTAssertNil(keychainTagDefault)
        waitForExpectations(timeout: 1)
    }

    @MainActor func testKeychainDefaultError() {
        var errorClosureCalled = false
        let keychainDefaultError = expectation(description: "keychainDefaultError")
        KeychainStorage.standard.errorClosure = { error in
            if case let KeychainError.error(message) = error,
               !errorClosureCalled {
                XCTAssertFalse(message.isEmpty)
                keychainDefaultError.fulfill()
                errorClosureCalled = true
            }
        }
        keychainDefault = "testKeychain"
        XCTAssertNil(keychainDefault)
        waitForExpectations(timeout: 1)
    }

    @MainActor func testKeychainTagStoreCodableError() {
        let keychainTagStoreCodableError = expectation(description: "keychainTagStoreCodableError")
        keychainTagStorage.errorClosure = { error in
            if case let KeychainError.error(message) = error {
                XCTAssertFalse(message.isEmpty)
                keychainTagStoreCodableError.fulfill()
                keychainTagStorage.errorClosure = nil
            }
        }
        keychainTagCodable = .test
        XCTAssertNil(keychainTagCodable)
        waitForExpectations(timeout: 1)
    }

    @MainActor func testKeychainCodableError() {
        var errorClosureCalled = false
        let keychainCodableError = expectation(description: "keychainCodableError")
        KeychainStorage.standard.errorClosure = { error in
            if case let KeychainError.error(message) = error,
               !errorClosureCalled {
                XCTAssertFalse(message.isEmpty)
                keychainCodableError.fulfill()
                errorClosureCalled = true
            }
        }
        keychainCodable = .test
        XCTAssertNil(keychainCodable)
        waitForExpectations(timeout: 1)
    }

    @MainActor func testUnwrappedKeychainTagStoreDefaultError() {
        let unwrappedKeychainTagStoreDefaultError = expectation(description: "unwrappedKeychainTagStoreDefaultError")
        keychainTagStorage.errorClosure = { error in
            if case let KeychainError.error(message) = error {
                XCTAssertFalse(message.isEmpty)
                unwrappedKeychainTagStoreDefaultError.fulfill()
                keychainTagStorage.errorClosure = nil
            }
        }
        unwrappedKeychainTagDefault = "tagDefault2"
        XCTAssertEqual(unwrappedKeychainTagDefault, "tagDefault")
        waitForExpectations(timeout: 1)
    }

    @MainActor func testUnwrappedKeychainDefaultError() {
        var errorClosureCalled = false
        let unwrappedKeychainDefaultError = expectation(description: "unwrappedKeychainDefaultError")
        KeychainStorage.standard.errorClosure = { error in
            if case let KeychainError.error(message) = error,
               !errorClosureCalled {
                XCTAssertFalse(message.isEmpty)
                unwrappedKeychainDefaultError.fulfill()
                errorClosureCalled = true
            }
        }
        unwrappedKeychainDefault = "default2"
        XCTAssertEqual(unwrappedKeychainDefault, "default")
        waitForExpectations(timeout: 1)
    }

    @MainActor func testUnwrappedKeychainTagStoreCodableError() {
        let unwrappedKeychainTagStoreCodableError = expectation(description: "unwrappedKeychainTagStoreCodableError")
        keychainTagStorage.errorClosure = { error in
            if case let KeychainError.error(message) = error {
                XCTAssertFalse(message.isEmpty)
                unwrappedKeychainTagStoreCodableError.fulfill()
                keychainTagStorage.errorClosure = nil
            }
        }
        unwrappedKeychainTagCodable = .test2
        XCTAssertEqual(unwrappedKeychainTagCodable, .test)
        waitForExpectations(timeout: 1)
    }

    @MainActor func testUnwrappedKeychainCodableError() {
        var errorClosureCalled = false
        let unwrappedKeychainCodableError = expectation(description: "unwrappedKeychainCodableError")
        KeychainStorage.standard.errorClosure = { error in
            if case let KeychainError.error(message) = error,
               !errorClosureCalled {
                XCTAssertFalse(message.isEmpty)
                unwrappedKeychainCodableError.fulfill()
                errorClosureCalled = true
            }
        }
        unwrappedKeychainCodable = .test2
        XCTAssertEqual(unwrappedKeychainCodable, .test)
        waitForExpectations(timeout: 1)
    }

    @MainActor func testKeychainDeleteError() {
        var errorClosureCalled = false
        let keychainDeleteError = expectation(description: "keychainDeleteError")
        KeychainStorage.standard.errorClosure = { error in
            if case let KeychainError.error(message) = error,
               !errorClosureCalled {
                XCTAssertFalse(message.isEmpty)
                keychainDeleteError.fulfill()
                errorClosureCalled = true
            }
        }
        keychain = nil
        XCTAssertNil(keychain)
        waitForExpectations(timeout: 1)
    }

    @MainActor func testKeychainCodableDeleteError() {
        var errorClosureCalled = false
        let keychainCodableDeleteError = expectation(description: "keychainCodableDeleteError")
        KeychainStorage.standard.errorClosure = { error in
            if case let KeychainError.error(message) = error,
               !errorClosureCalled {
                XCTAssertFalse(message.isEmpty)
                keychainCodableDeleteError.fulfill()
                errorClosureCalled = true
            }
        }
        keychainCodable = nil
        XCTAssertNil(keychainCodable)
        waitForExpectations(timeout: 1)
    }

    @MainActor static let allTests = [
        ("testKeychainStorageAccessGroup", testKeychainStorageAccessGroup),
        ("testKeychainStorageSynchronizable", testKeychainStorageSynchronizable),
        ("testKeychainStorageAccessible", testKeychainStorageAccessible),
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
