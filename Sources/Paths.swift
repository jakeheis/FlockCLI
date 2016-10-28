//
//  Paths.swift
//  FlockCLI
//
//  Created by Jake Heiser on 10/26/16.
//
//

import FileKit

extension Path {
    static let deployDirectory = Path("deploy")
    static let flockDirectory = deployDirectory + ".flock"
    static let packagesDirectory = flockDirectory + "Packages"
    static let buildDirectory = flockDirectory + ".build"
    
    static let packageFile = flockDirectory + "Package.swift"
    static let dependenciesFile = deployDirectory + "FlockDependencies.json"
    static let mainFile = flockDirectory + "main.swift"
    static let flockfile = Path("Flockfile")
    
    static let executable = buildDirectory + "debug/flockfile"
}

func createDirectory(at path: Path) throws {
    print("Creating \(path.rawValue)".cyan)
    try path.createDirectory()
}

func write(contents: String, to path: Path) throws {
    print("Writing \(path.rawValue)".cyan)
    try contents.write(to: path)
}

func createLink(at new: Path, pointingTo existing: Path, logPath: Path) throws {
    print("Linking \(logPath.rawValue) to \(new.rawValue)".cyan)
    try existing.symlinkFile(to: new)
}

func createEnvironment(with creator: EnvironmentCreator) throws {
    print("Creating environment `\(creator.env)`".cyan)
    try creator.create()
}
