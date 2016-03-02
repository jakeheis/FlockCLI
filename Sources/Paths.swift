struct Paths {
    static let flockDirectory = "deploy/.flock"
    
    static let packageFile = "deploy/FlockPackage.swift"
    static let packageFileLink = "\(flockDirectory)/Package.swift"
    
    static let mainFile = "\(flockDirectory)/main.swift"
    static let flockfile = "Flockfile"
    
    static let productionFile = "deploy/production.swift"
    static let productionFileLink = "\(flockDirectory)/production.swift"
    
    static let stagingFile = "deploy/staging.swift"
    static let stagingFileLink = "\(flockDirectory)/staging.swift"
}