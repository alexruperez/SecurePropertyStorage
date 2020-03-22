import XCTest
import Singleton
import Storage

let singletonTagStorage: DelegatedStorage = SingletonStorage(authenticationTag: Data())

final class SingletonTests: XCTestCase {
    @Store(singletonTagStorage, "singletonTagStore") var singletonTagStore: String?
    @Store(SingletonStorage.standard, "singletonStore") var singletonStore: String?
    @Singleton("singleton") var singleton: String?

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
    }

    static var allTests = [
        ("testSingleton", testSingleton)
    ]
}
