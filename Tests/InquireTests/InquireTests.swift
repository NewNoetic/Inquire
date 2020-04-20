import XCTest
@testable import Inquire

class MockInput: Readlineable {
    var answers: [Any] = []
    internal var currentIndex = 0
    
    func read() -> String? {
        let index = currentIndex
        currentIndex += 1
        return answers[index] as? String
    }
}


final class inquireTests: XCTestCase {
    func testAddPrompt() {
        let testAnswers = [
            "username": "someone",
            "like_peanuts": false,
            "italian_dish": "pasta"
            ] as [String : Any]
        
        let testInput = [
            "someone",
            "n",
            "2"
            ] as [Any]
        
        let mockInput = MockInput()
        mockInput.answers = testInput
        
        let prompts: [Promptable] = [
            Prompt<String>(type: .input, name: "username", message: "What's your username?", defaultValue: "scooby") { response in
                XCTAssert(response.answer == testAnswers["username"] as! String)
            },
            Prompt<Bool>(type: .confirm, name: "like_peanuts", message: "Do you like peanuts?", defaultValue: true) { response in
                XCTAssert(response.answer == testAnswers["like_peanuts"] as! Bool)
            },
            //            Prompt<[String]>(type: .multi, name: "top_2_veggies", message: "What are your top 2 favorite veggies?", defaultValue: ["avocado", "potato", "carrot"]) { response in
            //                XCTAssert(response.answer == testAnswers["top_2_veggies"] as! [String])
            //            },
            Prompt<String>(type: .list, name: "italian_dish", message: "What is your favorite Italian dish?", choices: ["pizza", "pasta", "salad"]) { response in
                XCTAssert(response.answer == testAnswers["italian_dish"] as! String)
            }
        ]
        
        var inq = Inquire(input: mockInput, prompts: prompts)
        let answers = inq.run()
        print(answers)
        XCTAssert(answers["username"] as! String == testAnswers["username"] as! String)
        XCTAssert(answers["like_peanuts"] as! Bool == testAnswers["like_peanuts"] as! Bool)
        XCTAssert(answers["italian_dish"] as! String == testAnswers["italian_dish"] as! String)
    }
    
    static var allTests = [
        ("testAddPrompt", testAddPrompt),
    ]
}
