protocol Readlineable {
    func readLine() -> String?
}

public struct Inquire {
    var input: Readlineable
    var prompts: [Promptable]
    
    mutating func run() -> [String:Any] {
        var answers: [String:Any] = [:]
        
        prompts.forEach { prompt in
            switch prompt.type {
            case .input:
                print("* \(prompt.message)")
                let answer = input.readLine() ?? ""
                print(answer)
                answers[prompt.name] = answer
            case .confirm:
                print("* \(prompt.message) (y/n)")
                var answer: Character = Character(" ")
                while !(answer == "y" || answer == "n") {
                    answer = input.readLine()?.first ?? Character(" ")
                }
                print(answer)
                answers[prompt.name] = answer == "y"
            default: ()
            }
            
            switch prompt.self {
            case let prompt as Prompt<String>:
                prompt.answered(Response<String>(prompt: prompt , answer: answers[prompt.name] as! String))
            case let prompt as Prompt<[String]>:
                prompt.answered(Response<[String]>(prompt: prompt , answer: answers[prompt.name] as! [String]))
            case let prompt as Prompt<Bool>:
                prompt.answered(Response<Bool>(prompt: prompt , answer: answers[prompt.name] as! Bool))
            default: ()
            }
        }
        
        return answers
    }
}

protocol Promptable {
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
    var type: PromptType
    public var name: String
    public var message: String
    public var defaultValue: T?
    public var choices: [T]?
    public var answered: (Response<T>) -> Void
}

public struct Response<T> {
    private(set) var prompt: Prompt<T>
    var answer: T
}

