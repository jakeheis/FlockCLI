import Foundation
import SwiftCLI

class ForwardCommand: Command {
  
    let name = ""
    let signature = "[<optional>] ..."
    let shortDescription = ""
    
    func execute(arguments: CommandArguments) throws {
      if !FileHelpers.flockIsInitialized() {
          throw CLIError.error("Flock has not been initialized in this directory yet - run `flock init`")
      }
      
      if !FileHelpers.fileExists(Paths.launchPath) {
          let result = Builder.build()
          if result == false {
              throw CLIError.error("Error: Flock must be successfully built before tasks can be run".red)
          }
      }
            
      let task = Process()
      task.launchPath = Paths.launchPath
      task.arguments = arguments.optionalCollectedArgument("optional") ?? []
      task.launch()
      task.waitUntilExit()
    }
  
}
