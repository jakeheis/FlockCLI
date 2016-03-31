import Foundation
import SwiftCLI
import Rainbow

class InitCommand: CommandType {
  
    let commandName = "init"
    let commandSignature = ""
    let commandShortDescription = ""
    
    func execute(arguments: CommandArguments) throws {
        if FileHelpers.flockIsInitialized() {
            throw CLIError.Error("Flock has already been initialized")
        }
        
        // Ensure required files do not already exist
        for directory in [Paths.flockDirectory] { 
            if FileHelpers.directoryExists(directory) {
                throw CLIError.Error("\(directory) must not already exist") 
            }
        }
        for file in [Paths.flockfile, Paths.packageFile] { 
            if FileHelpers.fileExists(file) {
                throw CLIError.Error("\(file) must not already exist") 
            }
        }
        
        let alwaysCreator = EnvironmentCreator(env: "always", defaults: alwaysDefaults())
        let productionCreator = EnvironmentCreator(env: "production", defaults: productionDefaults())
        let stagingCreator = EnvironmentCreator(env: "staging", defaults: stagingDefaults())
        
        guard alwaysCreator.canCreate && productionCreator.canCreate && stagingCreator.canCreate else {
            throw CLIError.Error("deploy/[always,production,staging].swift and deploy/.flock/[always,production,staging].swift must not already exist")
        }
        
        // Create files
        try FileHelpers.createDirectoryAtPath(Paths.flockDirectory)
        
        try FileHelpers.createFileAtPath(Paths.packageFile, contents: packageDefault())
        try FileHelpers.createSymlinkAtPath(Paths.packageFileLink, toPath: Paths.packageFile)
        
        try FileHelpers.createFileAtPath(Paths.mainFile, contents: flockfileDefault())
        try FileHelpers.createSymlinkAtPath(Paths.flockfile, toPath: Paths.mainFile)
        
        try alwaysCreator.create()
        try productionCreator.create()
        try stagingCreator.create()
        
        print("Successfully initialized flock!".green)
    }
    
    // MARK: - Defaults
    
    private func packageDefault() -> String {
      return [
        "import PackageDescription",
        "",
        "let package = Package(",
        "   name: \"Flockfile\", // Don't change this!",
        "   dependencies: [",
        "       .Package(url: \"/Users/jakeheiser/Documents/Swift/Flock\", majorVersion: 0, minor: 0)",
        "   ]",
        ")",
        ""
      ].joinWithSeparator("\n")
    }
  
    private func flockfileDefault() -> String {
      return [
            "import Flock",
            "",
            "Flock.use(Flock.Deploy)",
            "",
            "Flock.addConfiguration(Always(), .Always) // Located at deploy/Always.swift",
            "Flock.addConfiguration(Production(), .Environment(\"production\")) // Located at deploy/Production.swift",
            "Flock.addConfiguration(Staging(), .Environment(\"staging\")) // Located at deploy/Staging.swift",
            "",
            "Flock.run()",
            ""
        ].joinWithSeparator("\n")
    }
    
    private func productionDefaults() -> [String] {
      return [
            "// Servers.add(SSHHost: \"ProductionServer\", roles: [.App, .DB, .Web])"
      ]
    }
    
    private func stagingDefaults() -> [String] {
        return [
            "// Servers.add(SSHHost: \"StagingServer\", roles: [.App, .DB, .Web])"
        ]
    }
    
    private func alwaysDefaults() -> [String] {
        let name = inputProjectName() ?? "Project"
        return [
            "Config.projectName = \"\(name)\"",
            "// Config.repoURL = \"URL\""
        ]
    }
  
    private func inputProjectName() -> String? {
        return try? Input.awaitInput(message: "Project name (must be same as in Package.swift): ")
        // guard let text = try? String(contentsOfFile: "Package.swift", encoding: NSUTF8StringEncoding) else {
        //     print("WARNING: The name of your project could not be found (we looked for a Package.swift). In order to ensure Flock works correctly, make sure you edit deploy/Always.swift to reflect your true project name.".red)
        //     return nil
        // }
        // let lines = text.componentsSeparatedByString("\n")
        // for line in lines {
        //     if (line as NSString).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).hasPrefix("name"),
        //         let word = line.componentsSeparatedByString(" ").filter({ $0.hasPrefix("\"") }).first {
        //         let startIndex = line.startIndex.successor()
        //         // return word.substringWithRange()
        //         return word
        //     }
        // }
        // return nil
    }
  
}
