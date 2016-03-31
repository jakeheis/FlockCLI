import Foundation
import SwiftCLI

class ForwardCommand: CommandType {
  
    let commandName = ""
    let commandSignature = "[<optional>] ..."
    let commandShortDescription = ""
    
    func execute(arguments: CommandArguments) throws {
      if !FileHelpers.flockIsInitialized() {
          throw CLIError.Error("Flock has not been initialized in this directory yet - run `flock init`")
      }
      
      if !FileHelpers.fileExists(Paths.launchPath) {
          let result = Builder.build()
          if result == false {
              throw CLIError.Error("Error: Flock must be successfully built before tasks can be run".red)
          }
      }
            
      let task = NSTask()
      task.launchPath = Paths.launchPath
      task.arguments = arguments.optionalCollectedArgument("optional")
      task.launch()
      task.waitUntilExit()
    }
  
}