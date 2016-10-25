struct Paths {
    static let flockDirectory = "deploy/.flock"
    
    static let packageFile = "\(flockDirectory)/Package.swift"
    static let dependenciesFile = "deploy/FlockDependencies.json"
    
    static let mainFile = "\(flockDirectory)/main.swift"
    static let flockfile = "Flockfile"
    
    static let launchPath = "\(flockDirectory)/.build/debug/flockfile"
}
