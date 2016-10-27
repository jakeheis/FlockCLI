//
//  ForwardCommand.swift
//  FlockCLI
//
//  Created by Jake Heiser on 10/26/16.
//
//

import Foundation
import SwiftCLI
import FileKit

class ForwardCommand: FlockCommand {
    
    let name = ""
    let signature = "[<optional>] ..."
    let shortDescription = ""
    
    func execute(arguments: CommandArguments) throws {
        try guardFlockIsInitialized()
        
        let result = Builder.build()
        if result == false {
            throw CLIError.error("Error: Flock must be successfully built before tasks can be run".red)
        }
        
        let task = Process()
        task.launchPath = Path.executable.rawValue
        task.arguments = arguments.optionalCollectedArgument("optional") ?? []
        task.launch()
        task.waitUntilExit()
    }
    
}
