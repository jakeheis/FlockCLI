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
    let shortDescription = "Adds an environment"
    
    let env = Parameter()
    
    func execute() throws {
        let creator = EnvironmentCreator(env: env.value)
        try creator.create()
    }
    
}
