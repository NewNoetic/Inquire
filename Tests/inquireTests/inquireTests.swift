import XCTest
@testable import inquire

final class inquireTests: XCTestCase {
    func testAddPrompt() {
        let testAnswers = [
            "username": "scrappy",
            "top_2_veggies": ["carrot", "avocado"],
            "like_peanuts": false,
            "italian_dish": "pizza"
            ] as [String : Any]
        
        let prompts: [Promptable] = [
            Prompt<String>(type: .input, name: "username", message: "What's your username?", defaultValue: "scooby") { response in
                XCTAssert(response.answer == testAnswers["username"] as! String)
            },
            Prompt<[String]>(type: .multi, name: "top_2_veggies", message: "What are your top 2 favorite veggies?", defaultValue: ["avocado", "potato", "carrot"]) { response in
                XCTAssert(response.answer == testAnswers["top_2_veggies"] as! [String])
            },
            Prompt<Bool>(type: .confirm, name: "like_peanuts", message: "Do you like peanuts?", defaultValue: true) { response in
                XCTAssert(response.answer == testAnswers["like_peanuts"] as! Bool)
            },
            Prompt<String>(type: .list, name: "italian_dish", message: "What is your favorite Italian dish?", choices: ["pizza", "pasta", "salad"]) { response in
                XCTAssert(response.answer == testAnswers["italian_dish"] as! String)
            }
            ]
        
        var inq = Inquire(prompts: prompts)
        inq.answers = testAnswers
        inq.run()
    }

    static var allTests = [
        ("testAddPrompt", testAddPrompt),
    ]
}
