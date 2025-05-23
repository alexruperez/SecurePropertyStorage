@testable import Keychain
@testable import Storage
import XCTest

enum KeychainCodable: String, Codable {
    case test
    case test2
}

@StorageActor let keychainTagStorage: KeychainStorage = {
    let keychainStorage = KeychainStorage(authenticationTag: Data())
    keychainStorage.accessGroup = ""
    keychainStorage.synchronizable = true
    keychainStorage.accessible = kSecAttrAccessibleAfterFirstUnlock
    return keychainStorage
}()

final class KeychainTests: XCTestCase, Sendable {
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

    func testKeychainTagStoreError() async {
        let keychainTagStoreError = expectation(description: "keychainTagStoreError")
        setupErrorClosure(storage: keychainTagStorage, expectation: keychainTagStoreError)
        keychainTagStore = "testKeychainTagStore"
        XCTAssertNil(keychainTagStore)
        await MainActor.run {
            waitForExpectations(timeout: 1)
        }
    }

    func testKeychainStoreError() async {
        let keychainStoreError = expectation(description: "keychainStoreError")
        setupErrorClosure(storage: KeychainStorage.standard, expectation: keychainStoreError)
        keychainStore = "testKeychainStore"
        XCTAssertNil(keychainStore)
        await MainActor.run {
            waitForExpectations(timeout: 1)
        }
    }

    func testKeychainError() async {
        let keychainError = expectation(description: "keychainError")
        setupErrorClosure(storage: KeychainStorage.standard, expectation: keychainError)
        keychain = "testKeychain"
        XCTAssertNil(keychain)
        await MainActor.run {
            waitForExpectations(timeout: 1)
        }
    }

    func testKeychainTagStoreDefaultError() async {
        let keychainTagStoreDefaultError = expectation(description: "keychainTagStoreDefaultError")
        setupErrorClosure(storage: keychainTagStorage, expectation: keychainTagStoreDefaultError)
        keychainTagDefault = "testKeychainTagStore"
        XCTAssertNil(keychainTagDefault)
        await MainActor.run {
            waitForExpectations(timeout: 1)
        }
    }

    func testKeychainDefaultError() async {
        let keychainDefaultError = expectation(description: "keychainDefaultError")
        setupErrorClosure(storage: KeychainStorage.standard, expectation: keychainDefaultError)
        keychainDefault = "testKeychain"
        XCTAssertNil(keychainDefault)
        await MainActor.run {
            waitForExpectations(timeout: 1)
        }
    }

    func testKeychainTagStoreCodableError() async {
        let keychainTagStoreCodableError = expectation(description: "keychainTagStoreCodableError")
        setupErrorClosure(storage: keychainTagStorage, expectation: keychainTagStoreCodableError)
        keychainTagStorage.errorClosure = { error in
            if case let KeychainError.error(message) = error {
                XCTAssertFalse(message.isEmpty)
                keychainTagStoreCodableError.fulfill()
                keychainTagStorage.errorClosure = nil
            }
        }
        keychainTagCodable = .test
        XCTAssertNil(keychainTagCodable)
        await MainActor.run {
            waitForExpectations(timeout: 1)
        }
    }

    func testKeychainCodableError() async {
        let keychainCodableError = expectation(description: "keychainCodableError")
        setupErrorClosure(storage: KeychainStorage.standard, expectation: keychainCodableError)
        keychainCodable = .test
        XCTAssertNil(keychainCodable)
        await MainActor.run {
            waitForExpectations(timeout: 1)
        }
    }

    func testUnwrappedKeychainTagStoreDefaultError() async {
        let unwrappedKeychainTagStoreDefaultError = expectation(description: "unwrappedKeychainTagStoreDefaultError")
        setupErrorClosure(storage: keychainTagStorage, expectation: unwrappedKeychainTagStoreDefaultError)
        unwrappedKeychainTagDefault = "tagDefault2"
        XCTAssertEqual(unwrappedKeychainTagDefault, "tagDefault")
        await MainActor.run {
            waitForExpectations(timeout: 1)
        }
    }

    func testUnwrappedKeychainDefaultError() async {
        let unwrappedKeychainDefaultError = expectation(description: "unwrappedKeychainDefaultError")
        setupErrorClosure(storage: KeychainStorage.standard, expectation: unwrappedKeychainDefaultError)
        unwrappedKeychainDefault = "default2"
        XCTAssertEqual(unwrappedKeychainDefault, "default")
        await MainActor.run {
            waitForExpectations(timeout: 1)
        }
    }

    func testUnwrappedKeychainTagStoreCodableError() async {
        let unwrappedKeychainTagStoreCodableError = expectation(description: "unwrappedKeychainTagStoreCodableError")
        setupErrorClosure(storage: keychainTagStorage, expectation: unwrappedKeychainTagStoreCodableError)
        unwrappedKeychainTagCodable = .test2
        XCTAssertEqual(unwrappedKeychainTagCodable, .test)
        await MainActor.run {
            waitForExpectations(timeout: 1)
        }
    }

    func testUnwrappedKeychainCodableError() async {
        let unwrappedKeychainCodableError = expectation(description: "unwrappedKeychainCodableError")
        setupErrorClosure(storage: KeychainStorage.standard, expectation: unwrappedKeychainCodableError)
        unwrappedKeychainCodable = .test2
        XCTAssertEqual(unwrappedKeychainCodable, .test)
        await MainActor.run {
            waitForExpectations(timeout: 1)
        }
    }

    func testKeychainDeleteError() async {
        let keychainDeleteError = expectation(description: "keychainDeleteError")
        setupErrorClosure(storage: KeychainStorage.standard, expectation: keychainDeleteError)
        keychain = nil
        XCTAssertNil(keychain)
        await MainActor.run {
            waitForExpectations(timeout: 1)
        }
    }

    func testKeychainCodableDeleteError() async {
        let keychainCodableDeleteError = expectation(description: "keychainCodableDeleteError")
        setupErrorClosure(storage: KeychainStorage.standard, expectation: keychainCodableDeleteError)
        keychainCodable = nil
        XCTAssertNil(keychainCodable)
        await MainActor.run {
            waitForExpectations(timeout: 1)
        }
    }

    private func setupErrorClosure(storage: DelegatedStorage, expectation: XCTestExpectation) {
        var errorClosureCalled = false
        storage.errorClosure = { error in
            if case let KeychainError.error(message) = error, !errorClosureCalled {
                XCTAssertFalse(message.isEmpty)
                expectation.fulfill()
                errorClosureCalled = true
            }
        }
    }

    static var allTests = [
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
