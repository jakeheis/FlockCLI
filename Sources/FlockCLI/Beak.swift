//
//  Beak.swift
//  FlockPackageDescription
//
//  Created by Jake Heiser on 3/28/18.
//

import BeakCore
import PathKit
import SwiftCLI

struct Beak {
    
    static let flockPath = Path("Flock.swift")
    private static let cachePath = Path("/tmp/flock/builds")
    
    static func execute(args: [String]) throws {
        let options = BeakOptions(cachePath: cachePath)
        let beak = BeakCore.Beak(options: options)
        do {
            try beak.execute(arguments: args)
        } catch let error {
            throw FlockError(message: String(describing: error) + " (Beak failure)")
        }
    }
    
    static func cleanBuilds() throws {
        let directory = flockPath.absolute().parent()
        let packagePath = cachePath + directory.string.replacingOccurrences(of: "/", with: "_")
        try packagePath.delete()
    }
    
    static func findTasks() throws -> [Function] {
        let beak = try BeakFile(path: flockPath)
        return beak.functions
    }
    
    static func generateTaskList() throws -> String {
        let tasks = try findTasks()
        
        let spacingLength = tasks.reduce(into: 12, { (length, task) in
            length = max(task.name.count + 4, length)
        })
        
        return tasks.map({ (task) -> String in
            let spacing = String(repeating: " ", count: spacingLength - task.name.count)
            var line = "  \(task.name)"
            if let docsDescription = task.docsDescription {
                line += "\(spacing)\(docsDescription)"
            }
            return line
        }).joined(separator: "\n")
    }
    
    private init() {}
    
}
