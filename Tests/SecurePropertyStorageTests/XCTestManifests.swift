import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(UserDefaultTests.allTests),
        testCase(SingletonTests.allTests),
        testCase(KeychainTests.allTests)
    ]
}
#endif
