//
//  HelpCommand.swift
//  FlockCLI
//
//  Created by Jake Heiser on 10/28/16.
//
//

import SwiftCLI
import Spawn
import PathKit

class HelpCommand: SwiftCLI.HelpCommand, FlockCommand {
    
    let name = "--help"
    let shortDescription = "Prints help information"
    
    var printCLIDescription: Bool = true
    var availableCommands: [Command] = []
        
    func execute() throws {
        print("Available commands: ")
        
        printLine(name: "<task>", description: "Execute the given task")
        
        for command in availableCommands {
            var name = command.name
            if !command.signature.isEmpty {
                name += " \(command.signature)"
            }
            printLine(name: name, description: command.shortDescription)
        }
        
        if flockIsInitialized {
            print()
            
            if Path.executable.exists {
                // Forward to help command of local cli
                let spawn = try Spawn(args: [Path.executable.description, "--help"]) { (chunk) in
                    print(chunk, terminator: "")
                }
                _ = spawn.waitForExit()
            } else {
                print("Local Flock not built; run `flock --build` then `flock` to see available tasks")
            }
        }
    }
    
    private func printLine(name: String, description: String) {
        let spacing = String(repeating: " ", count: 20 - name.characters.count)
        print("flock \(name)\(spacing)\(description)")
    }
    
}
