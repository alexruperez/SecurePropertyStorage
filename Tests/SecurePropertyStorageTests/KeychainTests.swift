// swiftformat:disable redundantAsync
// Test methods are `async` on purpose: it makes XCTest run them on `StorageActor` instead of the main thread.

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

@StorageActor
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

    func testKeychainStorageAccessGroup() async {
        XCTAssertEqual(keychainTagStorage.accessGroup, "")
    }

    func testKeychainStorageSynchronizable() async {
        XCTAssertTrue(keychainTagStorage.synchronizable)
    }

    func testKeychainStorageAccessible() async {
        XCTAssertEqual(keychainTagStorage.accessible, kSecAttrAccessibleAfterFirstUnlock)
    }

    func testKeychainTagStoreError() async {
        let keychainTagStoreError = expectation(description: "keychainTagStoreError")
        setupErrorClosure(storage: keychainTagStorage, expectation: keychainTagStoreError)
        keychainTagStore = "testKeychainTagStore"
        XCTAssertNil(keychainTagStore)
        await fulfillment(of: [keychainTagStoreError], timeout: 1)
    }

    func testKeychainStoreError() async {
        let keychainStoreError = expectation(description: "keychainStoreError")
        setupErrorClosure(storage: KeychainStorage.standard, expectation: keychainStoreError)
        keychainStore = "testKeychainStore"
        XCTAssertNil(keychainStore)
        await fulfillment(of: [keychainStoreError], timeout: 1)
    }

    func testKeychainError() async {
        let keychainError = expectation(description: "keychainError")
        setupErrorClosure(storage: KeychainStorage.standard, expectation: keychainError)
        keychain = "testKeychain"
        XCTAssertNil(keychain)
        await fulfillment(of: [keychainError], timeout: 1)
    }

    func testKeychainTagStoreDefaultError() async {
        let keychainTagStoreDefaultError = expectation(description: "keychainTagStoreDefaultError")
        setupErrorClosure(storage: keychainTagStorage, expectation: keychainTagStoreDefaultError)
        keychainTagDefault = "testKeychainTagStore"
        XCTAssertNil(keychainTagDefault)
        await fulfillment(of: [keychainTagStoreDefaultError], timeout: 1)
    }

    func testKeychainDefaultError() async {
        let keychainDefaultError = expectation(description: "keychainDefaultError")
        setupErrorClosure(storage: KeychainStorage.standard, expectation: keychainDefaultError)
        keychainDefault = "testKeychain"
        XCTAssertNil(keychainDefault)
        await fulfillment(of: [keychainDefaultError], timeout: 1)
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
        await fulfillment(of: [keychainTagStoreCodableError], timeout: 1)
    }

    func testKeychainCodableError() async {
        let keychainCodableError = expectation(description: "keychainCodableError")
        setupErrorClosure(storage: KeychainStorage.standard, expectation: keychainCodableError)
        keychainCodable = .test
        XCTAssertNil(keychainCodable)
        await fulfillment(of: [keychainCodableError], timeout: 1)
    }

    func testUnwrappedKeychainTagStoreDefaultError() async {
        let unwrappedKeychainTagStoreDefaultError = expectation(description: "unwrappedKeychainTagStoreDefaultError")
        setupErrorClosure(storage: keychainTagStorage, expectation: unwrappedKeychainTagStoreDefaultError)
        unwrappedKeychainTagDefault = "tagDefault2"
        XCTAssertEqual(unwrappedKeychainTagDefault, "tagDefault")
        await fulfillment(of: [unwrappedKeychainTagStoreDefaultError], timeout: 1)
    }

    func testUnwrappedKeychainDefaultError() async {
        let unwrappedKeychainDefaultError = expectation(description: "unwrappedKeychainDefaultError")
        setupErrorClosure(storage: KeychainStorage.standard, expectation: unwrappedKeychainDefaultError)
        unwrappedKeychainDefault = "default2"
        XCTAssertEqual(unwrappedKeychainDefault, "default")
        await fulfillment(of: [unwrappedKeychainDefaultError], timeout: 1)
    }

    func testUnwrappedKeychainTagStoreCodableError() async {
        let unwrappedKeychainTagStoreCodableError = expectation(description: "unwrappedKeychainTagStoreCodableError")
        setupErrorClosure(storage: keychainTagStorage, expectation: unwrappedKeychainTagStoreCodableError)
        unwrappedKeychainTagCodable = .test2
        XCTAssertEqual(unwrappedKeychainTagCodable, .test)
        await fulfillment(of: [unwrappedKeychainTagStoreCodableError], timeout: 1)
    }

    func testUnwrappedKeychainCodableError() async {
        let unwrappedKeychainCodableError = expectation(description: "unwrappedKeychainCodableError")
        setupErrorClosure(storage: KeychainStorage.standard, expectation: unwrappedKeychainCodableError)
        unwrappedKeychainCodable = .test2
        XCTAssertEqual(unwrappedKeychainCodable, .test)
        await fulfillment(of: [unwrappedKeychainCodableError], timeout: 1)
    }

    func testKeychainDeleteError() async {
        let keychainDeleteError = expectation(description: "keychainDeleteError")
        setupErrorClosure(storage: KeychainStorage.standard, expectation: keychainDeleteError)
        keychain = nil
        XCTAssertNil(keychain)
        await fulfillment(of: [keychainDeleteError], timeout: 1)
    }

    func testKeychainCodableDeleteError() async {
        let keychainCodableDeleteError = expectation(description: "keychainCodableDeleteError")
        setupErrorClosure(storage: KeychainStorage.standard, expectation: keychainCodableDeleteError)
        keychainCodable = nil
        XCTAssertNil(keychainCodable)
        await fulfillment(of: [keychainCodableDeleteError], timeout: 1)
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
}
