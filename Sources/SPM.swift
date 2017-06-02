//
//  SPM.swift
//  FlockCLI
//
//  Created by Jake Heiser on 10/26/16.
//
//

import Foundation
import SwiftCLI
import Spawn
import PathKit
import Rainbow

class SPM {
    
    enum Error: Swift.Error {
        case processFailed
    }
    
    static func build(silent: Bool = false) throws {
        if let dependenciesModification = (try? FileManager.default.attributesOfItem(atPath: Path.dependenciesFile.description))?[FileAttributeKey.modificationDate] as? Date,
            let lastBuilt = (try? FileManager.default.attributesOfItem(atPath: Path.packagesDirectory.description))?[FileAttributeKey.modificationDate] as? Date,
            dependenciesModification > lastBuilt {
            
            print("FlockDependencies.json changed -- rebuilding dependencies".yellow)
            try reset()
        }
        
        try executeSPM(arguments: ["build"], silent: silent)
    }
    
    static func update() throws {
        try executeSPM(arguments: ["package", "update"], silent: false)
        try build()
    }
    
    static func clean() throws {
        try executeSPM(arguments: ["package", "clean"], silent: false)
    }
    
    static func reset() throws {
        try executeSPM(arguments: ["package", "reset"], silent: false)
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
    
    private static var buildProcess: Process?
    
    private static func executeSPM(arguments: [String], silent: Bool) throws {
        let task = Process()
        task.launchPath = "/usr/bin/env"
        task.currentDirectoryPath = Path.flockDirectory.description
        task.arguments = ["swift"] + arguments
        if silent {
            task.standardOutput = Pipe()
            task.standardError = Pipe()
        }
        task.launch()
        
        buildProcess = task
        
        signal(SIGINT) { (val) in
            SPM.interruptBuild()
            
            // After interrupting build, interrupt this process
            signal(SIGINT, SIG_DFL)
            raise(SIGINT)
        }
        
        task.waitUntilExit()
        
        signal(SIGINT, SIG_DFL)
        
        guard task.terminationStatus == 0 else {
            throw Error.processFailed
        }
    }
    
    private static func interruptBuild() {
        buildProcess?.interrupt()
    }
    
}
