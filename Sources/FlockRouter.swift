//
//  FlockRouter.swift
//  FlockCLI
//
//  Created by Jake Heiser on 10/30/16.
//
//

import SwiftCLI

class FlockRouter: Router {
    
    func route(commands: [Command], aliases: [String : String], arguments: RawArguments) -> Command? {
        guard let name = arguments.unclassifiedArguments.first else {
            return CLI.helpCommand
        }
        
        let searchName = aliases[name.value] ?? name.value
        
        if let command = commands.first(where: { $0.name == searchName }) {
            name.classification = .commandName
            return command
        }
        
        if searchName.hasPrefix("-") {
            return nil
        }
        
        return ForwardCommand()
    }
    
}
