import Foundation
import SwiftCLI

class InitCommand: CommandType {
  
    let commandName = "init"
    let commandSignature = ""
    let commandShortDescription = ""
    
    func execute(arguments: CommandArguments) throws {
      let deployURL = NSURL(fileURLWithPath: "deploy", isDirectory: true)
      
      // Create deploy/flock
      let flockURL = deployURL.URLByAppendingPathComponent("flock")
      guard !flockURL.checkResourceIsReachableAndReturnError(nil) else {
        throw CLIError.Error("deploy/flock must not already exist")
      } 
      try NSFileManager().createDirectoryAtURL(flockURL, withIntermediateDirectories: true, attributes: nil)
      
      // Create deploy/flock/Package.swift
      let packageURL = flockURL.URLByAppendingPathComponent("Package.swift")
      try packageDefault().writeToURL(packageURL, atomically: true, encoding: NSUTF8StringEncoding)
      
      // Create Flockfile.swift
      let flockfileURL = NSURL(fileURLWithPath: "Flockfile.swift", isDirectory: true)
      guard !flockfileURL.checkResourceIsReachableAndReturnError(nil) else {
        throw CLIError.Error("Flockfile.swift must not already exist")
      } 
      try flockfileDefault().writeToURL(flockfileURL, atomically: true, encoding: NSUTF8StringEncoding)
      
      // Symlink Flockfile.swift to deploy/flock/main.swift
      let mainFlockURL = flockURL.URLByAppendingPathComponent("main.swift")
      try NSFileManager().createSymbolicLinkAtURL(mainFlockURL, withDestinationURL: flockfileURL)
    }
    
    // MARK: - Defaults
    
    private func packageDefault() -> String {
      return [
        "import PackageDescription",
        "",
        "let package = Package(",
        "  name: \"Flockfile\",",
        "  dependencies: [",
        "    .Package(url: \"/Users/jakeheiser/Documents/Swift/Flock\", majorVersion: 0, minor: 0),",
        "  ]",
        ")",
        ""
      ].joinWithSeparator("\n")
    }
  
    private func flockfileDefault() -> String {
      return [
      "import Flock",
      "",
      "Flock.run()",
      ""
      ].joinWithSeparator("\n")
    }
  
}