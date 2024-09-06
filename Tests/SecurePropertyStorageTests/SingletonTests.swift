import Singleton
import Storage
import XCTest

enum SingletonCodable: String, Codable {
    case test
    case alternative
}

@StorageActor
let singletonTagStorage: DelegatedStorage = SingletonStorage(authenticationTag: Data())

final class SingletonTests: XCTestCase {
    @Store(singletonTagStorage, "singletonTagStore")
    var singletonTagStore: String?
    @Store(SingletonStorage.standard, "singletonStore")
    var singletonStore: String?
    @Singleton("singleton")
    var singleton: String?
    @Store(singletonTagStorage, "singletonTagDefault")
    var singletonTagDefault = "tagDefault"
    @Singleton("singletonDefault")
    var singletonDefault = "default"
    @CodableStore(singletonTagStorage, "singletonTagCodable")
    var singletonTagCodable = SingletonCodable.test
    @CodableSingleton("singletonCodable")
    var singletonCodable = SingletonCodable.test
    @UnwrappedStore(singletonTagStorage, "unwrappedSingletonTagDefault")
    var unwrappedSingletonTagDefault = "tagDefault"
    @UnwrappedSingleton("unwrappedSingletonDefault")
    var unwrappedSingletonDefault = "default"
    @UnwrappedCodableStore(singletonTagStorage, "unwrappedSingletonTagCodable")
    var unwrappedSingletonTagCodable = SingletonCodable.test
    @UnwrappedCodableSingleton("unwrappedSingletonCodable")
    var unwrappedSingletonCodable = SingletonCodable.test

    func testSingleton() {
        singletonStore = nil
        XCTAssertNil(singletonStore)
        let test = "testSingleton"
        singleton = test
        singletonTagStore = test
        XCTAssertEqual(singleton, test)
        XCTAssertEqual(singleton, singletonTagStore)
        let testRegister = "testRegister"
        SingletonStorage.standard.register(defaults: ["singleton": testRegister,
                                                      "singletonStore": testRegister,
                                                      "singletonTagStore": testRegister])
        XCTAssertNotEqual(singleton, testRegister)
        XCTAssertEqual(singletonStore, testRegister)
        XCTAssertEqual(singleton, singletonTagStore)
        singletonStore = test
        XCTAssertEqual(singleton, singletonStore)
        XCTAssertEqual(singleton, singletonTagStore)
        singleton = nil
        XCTAssertNil(singleton)
        XCTAssertNotEqual(singleton, singletonTagStore)
        XCTAssertEqual(singletonTagDefault, "tagDefault")
        XCTAssertEqual(singletonDefault, "default")
        singletonDefault = nil
        XCTAssertNil(singletonDefault)
        XCTAssertEqual(singletonTagCodable, .test)
        XCTAssertEqual(singletonCodable, .test)
        singletonCodable = nil
        XCTAssertNil(singletonCodable)
        XCTAssertEqual(unwrappedSingletonTagDefault, "tagDefault")
        XCTAssertEqual(unwrappedSingletonDefault, "default")
        XCTAssertEqual(unwrappedSingletonTagCodable, .test)
        XCTAssertEqual(unwrappedSingletonCodable, .test)
        unwrappedSingletonTagDefault = "tagDefaultAlternative"
        unwrappedSingletonDefault = "defaultAlternative"
        unwrappedSingletonTagCodable = .alternative
        unwrappedSingletonCodable = .alternative
        XCTAssertEqual(unwrappedSingletonTagDefault, "tagDefaultAlternative")
        XCTAssertEqual(unwrappedSingletonDefault, "defaultAlternative")
        XCTAssertEqual(unwrappedSingletonTagCodable, .alternative)
        XCTAssertEqual(unwrappedSingletonCodable, .alternative)
    }

    static let allTests = [
        ("testSingleton", testSingleton)
    ]
}
