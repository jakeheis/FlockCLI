//
//  Paths.swift
//  FlockCLI
//
//  Created by Jake Heiser on 10/26/16.
//
//

import PathKit

extension Path {
    static let deployDirectory = Path("config/deploy")
    static let flockDirectory = Path(".flock")
    static let packagesDirectory = flockDirectory + "Packages"
    static let buildDirectory = flockDirectory + ".build"
    
    static let packageFile = flockDirectory + "Package.swift"
    static let dependenciesFile = deployDirectory + "FlockDependencies.json"
    static let mainFile = flockDirectory + "main.swift"
    static let flockfile = Path("Flockfile")
    
    static let executable = buildDirectory + "debug/flockfile"
}

func createDirectory(at path: Path) throws {
    print("Creating \(path)".cyan)
    try path.mkpath()
}

func write(contents: String, to path: Path) throws {
    print("Writing \(path)".cyan)
    try path.write(contents)
}

func createLink(at new: Path, pointingTo existing: Path, logPath: Path) throws {
    print("Linking \(logPath) to \(new)".cyan)
    try new.symlink(existing)
}

func createEnvironment(with creator: EnvironmentCreator) throws {
    print("Creating environment `\(creator.env)`".cyan)
    try creator.create()
}
