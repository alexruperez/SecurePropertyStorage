import Storage
import UserDefault
import XCTest

enum UserDefaultsCodable: String, Codable {
    case test
    case alternative
}

let userDefaultsTagStorage = UserDefaultsStorage(authenticationTag: Data())

final class UserDefaultTests: XCTestCase {
    @Store(userDefaultsTagStorage, "userDefaultsTagStore")
    var userDefaultsTagStore: String?
    @Store(UserDefaultsStorage.standard, "userDefaultsStore")
    var userDefaultsStore: String?
    @UserDefault("userDefaults")
    var userDefaults: String?
    @Store(userDefaultsTagStorage, "userDefaultsTagDefault")
    var userDefaultsTagDefault = "tagDefault"
    @UserDefault("userDefaultsDefault")
    var userDefaultsDefault = "default"
    @CodableStore(userDefaultsTagStorage, "userDefaultsTagCodable")
    var userDefaultsTagCodable = UserDefaultsCodable.test
    @CodableUserDefault("userDefaultsCodable")
    var userDefaultsCodable = UserDefaultsCodable.test
    @UnwrappedStore(userDefaultsTagStorage, "unwrappedUserDefaultsTagDefault")
    var unwrappedUserDefaultsTagDefault = "tagDefault"
    @UnwrappedUserDefault("unwrappedUserDefaultsDefault")
    var unwrappedUserDefaultsDefault = "default"
    @UnwrappedCodableStore(userDefaultsTagStorage, "unwrappedUserDefaultsTagCodable")
    var unwrappedUserDefaultsTagCodable = UserDefaultsCodable.test
    @UnwrappedCodableUserDefault("unwrappedUserDefaultsCodable")
    var unwrappedUserDefaultsCodable = UserDefaultsCodable.test

    func testUserDefault() {
        userDefaultsStore = nil
        XCTAssertNil(userDefaultsStore)
        let test = "testUserDefault"
        userDefaults = test
        userDefaultsTagStore = test
        XCTAssertEqual(userDefaults, test)
        XCTAssertEqual(userDefaults, userDefaultsTagStore)
        let testRegister = "testRegister"
        UserDefaultsStorage.standard.register(defaults: ["userDefaults": testRegister,
                                                         "userDefaultsStore": testRegister])
        XCTAssertNotEqual(userDefaults, testRegister)
        XCTAssertEqual(userDefaultsStore, testRegister)
        XCTAssertEqual(userDefaults, userDefaultsTagStore)
        userDefaultsStore = test
        XCTAssertEqual(userDefaults, userDefaultsStore)
        XCTAssertEqual(userDefaults, userDefaultsTagStore)
        userDefaults = nil
        XCTAssertNil(userDefaults)
        XCTAssertNotEqual(userDefaults, userDefaultsTagStore)
        XCTAssertEqual(userDefaultsTagDefault, "tagDefault")
        XCTAssertEqual(userDefaultsDefault, "default")
        userDefaultsDefault = nil
        XCTAssertNil(userDefaultsDefault)
        XCTAssertEqual(userDefaultsTagCodable, .test)
        XCTAssertEqual(userDefaultsCodable, .test)
        userDefaultsCodable = nil
        XCTAssertNil(userDefaultsCodable)
        XCTAssertEqual(unwrappedUserDefaultsTagDefault, "tagDefault")
        XCTAssertEqual(unwrappedUserDefaultsDefault, "default")
        XCTAssertEqual(unwrappedUserDefaultsTagCodable, .test)
        XCTAssertEqual(unwrappedUserDefaultsCodable, .test)
        unwrappedUserDefaultsTagDefault = "tagDefaultAlternative"
        unwrappedUserDefaultsDefault = "defaultAlternative"
        unwrappedUserDefaultsTagCodable = .alternative
        unwrappedUserDefaultsCodable = .alternative
        XCTAssertEqual(unwrappedUserDefaultsTagDefault, "tagDefaultAlternative")
        XCTAssertEqual(unwrappedUserDefaultsDefault, "defaultAlternative")
        XCTAssertEqual(unwrappedUserDefaultsTagCodable, .alternative)
        XCTAssertEqual(unwrappedUserDefaultsCodable, .alternative)
    }

    func testUserDefaultArray() {
        let userDefaults = UserDefaultsStorage.standard
        let key = "testArray"
        let value = [1]
        userDefaults.set(value, forKey: key)
        XCTAssertEqual(userDefaults.array(forKey: key) as? [Int], value)
    }

    func testUserDefaultSet() {
        let userDefaults = UserDefaultsStorage.standard
        let key = "testSet"
        let value = 1
        var set = Set<Int>()
        set.insert(value)
        userDefaults.set(set, forKey: key)
        XCTAssertEqual(userDefaults.set(forKey: key)?.randomElement(), value)
    }

    func testUserDefaultDictionary() {
        let userDefaults = UserDefaultsStorage.standard
        let key = "testDictionary"
        let value = [key: 1]
        userDefaults.set(value, forKey: key)
        XCTAssertEqual(userDefaults.dictionary(forKey: key) as? [String: Int], value)
    }

    func testUserDefaultStringArray() {
        let userDefaults = UserDefaultsStorage.standard
        let key = "testStringArray"
        let value = [key]
        userDefaults.set(value, forKey: key)
        XCTAssertEqual(userDefaults.stringArray(forKey: key), value)
    }

    func testUserDefaultInteger() {
        let userDefaults = UserDefaultsStorage.standard
        let key = "testInteger"
        let value = 1
        userDefaults.set(value, forKey: key)
        XCTAssertEqual(userDefaults.integer(forKey: key), value)
    }

    func testUserDefaultFloat() {
        let userDefaults = UserDefaultsStorage.standard
        let key = "testFloat"
        let value: Float = 1
        userDefaults.set(value, forKey: key)
        XCTAssertEqual(userDefaults.float(forKey: key), value)
    }

    func testUserDefaultDouble() {
        let userDefaults = UserDefaultsStorage.standard
        let key = "testDouble"
        let value: Double = 1
        userDefaults.set(value, forKey: key)
        XCTAssertEqual(userDefaults.double(forKey: key), value)
    }

    func testUserDefaultBool() {
        let userDefaults = UserDefaultsStorage.standard
        let key = "testBool"
        let value = true
        userDefaults.set(value, forKey: key)
        XCTAssertEqual(userDefaults.bool(forKey: key), value)
    }

    func testUserDefaultString() {
        let userDefaults = UserDefaultsStorage.standard
        let key = "testURL"
        let value = "testString"
        XCTAssertNotNil(value)
        userDefaults.set(value, forKey: key)
        XCTAssertEqual(userDefaults.string(forKey: key), value)
    }

    func testUserDefaultURL() {
        let userDefaults = UserDefaultsStorage.standard
        let key = "testURL"
        let value = URL(string: "https://github.com/alexruperez")
        XCTAssertNotNil(value)
        userDefaults.set(value, forKey: key)
        XCTAssertEqual(userDefaults.url(forKey: key), value)
    }

    func testUserDefaultArrayNil() {
        let userDefaults = UserDefaultsStorage.standard
        let key = "testArray"
        let value: [Any]? = nil
        XCTAssertNil(value)
        userDefaults.set(value, forKey: key)
        XCTAssertNil(userDefaults.array(forKey: key))
    }

    func testUserDefaultDictionaryNil() {
        let userDefaults = UserDefaultsStorage.standard
        let key = "testDictionary"
        let value: [String: Any]? = nil
        XCTAssertNil(value)
        userDefaults.set(value, forKey: key)
        XCTAssertNil(userDefaults.dictionary(forKey: key))
    }

    func testUserDefaultStringArrayNil() {
        let userDefaults = UserDefaultsStorage.standard
        let key = "testStringArray"
        let value: [String]? = nil
        XCTAssertNil(value)
        userDefaults.set(value, forKey: key)
        XCTAssertNil(userDefaults.stringArray(forKey: key))
    }

    func testUserDefaultIntegerNil() {
        let userDefaults = UserDefaultsStorage.standard
        let key = "testInteger"
        let value: Int? = nil
        XCTAssertNil(value)
        userDefaults.set(value, forKey: key)
        XCTAssertEqual(userDefaults.integer(forKey: key), 0)
    }

    func testUserDefaultFloatNil() {
        let userDefaults = UserDefaultsStorage.standard
        let key = "testFloat"
        let value: Float? = nil
        XCTAssertNil(value)
        userDefaults.set(value, forKey: key)
        XCTAssertEqual(userDefaults.float(forKey: key), 0)
    }

    func testUserDefaultDoubleNil() {
        let userDefaults = UserDefaultsStorage.standard
        let key = "testDouble"
        let value: Double? = nil
        XCTAssertNil(value)
        userDefaults.set(value, forKey: key)
        XCTAssertEqual(userDefaults.double(forKey: key), 0)
    }

    func testUserDefaultBoolNil() {
        let userDefaults = UserDefaultsStorage.standard
        let key = "testBool"
        let value: Bool? = nil
        XCTAssertNil(value)
        userDefaults.set(value, forKey: key)
        XCTAssertFalse(userDefaults.bool(forKey: key))
    }

    func testUserDefaultStringNil() {
        let userDefaults = UserDefaultsStorage.standard
        let key = "testString"
        let value: String? = nil
        XCTAssertNil(value)
        userDefaults.set(value, forKey: key)
        XCTAssertNil(userDefaults.string(forKey: key))
    }

    func testUserDefaultURLNil() {
        let userDefaults = UserDefaultsStorage.standard
        let key = "testURL"
        let value: URL? = nil
        XCTAssertNil(value)
        userDefaults.set(value, forKey: key)
        XCTAssertNil(userDefaults.url(forKey: key))
    }

    static var allTests = [
        ("testUserDefault", testUserDefault),
        ("testUserDefaultArray", testUserDefaultArray),
        ("testUserDefaultDictionary", testUserDefaultDictionary),
        ("testUserDefaultStringArray", testUserDefaultStringArray),
        ("testUserDefaultInteger", testUserDefaultInteger),
        ("testUserDefaultFloat", testUserDefaultFloat),
        ("testUserDefaultDouble", testUserDefaultDouble),
        ("testUserDefaultBool", testUserDefaultBool),
        ("testUserDefaultString", testUserDefaultString),
        ("testUserDefaultURL", testUserDefaultURL),
        ("testUserDefaultArrayNil", testUserDefaultArrayNil),
        ("testUserDefaultDictionaryNil", testUserDefaultDictionaryNil),
        ("testUserDefaultStringArrayNil", testUserDefaultStringArrayNil),
        ("testUserDefaultIntegerNil", testUserDefaultIntegerNil),
        ("testUserDefaultFloatNil", testUserDefaultFloatNil),
        ("testUserDefaultDoubleNil", testUserDefaultDoubleNil),
        ("testUserDefaultBoolNil", testUserDefaultBoolNil),
        ("testUserDefaultStringNil", testUserDefaultStringNil),
        ("testUserDefaultURLNil", testUserDefaultURLNil)
    ]
}
