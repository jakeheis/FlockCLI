import Foundation
import SwiftCLI

class BuildCommand: CommandType {
  
    let commandName = "build"
    let commandSignature = ""
    let commandShortDescription = ""
    
    func execute(arguments: CommandArguments) throws {
      let outputPipe = NSPipe()
      
      let swiftPathTask = NSTask()
      swiftPathTask.launchPath = "/usr/bin/which"
      swiftPathTask.arguments = ["swift"]
      swiftPathTask.standardOutput = outputPipe
      swiftPathTask.launch()
      swiftPathTask.waitUntilExit()
      
      let data = outputPipe.fileHandleForReading.readDataToEndOfFile()
      
      guard let swiftPath = String(data: data, encoding: NSUTF8StringEncoding)?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) else {
          throw CLIError.Error("Swift could not be found on your system - please make sure it is installed on your $PATH")
      }
      
      let task = NSTask()
      task.launchPath = swiftPath
      task.currentDirectoryPath = "deploy/flock"
      task.arguments = ["build"]
      task.launch()
      task.waitUntilExit()
    }
  
}