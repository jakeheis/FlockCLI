//
//  ForwardCommand.swift
//  FlockCLI
//
//  Created by Jake Heiser on 10/26/16.
//
//

import PathKit
import SwiftCLI

class ForwardCommand: FlockCommand {
    
    let name = ""
    let shortDescription = ""
    
    let task = Parameter()
    let args = OptionalCollectedParameter()
    
    func execute() throws {
        try guardFlockIsInitialized()
        try Beak.run(task: task.value, args: args.value)
    }
    
}
