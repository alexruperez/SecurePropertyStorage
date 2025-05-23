import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    [
        testCase(UserDefaultTests.allTests),
        testCase(SingletonTests.allTests),
        testCase(KeychainTests.allTests),
        testCase(InjectTests.allTests),
        testCase(ConcurrencyTests.allTests)
    ]
}
#endif
