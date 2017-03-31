//
//  FlockRouter.swift
//  FlockCLI
//
//  Created by Jake Heiser on 10/30/16.
//
//

import SwiftCLI

class FlockRouter: Router {
    
    func route(commands: [Command], arguments: ArgumentList) -> Command? {
        // Just ran `flock`
        guard let name = arguments.head else {
            return nil
        }
        
        // Ran something like `flock --init`
        if let command = commands.first(where: { $0.name == name.value }) {
            arguments.remove(node: name)
            return command
        }
        
        // Ran something like `flock --notreal`
        if name.value.hasPrefix("-") {
            return nil
        }
        
        // Ran something like `flock deploy`
        return ForwardCommand()
    }
    
}
