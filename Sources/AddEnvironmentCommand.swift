import SwiftCLI

class AddEnvironmentCommand: Command {
    
    let name = "add-env"
    let signature = "<env>"
    let shortDescription = "Adds an environment"
    
    func execute(arguments: CommandArguments) throws {
        let environment = arguments.requiredArgument("env")
        
        let creator = EnvironmentCreator(env: environment)
        try creator.create()
    }
    
}

class EnvironmentCreator {
    
    let env: String
    let defaults: [String]?
    
    var environmentFile: String {
        return "deploy/\(env.capitalized).swift"
    }
    
    var environmentLink: String {
        return "\(Paths.flockDirectory)/\(env.capitalized).swift"
    }
    
    init(env: String, defaults: [String]? = nil) {
        self.env = env
        self.defaults = defaults
    }
    
    var canCreate: Bool {
        return !FileHelpers.fileExists(environmentFile) && !FileHelpers.fileExists(environmentLink)
    }
    
    func create() throws {
        guard canCreate else {
            throw CLIError.error("\(environmentFile) and \(environmentLink) must not exist for you to create this env")
        }
        
        var lines = [
            "import Flock",
            "",
            "class \(env.capitalized): Configuration {",
            "    func configure() {"
        ]
        if let defaults = defaults {
            lines += defaults.map { "\t\t\($0)" }
        }
        lines += [            
            "    }",
            "}",
            ""
        ]
        let text = lines.joined(separator: "\n")
        
        try FileHelpers.createFile(at: environmentFile, contents: text)
        try FileHelpers.createSymlink(at: environmentLink, toPath: environmentFile)
    }
    
}
