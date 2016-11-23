//
//  AddEnvironmentCommand.swift
//  FlockCLI
//
//  Created by Jake Heiser on 10/26/16.
//
//

import SwiftCLI
import Rainbow

class AddEnvironmentCommand: Command {
    
    let name = "--add-env"
    let signature = "<env>"
    let shortDescription = "Adds an environment"
    
    func execute(arguments: CommandArguments) throws {
        let environment = arguments.requiredArgument("env")
        
        let creator = EnvironmentCreator(env: environment)
        try creator.create()
    }
    
}
