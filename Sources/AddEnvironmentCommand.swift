import SwiftCLI

class AddEnvironmentCommand: CommandType {
    
    let commandName = "add-env"
    let commandSignature = "<env>"
    let commandShortDescription = "Adds an environment"
    
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
        return "deploy/\(env.capitalizedString).swift"
    }
    
    var environmentLink: String {
        return "\(Paths.flockDirectory)/\(env.capitalizedString).swift"
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
            throw CLIError.Error("\(environmentFile) and \(environmentLink) must not exist for you to create this env")
        }
        
        var lines = [
            "import Flock",
            "",
            "class \(env.capitalizedString): Configuration {",
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
        let text = lines.joinWithSeparator("\n")
        
        try FileHelpers.createFileAtPath(environmentFile, contents: text)
        try FileHelpers.createSymlinkAtPath(environmentLink, toPath: environmentFile)
    }
    
}
