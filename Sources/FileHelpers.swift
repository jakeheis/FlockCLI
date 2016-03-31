import Foundation

class FileHelpers {
    
    static func flockIsInitialized() -> Bool {
        return NSURL(fileURLWithPath: "Flockfile", isDirectory: false).checkResourceIsReachableAndReturnError(nil)
    }
    
    static func directoryExists(path: String) -> Bool {
        let directoryURL = NSURL(fileURLWithPath: path, isDirectory: true)
        return directoryURL.checkResourceIsReachableAndReturnError(nil)
    }
    
    static func fileExists(path: String) -> Bool {
        let directoryURL = NSURL(fileURLWithPath: path, isDirectory: false)
        return directoryURL.checkResourceIsReachableAndReturnError(nil)
    }
    
    static func createDirectoryAtPath(path: String) throws {
        let directoryURL = NSURL(fileURLWithPath: path, isDirectory: true)
                
        try NSFileManager().createDirectoryAtURL(directoryURL, withIntermediateDirectories: true, attributes: nil)
    }
    
    static func createFileAtPath(path: String, contents: String) throws {
        let fileURL = NSURL(fileURLWithPath: path, isDirectory: false)
        
        try contents.writeToURL(fileURL, atomically: true, encoding: NSUTF8StringEncoding)
    }
    
    static func createSymlinkAtPath(path: String, toPath: String) throws {
        let linkURL = NSURL(fileURLWithPath: path, isDirectory: false)
        let destinationURL = NSURL(fileURLWithPath: toPath, isDirectory: false)
        
        try NSFileManager().createSymbolicLinkAtURL(linkURL, withDestinationURL: destinationURL)
    }
    
}
