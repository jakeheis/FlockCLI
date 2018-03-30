//
//  FlockCommand.swift
//  FlockCLI
//
//  Created by Jake Heiser on 10/26/16.
//
//

import PathKit
import Rainbow
import SwiftCLI

protocol FlockCommand: Command {}

extension FlockCommand {
    
    var flockPath: Path {
        return Path("Flock.swift")
    }
    
    var flockIsInitialized: Bool {
        return flockPath.exists
    }
    
    func guardFlockIsInitialized() throws {
        if !flockIsInitialized {
            throw CLI.Error(message: "Error: ".red.bold + "Flock has not been initialized in this directory yet - run `flock --init`")
        }
    }
    
}
