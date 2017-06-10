//
//  EnvironmentCreator.swift
//  FlockCLI
//
//  Created by Jake Heiser on 10/26/16.
//
//

import SwiftCLI
import PathKit

class EnvironmentCreator {
    
    private init() {}
    
    static func create(env: String, defaults: [String]? = nil, link: Bool) throws {
        let fileName = "\(env.capitalized).swift"
        let filePath = Path.deployDirectory + fileName
        let linkPath = Path.flockDirectory + fileName
        
        if filePath.exists {
            throw CLIError.error("Error: \(filePath) already exists".red)
        }
        
        var lines = [
            "import Flock",
            "import SSH",
            "",
            "class \(env.capitalized): Environment {",
            "\tfunc configure() {"
        ]
        if let defaults = defaults {
            lines += defaults.map { "\t\t\($0)" }
        }
        lines += [
            "\t}",
            "}",
            ""
        ]
        let text = lines.joined(separator: "\n")
        
        try write(contents: text, to: filePath)
        
        if link {
            try linkPath.symlink(".." + filePath)
        }
    }
    
}

