//
//  ConsoleIO.swift
//  JSONtoCLR
//
//  Created by Christoph Labacher on 08.06.18.
//  Copyright © 2018 Christoph Labacher. All rights reserved.
//

import Foundation

enum OutputType {
    case error
    case standard
}

class ConsoleIO {
    
    func writeMessage(_ message: String, to: OutputType = .standard) {
        switch to {
        case .standard:
            print("\(message)")
        case .error:
            fputs("Error: \(message)\n", stderr)
        }
    }
    
    func printUsage() {
        let executableName = (CommandLine.arguments[0] as NSString).lastPathComponent
        
        writeMessage("Usage:")
        writeMessage("\(executableName) pathToFile")
    }
}
