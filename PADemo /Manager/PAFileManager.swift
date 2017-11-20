//
//  PAFileManager.swift
//  PADemo
//
//  Created by shuo on 2017/7/13.
//  Copyright © 2017年 shuo. All rights reserved.
//

import Foundation


public class PAFileChangeRecord {
    public let kDocuments = "Documents"
    public static let fileRecord = PAFileChangeRecord()
    
    public func getLocalReadWriteFilePath() -> String {
        let manager = FileManager.default
        let directory = "\(kDocuments)"
        let path = PAFileManager.fileManager.getFileFullPathUnderDirectory(directory)
        if !manager.fileExists(atPath: path) {
            manager.createFile(atPath: path, contents: nil, attributes: nil)
        }
        return path
    }
}

public class PAFileManager {
    
    public static let fileManager = PAFileManager()
    
    public func getDocumentPath() -> String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    }
    
    public func getTmpPath() -> String {
        return NSTemporaryDirectory()
    }
    
    public func getFileFullPathUnderDirectory(_ directory: String, fileName: String? = nil) -> String {
        if let fileName = fileName {
            let path = (NSHomeDirectory() as NSString).appendingPathComponent("\(directory)/\(fileName)")
            return path
        } else {
            let path = (NSHomeDirectory() as NSString).appendingPathComponent("\(directory)")
            return path
        }
    }
    
    public func getFileFullPathUnderDocument(_ fileName: String) -> String {
        let docPath = getDocumentPath() as NSString
        return docPath.appendingPathComponent(fileName)
    }
    
    public func getFileFullPathUnderTemp(_ fileName: String) -> String {
        let docPath = getTmpPath() as NSString
        return docPath.appendingPathComponent(fileName)
    }
    
    public func saveDataToSandbox<T: NSCoding>(_ data: T, directory: String, fileName: String, key: String) -> (Bool, String?) {
        let mData = NSMutableData()
        let archive = NSKeyedArchiver.init(forWritingWith: mData)
        archive.encode(data, forKey: key)
        archive.finishEncoding()
        
        let fileManager = FileManager.default
        var errorMessage: String? = nil
        func creatDictionaryAtPath(_ path: String) {
            if fileManager.fileExists(atPath: path) {
                // 先检查对应的路径已存在该文件夹
                return
            }
            do {
                // 在documnet下创建一个文件夹
                try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            } catch let error as NSError {
                errorMessage = error.localizedDescription
            }
        }
        objc_sync_enter(self)
        creatDictionaryAtPath(getFileFullPathUnderDirectory(directory))
        
        let filePath = getFileFullPathUnderDirectory(directory, fileName: fileName)
        print("filePath = \(filePath)")
        let result = fileManager.createFile(atPath: filePath, contents: mData as Data, attributes: nil)
        objc_sync_exit(self)
        return (result, errorMessage)
    }
    
    public func getDataFromSandbox<T: NSCoding>(_ fileName: String, directory: String, key: String) -> T? {
        
        let filePath = getFileFullPathUnderDirectory(directory, fileName: fileName)
        
        let data = try? Data.init(contentsOf: URL(fileURLWithPath: filePath))
        if data != nil && (data as NSData?)?.bytes.hashValue != nil && ((data as NSData?)?.bytes.hashValue)! > 0 {
            let unArchive = NSKeyedUnarchiver.init(forReadingWith: data!)
            let data = unArchive.decodeObject(forKey: key) as? T
            unArchive.finishDecoding()
            return data
        }
        return nil
    }

}
