import Foundation
import SwiftCLI

class Builder {
    
    static func build() -> Bool {
        let task = NSTask()
        task.launchPath = "/usr/bin/env"
        task.currentDirectoryPath = Paths.flockDirectory
        task.arguments = ["swift", "build"]
        task.launch()
        task.waitUntilExit()
        
        return task.terminationStatus == 0
    }
    
    static func update() throws -> Bool {
        guard let packagesURL = NSURL(string: "\(Paths.flockDirectory)/Packages") else {
            throw CLIError.Error("URL error")
        }
        
        var anyUpdated = false
        
        let packages = try NSFileManager().contentsOfDirectoryAtURL(packagesURL, includingPropertiesForKeys: nil, options: [])
        for package in packages {
            guard let path = package.path else {
                continue
            }
          
            let task = NSTask()
            task.launchPath = "/usr/local/bin/git"
            task.arguments = ["pull"]
            task.currentDirectoryPath = path
            
            let output = NSPipe()
            task.standardOutput = output
            
            task.launch()
            task.waitUntilExit()
            
            let data = output.fileHandleForReading.readDataToEndOfFile()
            let string = String(data: data, encoding: NSUTF8StringEncoding)
            
            if let string = string where !string.hasPrefix("Already up-to-date") {
                anyUpdated = true
            }
        }
        
        return anyUpdated
    }
    
    static func clean() {
        let task = NSTask()
        task.launchPath = "/bin/rm"
        task.arguments = ["-r", ".build"]
        task.currentDirectoryPath = Paths.flockDirectory
        task.launch()
        task.waitUntilExit()
    }
    
}