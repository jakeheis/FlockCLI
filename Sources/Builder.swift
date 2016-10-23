import Foundation
import SwiftCLI

class Builder {
    
    @discardableResult
    static func build() -> Bool {
        let task = Process()
        task.launchPath = "/usr/bin/env"
        task.currentDirectoryPath = Paths.flockDirectory
        task.arguments = ["swift", "build"]
        task.launch()
        task.waitUntilExit()
        
        return task.terminationStatus == 0
    }
    
    static func update() throws -> Bool {
        guard let packagesURL = URL(string: "\(Paths.flockDirectory)/Packages") else {
            throw CLIError.error("URL error")
        }
        
        var anyUpdated = false
        
        let packages = try FileManager.default.contentsOfDirectory(at: packagesURL, includingPropertiesForKeys: nil, options: [])
        for package in packages {
            let path = package.path
          
            let task = Process()
            task.launchPath = "/usr/local/bin/git"
            task.arguments = ["pull"]
            task.currentDirectoryPath = path
            
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
    
    static func clean() {
        let task = Process()
        task.launchPath = "/bin/rm"
        task.arguments = ["-r", ".build"]
        task.currentDirectoryPath = Paths.flockDirectory
        task.launch()
        task.waitUntilExit()
    }
    
}
