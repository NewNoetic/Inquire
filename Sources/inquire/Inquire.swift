public struct Inquire {
    var prompts: [Promptable]
    var finished: (([String:Any]) -> Void)?
    internal var answers: [String:Any] = [:]
    
    func run() {
        prompts.forEach { prompt in
            switch prompt.self {
            case let prompt as Prompt<String>:
                prompt.answered(Response<String>(prompt: prompt , answer: self.answers[prompt.name] as! String))
            case let prompt as Prompt<[String]>:
                prompt.answered(Response<[String]>(prompt: prompt , answer: self.answers[prompt.name] as! [String]))
            case let prompt as Prompt<Bool>:
                prompt.answered(Response<Bool>(prompt: prompt , answer: self.answers[prompt.name] as! Bool))
            default: ()
            }
        }
        
        if let finished = finished {
            finished(answers)
        }
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

