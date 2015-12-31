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
      
      // Create deploy/production.swift
      let productionURL = deployURL.URLByAppendingPathComponent("production.swift")
      guard !productionURL.checkResourceIsReachableAndReturnError(nil) else {
        throw CLIError.Error("deploy/production.swift must not already exist")
      } 
      try productionDefault().writeToURL(productionURL, atomically: true, encoding: NSUTF8StringEncoding)
      
      // Symlink deploy/production.swift to deploy/flock/production.swift
      let productionFlockURL = flockURL.URLByAppendingPathComponent("production.swift")
      try NSFileManager().createSymbolicLinkAtURL(productionFlockURL, withDestinationURL: productionURL)
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
        "Flock.use(Flock.Default)",
        "",
        "Flock.addConfiguration(Production(), .Environment(\"production\")) // Located at deploy/production.swift",
        "",
        "Flock.run()",
        ""
      ].joinWithSeparator("\n")
    }
    
    private func productionDefault() -> String {
      return [
        "import Flock",
        "",
        "class Production: Configuration {",
        "    func configure() {",
        "        // Flock.Deploy.quickly = true",
        "    }",
        "}",
        ""
      ].joinWithSeparator("\n")
    }
  
}