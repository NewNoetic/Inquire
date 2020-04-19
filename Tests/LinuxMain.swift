import XCTest

import inquireTests

var tests = [XCTestCaseEntry]()
tests += inquireTests.allTests()
XCTMain(tests)
