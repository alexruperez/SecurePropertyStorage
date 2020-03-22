import XCTest

import PropertyWrappersTests

var tests = [XCTestCaseEntry]()
tests += UserDefaultTests.allTests()
tests += SingletonTests.allTests()
tests += KeychainTests.allTests()
XCTMain(tests)
