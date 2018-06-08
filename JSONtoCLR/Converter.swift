//
//  Converter.swift
//  JSONtoCLR
//
//  Created by Christoph Labacher on 08.06.18.
//  Copyright © 2018 Christoph Labacher. All rights reserved.
//

import Cocoa

class Converter {
    let consoleIO = ConsoleIO()
    
    func run() {
        if CommandLine.argc < 2 {
            consoleIO.printUsage()
        } else {
            let cwd = FileManager.default.currentDirectoryPath
            let urlCwd = URL(fileURLWithPath: cwd)
            let input = CommandLine.arguments[1];
            var inputPath: String
            
            if input.hasPrefix("/") {
                inputPath = input
            } else {
                if let path = URL(string: input, relativeTo: urlCwd)?.path {
                    inputPath = path
                } else {
                    consoleIO.writeMessage("Invalid path", to: .error)
                    exit(EXIT_FAILURE)
                }
            }
            
            let filename = URL(fileURLWithPath: inputPath).deletingPathExtension().lastPathComponent
            let outputUrl = URL(fileURLWithPath: "\(filename).clr", relativeTo: urlCwd)
            
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: inputPath), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                
                if let jsonResult = jsonResult as? Dictionary<String, String> {
                    convert(jsonResult, to: outputUrl, name: filename)
                } else {
                    consoleIO.writeMessage("JSON not valid", to: .error)
                    exit(EXIT_FAILURE)
                }
            } catch {
                consoleIO.writeMessage("Can’t read file", to: .error)
                exit(EXIT_FAILURE)
            }
        }
    }
    
    func convert(_ input: Dictionary<String, String>, to: URL, name: String) {
        let list = NSColorList(name: .init(name))
        
        input.forEach { (key, value) in
            let color = NSColor(hex: value)
            list.insertColor(color, key: .init(key), at: 0)
        }
        
        do {
            try list.write(to: to)
            exit(EXIT_SUCCESS)
        } catch {
            consoleIO.writeMessage("Couldn’t write file", to: .error)
            exit(EXIT_FAILURE)
        }
    }
}
