//
//  BuildCommand.swift
//  FlockCLI
//
//  Created by Jake Heiser on 10/26/16.
//
//

import SwiftCLI

class BuildCommand: FlockCommand {
    
    let name = "--build"
    let signature = ""
    let shortDescription = "Builds Flock in the current directory"
    
    func execute(arguments: CommandArguments) throws {
        try guardFlockIsInitialized()
        
        Builder.build()
    }
    
}

class CleanCommand: FlockCommand {
    let name = "--clean"
    let signature = ""
    let shortDescription = "Cleans Flock's build directory in the current project"
    
    func execute(arguments: CommandArguments) throws {
        try guardFlockIsInitialized()
        
        try Builder.clean()
    }
    
}

class CleanAllCommand: FlockCommand {
    let name = "--clean-all"
    let signature = ""
    let shortDescription = "Cleans Flock's build directory and Packages directory in the current project"
    
    func execute(arguments: CommandArguments) throws {
        try guardFlockIsInitialized()
        
        try Builder.clean(includeDependencies: true)
    }
    
}

class PullCommand: FlockCommand {
    let name = "--pull"
    let signature = ""
    let shortDescription = "Debug only; use --update instead"
    
    func execute(arguments: CommandArguments) throws {
        try guardFlockIsInitialized()
        
        try Builder.pull()
    }
    
}


class UpdateCommand: FlockCommand {
    let name = "--update"
    let signature = ""
    let shortDescription = "Updates Flock's dependencies in the current project"
    
    func execute(arguments: CommandArguments) throws {
        try guardFlockIsInitialized()
        
        try Builder.update()
    }
    
}
