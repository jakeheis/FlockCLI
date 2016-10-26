import Foundation
import SwiftCLI
import Rainbow

class InitCommand: Command {
  
    let name = "--init"
    let signature = ""
    let shortDescription = ""
    
    func execute(arguments: CommandArguments) throws {
        if FileHelpers.flockIsInitialized() {
            throw CLIError.error("Flock has already been initialized")
        }
        
        // Ensure required files do not already exist
        for directory in [Paths.flockDirectory] { 
            if FileHelpers.directoryExists(directory) {
                throw CLIError.error("\(directory) must not already exist")
            }
        }
        for file in [Paths.flockfile, Paths.packageFile] { 
            if FileHelpers.fileExists(file) {
                throw CLIError.error("\(file) must not already exist")
            }
        }
        
        print("Creating Flock files...".yellow)
        
        let alwaysCreator = EnvironmentCreator(env: "always", defaults: alwaysDefaults())
        let productionCreator = EnvironmentCreator(env: "production", defaults: productionDefaults())
        let stagingCreator = EnvironmentCreator(env: "staging", defaults: stagingDefaults())
        
        guard alwaysCreator.canCreate && productionCreator.canCreate && stagingCreator.canCreate else {
            throw CLIError.error("deploy/[always,production,staging].swift and deploy/.flock/[always,production,staging].swift must not already exist")
        }
        
        // Create files
        try FileHelpers.createDirectory(at: Paths.flockDirectory)
        
        try FileHelpers.createFile(at: Paths.packageFile, contents: packageDefault())
        try FileHelpers.createFile(at: Paths.dependenciesFile, contents: dependenciesDefault())
        
        try FileHelpers.createFile(at: Paths.mainFile, contents: flockfileDefault())
        try FileHelpers.createSymlink(at: Paths.flockfile, toPath: Paths.mainFile)
        
        try alwaysCreator.create()
        try productionCreator.create()
        try stagingCreator.create()
        
        print("Successfully created Flock files".green)
        
        print("Downloading and building dependencies...".yellow)
        Builder.build(silent: true)
        print("Successfully downloaded dependencies".green)
        
        print("Successfully initialized Flock!".green)
        
        print("Steps to take to ensure Flock works correctly:".yellow)
        print("1. Update the required fields in deploy/Always.swift")
        print("2. Add your production and staging servers to deploy/Production.swift and deploy/Staging.swift respectively")
        print("3. In your project's Package.swift, add `deploy` to the ignore list")
        print()
        print("To add Flock dependencies:")
        print("1. Add the url and version of the dependency to deploy/FlockDependencies.json")
        print("2. in your Flockfile, at the top of the file import your dependency and below add `Flock.use(Dependency)`")
    }
    
    // MARK: - Defaults
    
    private func packageDefault() -> String {
        return [
            "// Don't change!",
            "",
            "import PackageDescription",
            "import Foundation",
            "",
            "let package = Package(",
            "   name: \"Flockfile\"",
            ")",
            "",
            "let url = URL(fileURLWithPath: \"../FlockDependencies.json\")",
            "if let data = try? Data(contentsOf: url),",
            "    let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: [[String: Any]]],",
            "    let dependencies = json[\"dependencies\"] {",
            "    ",
            "    for dependency in dependencies {",
            "        guard let name = dependency[\"name\"] as? String else {",
            "            print(\"Ignoring invalid dependency \\(dependency)\")",
            "            continue",
            "        }",
            "        let dependencyPackage: Package.Dependency",
            "        if let version = dependency[\"version\"] as? String, let packageVersion = Version(version) {",
            "            dependencyPackage = Package.Dependency.Package(url: name, packageVersion)",
            "        } else if let major = dependency[\"major\"] as? Int {",
            "            if let minor = dependency[\"minor\"] as? Int {",
            "                dependencyPackage = Package.Dependency.Package(url: name, majorVersion: major, minor: minor)",
            "            } else {",
            "                dependencyPackage = Package.Dependency.Package(url: name, majorVersion: major)",
            "            }",
            "        } else {",
            "            print(\"Ignoring invalid dependency \\(name)\")",
            "            continue",
            "        }",
            "        package.dependencies.append(dependencyPackage)",
            "    }",
            "}",
            ""
        ].joined(separator: "\n")
    }
  
    private func flockfileDefault() -> String {
      return [
            "import Flock",
            "",
            "Flock.use(Flock.Deploy)",
            "",
            "Flock.configure(.always, with: Always()) // Located at deploy/Always.swift",
            "Flock.configure(.env(\"production\"), with: Production()) // Located at deploy/Production.swift",
            "Flock.configure(.env(\"staging\"), with: Staging()) // Located at deploy/Staging.swift",
            "",
            "Flock.run()",
            ""
        ].joined(separator: "\n")
    }
    
    private func dependenciesDefault() -> String {
        return [
            "{",
            "   \"dependencies\" : [",
            "       {",
            "           \"name\" : \"/Users/jakeheiser/Documents/Swift/Flock\",",
            "           \"version\": \"0.0.1\"",
            "       }",
            "   ]",
            "}",
            ""
        ].joined(separator: "\n")
    }
    
    private func productionDefaults() -> [String] {
      return [
            "// Servers.add(SSHHost: \"ProductionServer\", roles: [.app, .db, .web])"
      ]
    }
    
    private func stagingDefaults() -> [String] {
        return [
            "// Servers.add(SSHHost: \"StagingServer\", roles: [.app, .db, .web])"
        ]
    }
    
    private func alwaysDefaults() -> [String] {
        return [
            "// Update these values before using Flock:",
            "Config.projectName = nil",
            "Config.executableName = nil",
            "Config.repoURL = nil",
            "",
            "// Optional config:",
            "// Config.deployDirectory = \"/var/www\""
        ]
    }
  
    private func inputProjectName() -> String {
        return Input.awaitInput(message: "Project name (must be same as in Package.swift): ")
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
