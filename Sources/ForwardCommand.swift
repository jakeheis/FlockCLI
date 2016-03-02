import Foundation
import SwiftCLI

class ForwardCommand: CommandType {
  
    let commandName = ""
    let commandSignature = "[<optional>] ..."
    let commandShortDescription = ""
    
    func execute(arguments: CommandArguments) throws {
      if !flockIsInitialized() {
          throw CLIError.Error("Flock has not been initialized in this directory yet - run `flock init`")
      }
            
      let task = NSTask()
      task.launchPath = "\(Paths.flockDirectory)/.build/debug/flockfile"
      task.arguments = arguments.optionalCollectedArgument("optional")
      task.launch()
      task.waitUntilExit()
    }
  
}