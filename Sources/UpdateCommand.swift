import Foundation
import SwiftCLI

class UpdateCommand: CommandType {

    let commandName = "update"
    let commandSignature = ""
    let commandShortDescription = ""

    func execute(arguments: CommandArguments) throws {
        guard let packagesURL = NSURL(string: "deploy/flock/Packages") else {
            throw CLIError.Error("URL error")
        }
      
        let packages = try NSFileManager().contentsOfDirectoryAtURL(packagesURL, includingPropertiesForKeys: nil, options: [])
        for package in packages {
            guard let path = package.path else {
                continue
            }
          
            let task = NSTask()
            task.launchPath = "/usr/local/bin/git"
            task.arguments = ["pull"]
            task.currentDirectoryPath = path
            task.launch()
            task.waitUntilExit()
        }
    }
  
}