//
//  InitCommand.swift
//  FlockCLI
//
//  Created by Jake Heiser on 10/26/16.
//
//

import SwiftCLI
import Rainbow
import FileKit

class InitCommand: FlockCommand {
  
    let name = "--init"
    let signature = ""
    let shortDescription = ""
    
    func execute(arguments: CommandArguments) throws {
        guard !flockIsInitialized else {
            throw CLIError.error("Flock has already been initialized".red)
        }
        
        try checkExisting()
        
        try createFiles()
        
        build()
        
        print("Successfully initialized Flock!".green)
        
        printInstructions()
    }
    
    func checkExisting() throws {
        for path in [Path.flockDirectory, Path.flockfile, Path.packageFile] {
            if path.exists {
                throw CLIError.error("\(path) must not already exist".red)
            }
        }
    }
    
    func createFiles() throws {
        print("Creating Flock files...".yellow)
        
        let alwaysCreator = EnvironmentCreator(env: "always", defaults: alwaysDefaults())
        let productionCreator = EnvironmentCreator(env: "production", defaults: productionDefaults())
        let stagingCreator = EnvironmentCreator(env: "staging", defaults: stagingDefaults())
        
        guard alwaysCreator.canCreate && productionCreator.canCreate && stagingCreator.canCreate else {
            throw CLIError.error("deploy/Always.swift, deploy/Production.swift, and deploy/Staging.swift must not already exist".red)
        }
        
        // Create files
        
        try createDirectory(at: Path.flockDirectory)
        
        try write(contents: packageDefault(), to: Path.packageFile)
        try write(contents: dependenciesDefault(), to: Path.dependenciesFile)
        
        try write(contents: flockfileDefault(), to: Path.mainFile)
        try createLink(at: Path.flockfile, pointingTo: Path.mainFile, logPath: Path.mainFile)
        
        try createEnvironment(with: alwaysCreator)
        try createEnvironment(with: productionCreator)
        try createEnvironment(with: stagingCreator)
        
        print("Successfully created Flock files".green)
    }
    
    func build() {
        print("Downloading and building dependencies...".yellow)
        Builder.build(silent: true)
        print("Successfully downloaded dependencies".green)
    }
    
    func printInstructions() {
        print()
        print("IN ORDER FOR FLOCK TO WORK CORRECTLY".yellow)
        print("Follow these steps:".yellow)
        print("1. Update the required fields in deploy/Always.swift")
        print("2. Add your production and staging servers to deploy/Production.swift and deploy/Staging.swift respectively")
        print()
        print("To add Flock dependencies:".yellow)
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
            "        guard let url = dependency[\"url\"] as? String else {",
            "            print(\"Ignoring invalid dependency \\(dependency)\")",
            "            continue",
            "        }",
            "        let dependencyPackage: Package.Dependency",
            "        if let version = dependency[\"version\"] as? String, let packageVersion = Version(version) {",
            "            dependencyPackage = Package.Dependency.Package(url: url, packageVersion)",
            "        } else if let major = dependency[\"major\"] as? Int {",
            "            if let minor = dependency[\"minor\"] as? Int {",
            "                dependencyPackage = Package.Dependency.Package(url: url, majorVersion: major, minor: minor)",
            "            } else {",
            "                dependencyPackage = Package.Dependency.Package(url: url, majorVersion: major)",
            "            }",
            "        } else {",
            "            print(\"Ignoring invalid dependency \\(url)\")",
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
            "Flock.use(Flock.Tools)",
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
            "           \"url\" : \"/Users/jakeheiser/Documents/Swift/Flock\",",
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
  
}
