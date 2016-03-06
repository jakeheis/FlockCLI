import Foundation
import SwiftCLI

class BuildCommand: OptionCommandType {
  
    let commandName = "build"
    let commandSignature = ""
    let commandShortDescription = ""
    
    var shouldUpdate = false
    var shouldClean = false
    
    func setupOptions(options: Options) {
        options.onFlags(["-u", "--update"]) {(flag) in
            self.shouldUpdate = true
        }
        options.onFlags(["-c", "--clean"]) {(flag) in
            self.shouldClean = true
        }
    }
    
    func execute(arguments: CommandArguments) throws {
      if !flockIsInitialized() {
          throw CLIError.Error("Flock has not been initialized in this directory yet - run `flock init`")
      }
      
      if shouldUpdate {
          try update()
      }
      
      if shouldClean {
          clean()
      }
      
      let task = NSTask()
      task.launchPath = "/usr/bin/env"
      task.currentDirectoryPath = Paths.flockDirectory
      task.arguments = ["swift", "build"]
      task.launch()
      task.waitUntilExit()
    }
    
    func update() throws {
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
        
        if shouldClean == false && anyUpdated == true {
            shouldClean = true
        }
    }
    
    func clean() {
        let task = NSTask()
        task.launchPath = "/bin/rm"
        task.arguments = ["-r", ".build"]
        task.currentDirectoryPath = Paths.flockDirectory
        task.launch()
        task.waitUntilExit()
    }
  
}