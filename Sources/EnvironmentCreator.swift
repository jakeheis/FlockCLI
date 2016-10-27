//
//  EnvironmentCreator.swift
//  FlockCLI
//
//  Created by Jake Heiser on 10/26/16.
//
//

import SwiftCLI
import FileKit

class EnvironmentCreator {
    
    let env: String
    let defaults: [String]?
    
    var fileName: String {
        return "\(env.capitalized).swift"
    }
    
    var environmentFile: Path {
        return Path.deployDirectory + fileName
    }
    
    var environmentLink: Path {
        return Path.flockDirectory + fileName
    }
    
    var canCreate: Bool {
        return !environmentFile.exists && !environmentLink.exists
    }
    
    init(env: String, defaults: [String]? = nil) {
        self.env = env
        self.defaults = defaults
    }
    
    func create() throws {
        guard canCreate else {
            throw CLIError.error("Error: \(environmentFile) and/or \(environmentLink) already exist".red)
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
        
        try text.write(to: environmentFile)
        try environmentFile.symlinkFile(to: environmentLink)
    }
    
}

