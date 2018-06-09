//
//  Router.swift
//  FlockCLI
//
//  Created by Jake Heiser on 10/30/16.
//
//

import SwiftCLI

class Router: SwiftCLI.Router {
    
    func parse(commandGroup: CommandGroup, arguments: ArgumentList) throws -> (CommandPath, OptionRegistry) {
        let path = CommandGroupPath(top: commandGroup)
        let optionRegistry = OptionRegistry(routable: commandGroup)
        
        // Just ran `flock`
        guard arguments.hasNext() else {
            throw RouteError(partialPath: path, notFound: nil)
        }
        
        let name = arguments.pop()
        
        // Ran something like `flock init`
        if let command = commandGroup.children.first(where: { $0.name == name }) as? Command {
            optionRegistry.register(command)
            return (path.appending(command), optionRegistry)
        }
        
        // Ran a task
        if let tasks = try? Beak.findTasks(), tasks.contains(where: { $0.name == name }) {
            return (path.appending(ForwardCommand(name: name)), optionRegistry)
        }
        
        throw RouteError(partialPath: path, notFound: name)
    }
    
}
