//
//  Builder.swift
//  FlockCLI
//
//  Created by Jake Heiser on 10/26/16.
//
//

import Foundation
import SwiftCLI
import FileKit

class Builder {
    
    @discardableResult
    static func build(silent: Bool = false) -> Bool {
        let task = Process()
        task.launchPath = "/usr/bin/env"
        task.currentDirectoryPath = Path.flockDirectory.rawValue
        task.arguments = ["swift", "build"]
        if silent {
            task.standardOutput = Pipe()
            task.standardError = Pipe()
        }
        task.launch()
        task.waitUntilExit()
        
        return task.terminationStatus == 0
    }
    
    static func update() throws {
        try clean(includeDependencies: true)
        build()
    }
    
    static func clean(includeDependencies: Bool = false) throws {
        try Path.buildDirectory.deleteFile()
        
        if includeDependencies {
            try Path.packagesDirectory.deleteFile()
        }
    }
    
    @discardableResult
    static func pull() throws -> Bool {
        var anyUpdated = false
        for package in Path.packagesDirectory {
            let task = Process()
            task.launchPath = "/usr/local/bin/git"
            task.arguments = ["pull"]
            task.currentDirectoryPath = package.rawValue
            
            let output = Pipe()
            task.standardOutput = output
            
            task.launch()
            task.waitUntilExit()
            
            let data = output.fileHandleForReading.readDataToEndOfFile()
            let string = String(data: data, encoding: .utf8)
            
            if let string = string, !string.hasPrefix("Already up-to-date") {
                anyUpdated = true
            }
        }
        
        return anyUpdated
    }
    
}
