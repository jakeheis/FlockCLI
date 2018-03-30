//
//  CleanCommand.swift
//  FlockCLI
//
//  Created by Jake Heiser on 3/29/18.
//

import Foundation

class CleanCommand: FlockCommand {
    
    let name = "clean"
    
    func execute() throws {
        try Beak.cleanBuilds(for: flockPath)
    }
    
}
