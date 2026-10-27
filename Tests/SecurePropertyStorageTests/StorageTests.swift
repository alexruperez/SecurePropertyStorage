// swiftformat:disable redundantAsync
// Test methods are `async` on purpose: it makes XCTest run them on `StorageActor` instead of the main thread.

import CryptoKit
@testable import Singleton
@testable import Storage
import XCTest

/// Legacy `NSCoding` (non secure coding) class, used to verify object archiving round trips.
final class LegacyCodableObject: NSObject, NSCoding {
    let name: String

    init(name: String) {
        self.name = name
    }

    required init?(coder: NSCoder) {
        guard let name = coder.decodeObject(forKey: "name") as? String else {
            return nil
        }
        self.name = name
    }

    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
    }
}

/// Tests for the core `DelegatedStorage` logic, using an in-memory delegate so they are deterministic and
/// independent of the Keychain entitlements of the test host.
@StorageActor
final class StorageTests: XCTestCase {
    private func makeStorage(delegate: StorageDelegate = SingletonStorageDelegate(),
                             symmetricKey: SymmetricKey = SymmetricKey(size: .bits256),
                             authenticationTag: Data? = nil) -> DelegatedStorage {
        DelegatedStorage(delegate, symmetricKey: symmetricKey, authenticationTag: authenticationTag)
    }

    func testPrimitiveRoundTrip() async {
        let storage = makeStorage()
        storage.set(42, forKey: "int")
        storage.set(Float(1.5), forKey: "float")
        storage.set(Double(2.5), forKey: "double")
        storage.set(true, forKey: "bool")
        storage.set("string", forKey: "string")
        let url = URL(string: "https://github.com/alexruperez")
        storage.set(url, forKey: "url")
        XCTAssertEqual(storage.integer(forKey: "int"), 42)
        XCTAssertEqual(storage.float(forKey: "float"), 1.5)
        XCTAssertEqual(storage.double(forKey: "double"), 2.5)
        XCTAssertTrue(storage.bool(forKey: "bool"))
        XCTAssertEqual(storage.string(forKey: "string"), "string")
        XCTAssertEqual(storage.url(forKey: "url"), url)
    }

    func testMissingKeysReturnDefaults() async {
        let storage = makeStorage()
        XCTAssertEqual(storage.integer(forKey: "missing"), 0)
        XCTAssertEqual(storage.float(forKey: "missing"), 0)
        XCTAssertEqual(storage.double(forKey: "missing"), 0)
        XCTAssertFalse(storage.bool(forKey: "missing"))
        XCTAssertNil(storage.string(forKey: "missing"))
        XCTAssertNil(storage.url(forKey: "missing"))
        XCTAssertNil(storage.array(forKey: "missing"))
        XCTAssertNil(storage.dictionary(forKey: "missing"))
        let value: String? = storage.value(forKey: "missing")
        XCTAssertNil(value)
    }

    func testRemoveValue() async {
        let storage = makeStorage()
        storage.set("value", forKey: "key")
        XCTAssertEqual(storage.string(forKey: "key"), "value")
        storage.remove(forKey: "key")
        XCTAssertNil(storage.string(forKey: "key"))
    }

    func testSecureCodingObjectRoundTrip() async {
        let storage = makeStorage()
        storage.set([1, 2, 3], forKey: "array")
        storage.set(["key": 1], forKey: "dictionary")
        storage.set(["a", "b"], forKey: "stringArray")
        XCTAssertEqual(storage.array(forKey: "array") as? [Int], [1, 2, 3])
        XCTAssertEqual(storage.dictionary(forKey: "dictionary") as? [String: Int], ["key": 1])
        XCTAssertEqual(storage.stringArray(forKey: "stringArray"), ["a", "b"])
    }

    /// Regression: `object(forKey:)` no longer uses the deprecated `unarchiveTopLevelObjectWithData`.
    func testLegacyNSCodingObjectRoundTrip() async throws {
        let storage = makeStorage()
        storage.set(LegacyCodableObject(name: "legacy"), forKey: "legacy")
        let object = try storage.object(forKey: "legacy") as? LegacyCodableObject
        XCTAssertEqual(object?.name, "legacy")
        let value: LegacyCodableObject? = storage.value(forKey: "legacy")
        XCTAssertEqual(value?.name, "legacy")
    }

    func testObjectForMissingKeyIsNil() async throws {
        let storage = makeStorage()
        XCTAssertNil(try storage.object(forKey: "missing"))
    }

    func testSetNilObjectRemovesValue() async throws {
        let storage = makeStorage()
        storage.set([1], forKey: "array")
        XCTAssertNotNil(storage.array(forKey: "array"))
        try storage.set(object: nil, forKey: "array")
        XCTAssertNil(storage.array(forKey: "array"))
    }

    func testCodableRoundTrip() async {
        let storage = makeStorage()
        storage.set(encodable: SingletonCodable.alternative, forKey: "codable")
        let decoded: SingletonCodable? = storage.decodable(forKey: "codable")
        XCTAssertEqual(decoded, .alternative)
        storage.set(encodable: nil, forKey: "codable")
        let removed: SingletonCodable? = storage.decodable(forKey: "codable")
        XCTAssertNil(removed)
    }

    func testRegisterDefaultsDoesNotOverrideStoredValues() async {
        let storage = makeStorage()
        storage.set("stored", forKey: "key")
        storage.register(defaults: ["key": "default", "other": "default"])
        XCTAssertEqual(storage.string(forKey: "key"), "stored")
        let other: String? = storage.value(forKey: "other")
        XCTAssertNotNil(other)
    }

    func testKeysAreHashedAndValuesAreEncrypted() async throws {
        let delegate = SingletonStorageDelegate()
        let storage = makeStorage(delegate: delegate)
        storage.set("plain text secret", forKey: "key")
        let rawPlain: Data? = delegate.data(forKey: "key")
        XCTAssertNil(rawPlain, "The plain key must never reach the delegate.")
        let raw: Data = try XCTUnwrap(delegate.data(forKey: storage.hash("key")))
        XCTAssertFalse(raw.isEmpty)
        XCTAssertNil(raw.range(of: Data("plain text secret".utf8)), "The value must be stored encrypted.")
        XCTAssertEqual(storage.hash("key").count, 128, "SHA-512 hex digest must have 128 characters.")
        XCTAssertEqual(storage.hash("key"), storage.hash("key"))
        XCTAssertNotEqual(storage.hash("key"), storage.hash("other"))
    }

    func testWrongSymmetricKeyReportsErrorAndReturnsNil() async {
        let delegate = SingletonStorageDelegate()
        makeStorage(delegate: delegate).set("secret", forKey: "key")
        let otherStorage = makeStorage(delegate: delegate)
        var reportedErrors = [Error]()
        otherStorage.errorClosure = { reportedErrors.append($0) }
        XCTAssertNil(otherStorage.string(forKey: "key"))
        let value: String? = otherStorage.value(forKey: "key")
        XCTAssertNil(value)
        XCTAssertFalse(reportedErrors.isEmpty)
    }

    func testAuthenticationTagMismatchReportsError() async {
        let delegate = SingletonStorageDelegate()
        let key = SymmetricKey(size: .bits256)
        makeStorage(delegate: delegate, symmetricKey: key, authenticationTag: Data("tag".utf8))
            .set("secret", forKey: "key")
        let tagged = makeStorage(delegate: delegate, symmetricKey: key, authenticationTag: Data("tag".utf8))
        XCTAssertEqual(tagged.string(forKey: "key"), "secret")
        let wrongTag = makeStorage(delegate: delegate, symmetricKey: key, authenticationTag: Data("other".utf8))
        var reportedErrors = [Error]()
        wrongTag.errorClosure = { reportedErrors.append($0) }
        XCTAssertNil(wrongTag.string(forKey: "key"))
        XCTAssertFalse(reportedErrors.isEmpty)
        let noTag = makeStorage(delegate: delegate, symmetricKey: key)
        XCTAssertNil(noTag.string(forKey: "key"))
    }

    func testStorageWithoutSymmetricKeyStoresNothing() async {
        let delegate = SingletonStorageDelegate()
        let storage = DelegatedStorage(delegate)
        storage.set("value", forKey: "key")
        XCTAssertNil(storage.string(forKey: "key"))
        let raw: Data? = delegate.data(forKey: storage.hash("key"))
        XCTAssertNil(raw)
    }

    func testCorruptedCodableDataReportsError() async {
        let storage = makeStorage()
        storage.set("not json", forKey: "key")
        var reportedErrors = [Error]()
        storage.errorClosure = { reportedErrors.append($0) }
        let decoded: SingletonCodable? = storage.decodable(forKey: "key")
        XCTAssertNil(decoded)
        XCTAssertFalse(reportedErrors.isEmpty)
    }

    func testDataConvertibleRejectsWrongSizedData() async {
        XCTAssertNil(Int(Data([1, 2, 3])))
        XCTAssertNil(Bool(Data()))
        XCTAssertNil(Double(Data([1])))
        XCTAssertEqual(Int(Int.max.data), Int.max)
        XCTAssertEqual(Int(Int.min.data), Int.min)
        XCTAssertEqual(Double(Double.greatestFiniteMagnitude.data), Double.greatestFiniteMagnitude)
        XCTAssertEqual(String(Data("héllo 🔐".utf8)), "héllo 🔐")
        XCTAssertNil(String(Data([0xFF, 0xFE])))
    }

    func testContiguousBytesData() async {
        let bytes: [UInt8] = [1, 2, 3]
        XCTAssertEqual(Data(bytes).data, Data(bytes))
        XCTAssertEqual(bytes.data, Data(bytes))
        XCTAssertTrue(Data().data.isEmpty)
    }

    func testSymmetricKeyStorageDataRoundTrip() async throws {
        let key = SymmetricKey(size: .bits256)
        let restored = try SymmetricKey(bytes: key.data)
        XCTAssertEqual(key, restored)
        XCTAssertEqual(key.data.count, 32)
    }

    func testStorePropertyWrappersShareStorage() async {
        let storage = makeStorage()
        @Store(storage, "shared")
        var first: String?
        @UnwrappedStore(storage, "shared")
        var second = "default"
        XCTAssertNil(first)
        XCTAssertEqual(second, "default")
        first = "value"
        XCTAssertEqual(second, "value")
        first = nil
        XCTAssertEqual(second, "default")
    }
}
