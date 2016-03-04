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
      
        // Ensure required files do not already exist
        for directory in [Paths.flockDirectory] { 
            if directoryExists(directory) {
                throw CLIError.Error("\(directory) must not already exist") 
            }
        }
        for file in [Paths.flockfile, Paths.productionFile, Paths.stagingFile, Paths.packageFile] { 
            if fileExists(file) {
                throw CLIError.Error("\(file) must not already exist") 
            }
        }
        
        // Create files
        try createDirectoryAtPath(Paths.flockDirectory)
        
        try createFileAtPath(Paths.packageFile, contents: packageDefault())
        try createSymlinkAtPath(Paths.packageFileLink, toPath: Paths.packageFile)
        
        try createFileAtPath(Paths.mainFile, contents: flockfileDefault())
        try createSymlinkAtPath(Paths.flockfile, toPath: Paths.mainFile)
        
        try createFileAtPath(Paths.productionFile, contents: productionDefault())
        try createSymlinkAtPath(Paths.productionFileLink, toPath: Paths.productionFile)
        
        try createFileAtPath(Paths.stagingFile, contents: stagingDefault())
        try createSymlinkAtPath(Paths.stagingFileLink, toPath: Paths.stagingFile)
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
        "  name: \"Flockfile\", // Don't change this!",
        "  dependencies: [",
        "    .Package(url: \"/Users/jakeheiser/Documents/Swift/Flock\", majorVersion: 0, minor: 0)",
        "  ]",
        ")",
        ""
      ].joinWithSeparator("\n")
    }
  
    private func flockfileDefault() -> String {
      return [
        "import Flock",
        "",
        "Flock.use(Flock.Deploy)",
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
