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
      if !FileHelpers.flockIsInitialized() {
          throw CLIError.Error("Flock has not been initialized in this directory yet - run `flock init`")
      }
      
      if shouldUpdate {
          let updatedAny = try Builder.update()
          if updatedAny {
              shouldClean = true
          }
      }
      
      if shouldClean {
          Builder.clean()
      }
      
      Builder.build()
    }
  
}