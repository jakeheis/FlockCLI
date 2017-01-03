//
//  Builder.swift
//  FlockCLI
//
//  Created by Jake Heiser on 10/26/16.
//
//

import Foundation
import SwiftCLI
import Spawn
import PathKit

class Builder {
    
    private static var buildProcess: Process?
    
    @discardableResult
    static func build(silent: Bool = false) -> Bool {
        let task = Process()
        task.launchPath = "/usr/bin/env"
        task.currentDirectoryPath = Path.flockDirectory.description
        task.arguments = ["swift", "build"]
        if silent {
            task.standardOutput = Pipe()
            task.standardError = Pipe()
        }
        task.launch()
        
        buildProcess = task
        
        signal(SIGINT) { (val) in
            Builder.interruptBuild()
            
            // After interrupting build, interrupt this process
            signal(SIGINT, SIG_DFL)
            raise(SIGINT)
        }
        
        task.waitUntilExit()
        
        signal(SIGINT, SIG_DFL)
        
        return task.terminationStatus == 0
    }
    
    static func update() throws {
        try clean(includeDependencies: true)
        build()
    }
    
    static func clean(includeDependencies: Bool = false) throws {
        if Path.buildDirectory.exists {
            try Path.buildDirectory.delete()
        }
        
        if includeDependencies && Path.packagesDirectory.exists {
            try Path.packagesDirectory.delete()
        }
    }
    
    static func pull() throws {
        let outputHandler: (String) -> () = { (chunk) in
            print(chunk, terminator: "")
        }
        
        for package in try Path.packagesDirectory.children() {
            let pullProcess = try Spawn(args: ["/usr/bin/env", "git", "-C", package.description, "pull"], output: outputHandler)
            
            let status = pullProcess.waitForExit()
            if status != 0 {
                throw CLIError.error("Git pull failed for package \(package)")
            }
        }
    }
    
    // MARK: - Private
    
    private static func interruptBuild() {
        buildProcess?.interrupt()
    }
    
}
