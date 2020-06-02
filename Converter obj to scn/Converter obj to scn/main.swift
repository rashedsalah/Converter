//
//  main.swift
//  Converter obj to scn
//
//  Created by RS on 15.11.2019.
//  Copyright © 2020 RS. All rights reserved.
//

import Foundation

func run() {
    let arguments = CommandLine.arguments
    
    guard arguments.count == 2 else {
        print("Usage: convert [path to folder]")
        exit(-1)
    }
    
    let path = arguments[1]
    let enumerator = FileManager.default.enumerator(atPath: path)
    let filePaths = enumerator?.allObjects as! [String]
    let objFilePaths = filePaths.filter { (path) in
        return path.lowercased().contains(".obj".lowercased())
    }
    if objFilePaths.count > 0 {
        let url = URL(fileURLWithPath: path).deletingLastPathComponent().path

        let createFolder = "cd \(url); mkdir scn_files"
        createFolder.runAsCommand()
        
        for objFilePath in objFilePaths {
            let URLPathOBJ = "\(path)/\(objFilePath)"
            let URLPathSCNFolder = "\(url)/scn_files"
            let nameSCNFile = objFilePath as NSString
            
            let convert = "xcrun scntool --convert \(URLPathOBJ) --format scn --output \(URLPathSCNFolder)/\(nameSCNFile.deletingPathExtension).scn"
            convert.runAsCommand()
        }
    }
}

extension String {
    
    func runAsCommand() {
        let pipe = Pipe()
        let task = Process()
        task.launchPath = "/bin/sh"
        task.arguments = ["-c", String(format:"%@", self)]
        task.standardOutput = pipe
        _ = pipe.fileHandleForReading
        task.launch()
    }
    
}

run()
