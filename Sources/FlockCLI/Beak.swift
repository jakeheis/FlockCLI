//
//  Beak.swift
//  FlockPackageDescription
//
//  Created by Jake Heiser on 3/28/18.
//

import BeakCore
import PathKit
import SwiftCLI

struct Beak {
    
    private static let cachePath = Path("/tmp/flock/builds")
    
    static func execute(args: [String]) throws {
        let options = BeakOptions(cachePath: cachePath)
        let beak = BeakCore.Beak(options: options)
        do {
            try beak.execute(arguments: args)
        } catch let error {
            throw CLI.Error(message: "Error: ".red.bold + error.localizedDescription + " (Beak failure)")
        }
    }
    
    static func cleanBuilds(for file: Path) throws {
        let directory = file.absolute().parent()
        let packagePath = cachePath + directory.string.replacingOccurrences(of: "/", with: "_")
        try packagePath.delete()
    }
    
    private init() {}
    
}
