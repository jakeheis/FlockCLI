import Foundation
import SwiftCLI

class CleanCommand: CommandType {
  
      let commandName = "clean"
      let commandSignature = ""
      let commandShortDescription = ""

      func execute(arguments: CommandArguments) throws {
          let task = NSTask()
          task.launchPath = "/bin/rm"
          task.arguments = ["-r", ".build"]
          task.currentDirectoryPath = Paths.flockDirectory
          task.launch()
          task.waitUntilExit()
      }
    
}