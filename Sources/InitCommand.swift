import Foundation
import SwiftCLI

class InitCommand: CommandType {
  
    let commandName = "init"
    let commandSignature = ""
    let commandShortDescription = ""
    
    func execute(arguments: CommandArguments) throws {
        if flockIsInitialized() {
            throw CLIError.Error("Flock has already been initialized")
        }
      
        let flockDirectory = "deploy/flock"
        let packageFile = "deploy/flock/Package.swift"
        
        let mainFile = "deploy/flock/main.swift"
        let flockfile = "Flockfile"
        
        let productionFile = "deploy/production.swift"
        let linkedProductionFile = "deploy/flock/production.swift"
        let stagingFile = "deploy/staging.swift"
        let linkedStagingFile = "deploy/flock/staging.swift"
      
        // Ensure required files do not already exist
        for directory in [flockDirectory] { 
            if directoryExists(directory) {
                throw CLIError.Error("\(directory) must not already exist") 
            }
        }
        for file in [flockfile, productionFile, stagingFile] { 
            if fileExists(file) {
                throw CLIError.Error("\(file) must not already exist") 
            }
        }
        
        // Create files
        try createDirectoryAtPath(flockDirectory)
        try createFileAtPath(packageFile, contents: packageDefault())
        
        try createFileAtPath(mainFile, contents: flockfileDefault())
        try createSymlinkAtPath(flockfile, toPath: mainFile)
        
        try createFileAtPath(productionFile, contents: productionDefault())
        try createSymlinkAtPath(linkedProductionFile, toPath: productionFile)
        
        try createFileAtPath(stagingFile, contents: stagingDefault())
        try createSymlinkAtPath(linkedStagingFile, toPath: stagingFile)
    }
    
    // MARK: - URL helpers
    
    private func directoryExists(path: String) -> Bool {
        let directoryURL = NSURL(fileURLWithPath: path, isDirectory: true)
        return directoryURL.checkResourceIsReachableAndReturnError(nil)
    }
    
    private func fileExists(path: String) -> Bool {
        let directoryURL = NSURL(fileURLWithPath: path, isDirectory: false)
        return directoryURL.checkResourceIsReachableAndReturnError(nil)
    }
    
    private func createDirectoryAtPath(path: String) throws {
        let directoryURL = NSURL(fileURLWithPath: path, isDirectory: true)
                
        try NSFileManager().createDirectoryAtURL(directoryURL, withIntermediateDirectories: true, attributes: nil)
    }
    
    private func createFileAtPath(path: String, contents: String) throws {
        let fileURL = NSURL(fileURLWithPath: path, isDirectory: false)
        
        try contents.writeToURL(fileURL, atomically: true, encoding: NSUTF8StringEncoding)
    }
    
    private func createSymlinkAtPath(path: String, toPath: String) throws {
        let linkURL = NSURL(fileURLWithPath: path, isDirectory: false)
        let destinationURL = NSURL(fileURLWithPath: toPath, isDirectory: false)
        
        try NSFileManager().createSymbolicLinkAtURL(linkURL, withDestinationURL: destinationURL)
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
        "Flock.addConfiguration(Staging(), .Environment(\"staging\")) // Located at deploy/staging.swift",
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
    
    private func stagingDefault() -> String {
      return [
        "import Flock",
        "",
        "class Staging: Configuration {",
        "    func configure() {",
        "        // Flock.Deploy.quickly = true",
        "    }",
        "}",
        ""
      ].joinWithSeparator("\n")
    }
  
}

extension CommandType {
    func flockIsInitialized() -> Bool {
        return NSURL(fileURLWithPath: "Flockfile", isDirectory: false).checkResourceIsReachableAndReturnError(nil)
    }
}
