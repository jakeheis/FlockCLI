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
    let shortDescription = "Builds Flock in the current directory"
    
    func execute() throws {
        try guardFlockIsInitialized()
        
        Builder.build()
    }
    
}

class CleanCommand: FlockCommand {
    let name = "--clean"
    let shortDescription = "Cleans Flock's build directory"
    
    func execute() throws {
        try guardFlockIsInitialized()
        
        try Builder.clean()
    }
    
}

class CleanAllCommand: FlockCommand {
    let name = "--clean-all"
    let shortDescription = "Cleans Flock's build directory and Packages directory"
    
    func execute() throws {
        try guardFlockIsInitialized()
        
        try Builder.clean(includeDependencies: true)
    }
    
}

class PullCommand: FlockCommand {
    let name = "--pull"
    let shortDescription = "Debug only; use --update instead"
    
    func execute() throws {
        try guardFlockIsInitialized()
        
        try Builder.pull()
    }
    
}


class UpdateCommand: FlockCommand {
    let name = "--update"
    let shortDescription = "Updates Flock's dependencies in the current project"
    
    func execute() throws {
        try guardFlockIsInitialized()
        
        try Builder.update()
    }
    
}
