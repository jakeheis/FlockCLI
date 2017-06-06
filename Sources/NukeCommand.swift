//
//  NukeCommand.swift
//  FlockCLI
//
//  Created by Jake Heiser on 6/5/17.
//

import SwiftCLI
import PathKit

class NukeCommand: Command {
    
    let name = "--nuke"
    let shortDescription = "Deletes Flock files in the current project"
    
    func execute() throws {
        if Input.awaitYesNoInput(message: "Are you sure you want to remove all Flock files from this project?") {
            try Path.flockDirectory.delete()
            try Path.flockfile.delete()
            try Path.deployDirectory.delete()
        }
    }
    
}
