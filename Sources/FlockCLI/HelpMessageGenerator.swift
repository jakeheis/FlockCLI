//
//  HelpMessageGenerator.swift
//  FlockCLI
//
//  Created by Jake Heiser on 3/30/18.
//

import SwiftCLI

class HelpMessageGenerator: SwiftCLI.HelpMessageGenerator {
    
    func generateCommandList(for path: CommandGroupPath) -> String {
        var str = DefaultHelpMessageGenerator().generateCommandList(for: path)
        if let tasks = try? Beak.generateTaskList() {
            str += "\nTasks:\n\(tasks)\n"
        }
        return str
    }
    
}
