//
//  FlockCommand.swift
//  FlockCLI
//
//  Created by Jake Heiser on 10/26/16.
//
//

import SwiftCLI
import FileKit

protocol FlockCommand: Command {}

extension FlockCommand {
    
    var flockIsInitialized: Bool {
        return Path.flockDirectory.exists
    }
    
    func guardFlockIsInitialized() throws {
        if !flockIsInitialized {
            throw CLIError.error("Flock has not been initialized in this directory yet - run `flock init`")
        }
    }
    
}
