//
//  FlockCommand.swift
//  FlockCLI
//
//  Created by Jake Heiser on 10/26/16.
//
//

import SwiftCLI
import PathKit
import Rainbow

protocol FlockCommand: Command {}

extension FlockCommand {
    
    var flockIsInitialized: Bool {
        if !Path.flockfile.exists {
            return false
        }
        if !Path.flockDirectory.exists {
            do {
                try formFlockDirectory()
            } catch {
                return false
            }
        }
        
        do {
            try linkFilesIntoFlock()
        } catch {}
        
        return true
    }
    
    func guardFlockIsInitialized() throws {
        if !flockIsInitialized {
            throw CLIError.error("Flock has not been initialized in this directory yet - run `flock --init`".red)
        }
    }
    
    func formFlockDirectory() throws {
        if Path.flockDirectory.exists {
            return
        }
        
        try Path.flockDirectory.mkpath()
        
        try Path.packageFile.write(packageDefault())
        try Path.mainFile.symlink(Path("..") + Path.flockfile)
    }
    
    func linkFilesIntoFlock() throws {
        for file in try Path.deployDirectory.children() where file.extension == "swift" {
            let link = Path.flockDirectory + file.lastComponent
            if !link.exists {
                try link.symlink(Path("..") + file)
            }
        }
    }
    
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
    
}
