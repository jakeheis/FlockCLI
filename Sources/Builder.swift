//
//  Builder.swift
//  FlockCLI
//
//  Created by Jake Heiser on 10/26/16.
//
//

import SwiftCLI
import FileKit
import Spawn
import Foundation

class Builder {
    
    private static var buildProcess: Process?
    
    @discardableResult
    static func build(silent: Bool = false) -> Bool {
        let task = Process() // TODO: Spawn doesn't work here for some reason, fall back to using Process
        task.launchPath = "/usr/bin/env"
        task.currentDirectoryPath = Path.flockDirectory.rawValue
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
            try Path.buildDirectory.deleteFile()
        }
        
        if includeDependencies && Path.packagesDirectory.exists {
            try Path.packagesDirectory.deleteFile()
        }
    }
    
    static func pull() throws {
        let outputHandler: (String) -> () = { (chunk) in
            print(chunk, terminator: "")
        }
        
        for package in Path.packagesDirectory.children() {
            let pullProcess = try Spawn(args: ["/usr/bin/env", "git", "-C", package.rawValue, "pull"], output: outputHandler)
            
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
