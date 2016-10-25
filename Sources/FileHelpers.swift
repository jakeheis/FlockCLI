import Foundation

class FileHelpers {
    
    static func flockIsInitialized() -> Bool {
        return (try? URL(fileURLWithPath: "Flockfile", isDirectory: false).checkResourceIsReachable()) ?? false
    }
    
    static func directoryExists(_ path: String) -> Bool {
        let directoryURL = URL(fileURLWithPath: path, isDirectory: true)
        return (try? directoryURL.checkResourceIsReachable()) ?? false
    }
    
    static func fileExists(_ path: String) -> Bool {
        let fileURL = URL(fileURLWithPath: path, isDirectory: false)
        return (try? fileURL.checkResourceIsReachable()) ?? false
    }
    
    static func createDirectory(at path: String) throws {
        let directoryURL = URL(fileURLWithPath: path, isDirectory: true)
                
        try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
    }
    
    static func createFile(at path: String, contents: String) throws {
        let fileURL = URL(fileURLWithPath: path, isDirectory: false)
        
        try contents.write(to: fileURL, atomically: true, encoding: .utf8)
    }
    
    static func createFile(at path: String, contents: Data) throws {
        let fileURL = URL(fileURLWithPath: path, isDirectory: false)
        
        try contents.write(to: fileURL, options: [.atomic])
    }
    
    static func createSymlink(at path: String, toPath: String) throws {
        let linkURL = URL(fileURLWithPath: path, isDirectory: false)
        let destinationURL = URL(fileURLWithPath: toPath, isDirectory: false)
        
        try FileManager.default.createSymbolicLink(at: linkURL, withDestinationURL: destinationURL)
    }
    
}
