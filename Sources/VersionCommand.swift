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
    let signature = ""
    let shortDescription = "Prints the current version of Flock"
    
    func execute(arguments: CommandArguments) throws {
        print("Version: \(CLI.version)")
    }
    
}
