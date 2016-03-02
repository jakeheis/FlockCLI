import Foundation
import SwiftCLI

class BuildCommand: CommandType {
  
    let commandName = "build"
    let commandSignature = ""
    let commandShortDescription = ""
    
    func execute(arguments: CommandArguments) throws {
      if !flockIsInitialized() {
          throw CLIError.Error("Flock has not been initialized in this directory yet - run `flock init`")
      }
      
      let task = NSTask()
      task.launchPath = "/usr/bin/env"
      task.currentDirectoryPath = Paths.flockDirectory
      task.arguments = ["swift", "build"]
      task.launch()
      task.waitUntilExit()
    }
  
}