import SwiftCLI

class BuildCommand: OptionCommand {
    
    let name = "--build"
    let signature = ""
    let shortDescription = ""
    
    var shouldUpdate = false
    var shouldClean = false
    
    func setupOptions(options: OptionRegistry) {
        options.add(flags: ["-u", "--update"]) {
            self.shouldUpdate = true
        }
        options.add(flags: ["-c", "--clean"]) {
            self.shouldClean = true
        }
    }
    
    func execute(arguments: CommandArguments) throws {
        if !FileHelpers.flockIsInitialized() {
            throw CLIError.error("Flock has not been initialized in this directory yet - run `flock init`")
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
