import XCTest

import PropertyWrappersTests

var tests = [XCTestCaseEntry]()
tests += UserDefaultTests.allTests()
tests += SingletonTests.allTests()
tests += KeychainTests.allTests()
tests += InjectTests.allTests()
XCTMain(tests)
