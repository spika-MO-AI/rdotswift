
import Foundation

// MARK: - Settings item

private let rdotswiftFileName = "R.swift"

private let rdotswiftResourceClass = "ResourceCenter";

private let rdotswiftGlobalInstanceName = "R"

private let rdotswiftResourceSearchPath = "/" // default current root path

// MARK: - RdotSwift

private final class RdotSwift {
    
    // MARK: Settings property
    
    //    private let fileName: String
    
    private let globalInstanceName: String
    
    // MARK: Private property
    
    private let fileManager = NSFileManager()
    
    private let imageExtensions: [String] = [".tiff",".tif",".jpg",".jpeg",".gif",".png", ".bmp", ".BMPf", ".ico", ".cur", ".xbm", ".pdf"]
    
    private let imageIgnoreMark: [String] = ["@2x", "@3x"]
    
    private let variableNameForbiddenWords: [String] = ["+", "-", "*", "/", "@", " ", "."]
    
    private var imageVariableNames: [String] = []
    
    // MARK: Initialize

    private init (fileName: String, resourceClass: String, globalInstanceName: String, searchPath: String) {

        self.globalInstanceName = globalInstanceName
        
        var pathArray = self.retrievePathArray(searchPath) as [String]
        
        var imageNames: [String] = []
        imageNames = pathArray.filter { path in
            contains(self.imageExtensions) { ext in path.hasSuffix(ext) }
        }.map { imageName in
            var ignoreWords = self.imageExtensions + self.imageIgnoreMark
            return ignoreWords.reduce(imageName) { name, ignoreWord in
                name.stringByReplacingOccurrencesOfString(ignoreWord, withString:"", options: nil, range: nil)
            }
        }
        
        imageVariableNames = imageNames.map { imageName in
            self.variableNameForbiddenWords.reduce(imageName) { name, forbiddenWord in
                name.stringByReplacingOccurrencesOfString(forbiddenWord, withString:"$", options: nil, range: nil)
            }
        }
        
        var imageMethods = "// MARK: Drawble\n\n"
        for idx in 0..<imageNames.count {
            imageMethods += "\(self.drawbleTemplete(imageNames[idx], variableName:imageVariableNames[idx]))\n\n"
        }
        var rdotswift = self.rdotswiftTemplete(resourceClass, instanceName:globalInstanceName, contents:imageMethods)
        rdotswift.writeToFile(fileName, atomically: true, encoding: NSUTF8StringEncoding, error: nil)
        
        self.attachFile(fileName)
    }
    
    // MARK: File management
    
    private func attachFile(fileName: String) {
        if !self.fileManager.fileExistsAtPath(fileName) {
            self.fileManager.createFileAtPath(
                fileName,
                contents:"".dataUsingEncoding(NSUTF8StringEncoding),
                attributes:nil)
        }
    }
    
    private func retrievePathArray(searchPath: String)->NSArray {
        let enumratePath = self.fileManager.currentDirectoryPath + searchPath
        let pathEnumerator = self.fileManager.enumeratorAtPath(enumratePath)!
        
        var pathArray = NSMutableArray()
        var path: String?
        do {
            if let p = pathEnumerator.nextObject() as String! {
                path = p
                pathArray.addObject(p.lastPathComponent)
            } else {
                path = nil
            }
        } while (path != nil)
        
        return pathArray
    }
    
    // MARK: Templete
    
    private func rdotswiftTemplete(className: String, instanceName: String, contents: String)->String {
        return
            "public final class \(className) {\n\n" +
            "\(contents)" +
            "}\n\n" +
            "let \(instanceName) = \(className)()\n"
    }
    
    private func drawbleTemplete(fileName: String, variableName: String)->String {
        return "public var \(variableName): UIImage! { get { return UIImage(named:\"\(fileName)\")! } }"
    }
}

RdotSwift(
    fileName: rdotswiftFileName,
    resourceClass: rdotswiftResourceClass,
    globalInstanceName: rdotswiftGlobalInstanceName,
    searchPath: rdotswiftResourceSearchPath)

