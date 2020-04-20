import Foundation

public protocol Readlineable {
    func read() -> String?
}

public class PromptIterator: IteratorProtocol {
    var prompts: [Promptable]
    var current: Int = 0
    
    init(_ prompts: [Promptable]) {
        self.prompts = prompts
    }
    
    public func next() -> Promptable? {
        defer { current += 1 }
        guard prompts.count > current else {
            return nil
        }
        return prompts[current]
    }
    
    public func append(_ prompt: Promptable) {
        self.prompts.append(prompt)
    }
    
    public func append(_ prompts: [Promptable]) {
        self.prompts.append(contentsOf: prompts)
    }
    
    public typealias Element = Promptable
}

public struct Inquire {
    typealias Index = Int
    
    public var input: Readlineable
    public var prompts: PromptIterator
    private var currentPrompt: Index = 0
    
    public init(input: Readlineable, prompts: [Promptable]) {
        self.input = input
        self.prompts = PromptIterator(prompts)
    }
    
    public func run() -> [String:Any] {
        var answers: [String:Any] = [:]
        
        while let prompt = prompts.next() {
            switch prompt.type {
            case .input:
                print("* \(prompt.message)")
                let answer = input.read() ?? ""
                answers[prompt.name] = answer
            case .confirm:
                var answer: Character = Character(" ")
                while !(answer == "y" || answer == "n") {
                    print("* \(prompt.message) (y/n)")
                    answer = input.read()?.first ?? Character(" ")
                }
                answers[prompt.name] = answer == "y"
            case .list:
                guard let prompt = prompt as? Prompt<String> else {
                    fatalError()
                }
                guard let choices = prompt.choices else {
                    fatalError("list prompt didn't have choices")
                }
                for (index, choice) in choices.enumerated() {
                    print("\(index+1) \(choice)")
                }
                var answer: Int!
                while (answer == nil || !(1...choices.count).contains(answer)) {
                    print("* \(prompt.message) (Enter the number for your choice)")
                    guard let str = input.read() else { continue }
                    guard let int = Int(str) else { continue }
                    answer = int
                }
                answers[prompt.name] = choices[answer - 1]
            default: ()
            }
            
            switch prompt.self {
            case let prompt as Prompt<String>:
                prompt.answered?(Response<String>(prompt: prompt , answer: answers[prompt.name] as! String))
            case let prompt as Prompt<[String]>:
                prompt.answered?(Response<[String]>(prompt: prompt , answer: answers[prompt.name] as! [String]))
            case let prompt as Prompt<Bool>:
                prompt.answered?(Response<Bool>(prompt: prompt , answer: answers[prompt.name] as! Bool))
            default: ()
            }
        }
        
        return answers
    }
}

public protocol Promptable {
    var type: PromptType { get set }
    var name: String { get set }
    var message: String { get set }
}

public enum PromptType {
    case input
    case confirm
    case list
    case multi
    case checkbox
    case password
    case editor
}

public struct Prompt<T>: Promptable {
    public typealias AnsweredType = (Response<T>) -> Void
    
    public var type: PromptType
    public var name: String
    public var message: String
    public var defaultValue: T?
    public var choices: [T]?
    public var answered: AnsweredType?
    
    public init(type: PromptType, name: String, message: String, defaultValue: T? = nil, choices: [T]? = nil, answered: AnsweredType? = nil) {
        self.type = type
        self.name = name
        self.message = message
        self.defaultValue = defaultValue
        self.choices = choices
        self.answered = answered
    }
}

public struct Response<T> {
    private(set) public var prompt: Prompt<T>
    public var answer: T
}

