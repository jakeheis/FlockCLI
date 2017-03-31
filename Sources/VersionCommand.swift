//
//  VersionCommand.swift
//  FlockCLI
//
//  Created by Jake Heiser on 10/28/16.
//
//

import SwiftCLI

class VersionCommand: Command {
    
    let name = "--version"
    let shortDescription = "Prints the current version of Flock"
    
    func execute() throws {
        print("Version: \(CLI.version)")
    }
    
}
