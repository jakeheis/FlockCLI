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

extension Path {
    
    func createLink(pointingTo path: Path) throws { // Clearer (at least to me)
        try path.symlinkFile(to: self)
    }
    
}
