//
//  HelpCommand.swift
//  FlockCLI
//
//  Created by Jake Heiser on 10/28/16.
//
//

#if os(Linux)
    import Glibc
#else
    import Darwin
#endif

import SwiftCLI
import FileKit

class HelpCommand: SwiftCLI.HelpCommand, FlockCommand {
    
    let name = "--help"
    let signature = "[<opt>] ..."
    let shortDescription = "Prints help information"
    
    let failOnUnrecognizedOptions = false
    let unrecognizedOptionsPrintingBehavior = UnrecognizedOptionsPrintingBehavior.printNone
    let helpOnHFlag = false
    
    var printCLIDescription: Bool = true
    var allCommands: [Command] = []
    
    func setupOptions(options: OptionRegistry) {}
    
    func execute(arguments: CommandArguments) throws {
        try guardFlockIsInitialized()
        
        print("Available commands: ")
        
        for command in allCommands {
            printCommand(command)
        }
        print()
        
        // Forward to help command of local cli
        execv(Path.executable.rawValue, CommandLine.unsafeArgv)
    }
    
    private func printCommand(_ command: Command) {
        let spacing = String(repeating: " ", count: 20 - command.name.characters.count)
        print("flock \(command.name)\(spacing)\(command.shortDescription)")
    }
    
}
