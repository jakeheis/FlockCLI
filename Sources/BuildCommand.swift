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
    let shortDescription = ""
    
    func execute(arguments: CommandArguments) throws {
        try guardFlockIsInitialized()
        
        Builder.build()
    }
    
}

class CleanCommand: FlockCommand {
    let name = "--clean"
    let signature = ""
    let shortDescription = ""
    
    func execute(arguments: CommandArguments) throws {
        try guardFlockIsInitialized()
        
        try Builder.clean()
    }
    
}

class PullCommand: FlockCommand {
    let name = "--pull"
    let signature = ""
    let shortDescription = ""
    
    func execute(arguments: CommandArguments) throws {
        try guardFlockIsInitialized()
        
        try Builder.pull()
    }
    
}


class UpdateCommand: FlockCommand {
    let name = "--update"
    let signature = ""
    let shortDescription = ""
    
    func execute(arguments: CommandArguments) throws {
        try guardFlockIsInitialized()
        
        try Builder.update()
    }
    
}
