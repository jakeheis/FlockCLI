//
//  InitCommand.swift
//  FlockCLI
//
//  Created by Jake Heiser on 10/26/16.
//
//

import Foundation
import SwiftCLI
import Rainbow
import PathKit
import Spawn

class InitCommand: FlockCommand {
  
    let name = "--init"
    let shortDescription = "Initializes Flock in the current directory"
    
    var configNeedsInfo = false
    
    func execute() throws {
        guard !flockIsInitialized else {
            throw CLIError.error("Flock has already been initialized".red)
        }
        
        try checkExisting()
        
        try createFiles()
        
        try updateGitIgnore()
        
        try build()
        
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
        try createDirectory(at: Path.deployDirectory)
        
        try write(contents: packageDefault(), to: Path.packageFile)
        try write(contents: dependenciesDefault(), to: Path.dependenciesFile)
        
        try write(contents: flockfileDefault(), to: Path.flockfile)
        try createLink(at: Path.mainFile, pointingTo: Path("..") + Path.flockfile, logPath: Path.flockfile)
        
        try createEnvironment(with: alwaysCreator)
        try createEnvironment(with: productionCreator)
        try createEnvironment(with: stagingCreator)
        
        print("Successfully created Flock files".green)
    }
    
    func build() throws {
        print("Downloading and building dependencies...".yellow)
        // Only doing this to build dependencies; actual build will fail
        do {
            try SPM.build(silent: true)
        } catch {}
        print("Successfully downloaded dependencies".green)
    }
    
    func updateGitIgnore() throws {
        print("Adding Flock files to .gitignore...".yellow)
        
        let appendText = [
            "",
            "# Flock",
            Path.buildDirectory.description,
            Path.packagesDirectory.description,
            ""
        ].joined(separator: "\n")
        
        let gitIgnorePath = Path(".gitignore")
        
        if gitIgnorePath.exists {
            guard let gitIgnore = OutputStream(toFileAtPath: gitIgnorePath.description, append: true) else {
                throw CLIError.error("Couldn't open .gitignore stream")
            }
            gitIgnore.open()
            gitIgnore.write(appendText, maxLength: appendText.characters.count)
            gitIgnore.close()
        } else {
            try gitIgnorePath.write(appendText)
        }
        
        print("Successfully added Flock files to .gitignore".green)
    }
    
    func printInstructions() {
        print()
        print("Follow these steps to finish setting up Flock:".cyan)
        print("1. Add `exclude: [\"Flockfile.swift\"]` to the end of your Package.swift")
        print("2. Add your production and staging servers to \(Path.deployDirectory)/Production.swift and \(Path.deployDirectory)/Staging.swift respectively")
        if configNeedsInfo {
            print("3. Update the required fields in \(Path.deployDirectory)/Always.swift")
        }
        print()
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
            "let url = URL(fileURLWithPath: \"../\(Path.dependenciesFile)\")",
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
            "Flock.use(.deploy)",
            "Flock.use(.swiftenv)",
            "Flock.use(.server)",
            "",
            "Flock.configure(.always, with: Always()) // Located at \(Path.deployDirectory)/Always.swift",
            "Flock.configure(.env(\"production\"), with: Production()) // Located at \(Path.deployDirectory)/Production.swift",
            "Flock.configure(.env(\"staging\"), with: Staging()) // Located at \(Path.deployDirectory)/Staging.swift",
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
            "           \"url\" : \"https://github.com/jakeheis/Flock\",",
            "           \"major\": 0",
            "       }",
            "   ]",
            "}",
            ""
        ].joined(separator: "\n")
    }
    
    private func productionDefaults() -> [String] {
      return [
            "// Config.SSHAuthMethod = .key(\"/path/to/mykey\")",
            "// Servers.add(ip: \"9.9.9.9\", user: \"user\", roles: [.app, .db, .web])"
      ]
    }
    
    private func stagingDefaults() -> [String] {
        return [
            "// Servers.add(SSHHost: \"StagingServer\", roles: [.app, .db, .web])"
        ]
    }
    
    private func alwaysDefaults() -> [String] {
        var projectName = "nil // Fill this in!"
        var executableName = "nil // // Fill this in! (same as Config.projectName unless your project is divided into modules)"
        do {
            
            let dump = try SPM.dump()

            guard let name = dump["name"] as? String else {
                throw SPM.Error.processFailed
            }
            projectName = "\"\(name)\""
            
            if let targets = dump["targets"] as? [[String: Any]], !targets.isEmpty {
                var targetNames = Set<String>()
                var dependencyNames = Set<String>()
                for target in targets {
                    guard let targetName = target["name"] as? String,
                        let dependencies = target["dependencies"] as? [String] else {
                            continue
                    }
                    targetNames.insert(targetName)
                    dependencyNames.formUnion(dependencies)
                }
                let executables = targetNames.subtracting(dependencyNames)
                if executables.count == 1 {
                    executableName = "\"\(executables.first!)\""
                } else {
                    configNeedsInfo = true
                }
            } else {
                executableName = projectName
            }
        } catch {
            configNeedsInfo = true
        }
        
        var repoUrl = "nil // Fill this in!"
        
        do {
            var output = ""
            let urlProcess = try Spawn(args: ["/usr/bin/env", "git", "remote", "get-url", "origin"], output: { (chunk) in
                output += chunk
            })
            
            if urlProcess.waitForExit() == 0 {
                repoUrl = "\"\(output.trimmingCharacters(in: .whitespacesAndNewlines))\""
            }
        } catch {}
        
        if repoUrl.hasPrefix("nil") {
            configNeedsInfo = true
        }
    
        return [
            "Config.projectName = \(projectName)",
            "Config.executableName = \(executableName)",
            "Config.repoURL = \(repoUrl)",
            "",
            "// IF YOU PLAN TO RUN `flock tools` AS THE ROOT USER BUT `flock deploy` AS A DEDICATED DEPLOY USER,",
            "// (as you should, see https://github.com/jakeheis/Flock/blob/master/README.md#permissions)",
            "// SET THIS VARIABLE TO THE NAME OF YOUR (ALREADY CREATED) DEPLOY USER BEFORE RUNNING `flock tools`:",
            "// Config.supervisordUser = \"deploy:deploy\"",
            "",
            "// Optional config:",
            "// Config.deployDirectory = \"/var/www\"",
            "// Config.swiftVersion = \"3.0.2\" // If you have a `.swift-version` file, this line is not necessary"
        ]
    }
  
}
