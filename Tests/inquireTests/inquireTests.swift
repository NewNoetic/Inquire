import XCTest
@testable import inquire

final class inquireTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(inquire().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
