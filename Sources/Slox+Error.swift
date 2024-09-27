//
//  Slox+Error.swift
//  slox
//
//  Created by Milan Darjanin on 20/09/2024.
//

extension Slox {
    enum Error: Swift.Error {
        case runtimeError(token: Token, message: String)
        case parseError(token: Token, message: String)
    }
    
    /// Handlle Slox specific errors
    /// - Parameter error: Enum containing Slox errros.
    static func handleError(_ error: Slox.Error) {
        switch error {
        case let .parseError(token, message):
            print("ParseError[\(token.line)]: \(message)")
            Slox.hadError = true
        case let .runtimeError(token, message):
            print("RuntimeError[\(token.line)]: \(message)")
            Slox.hadRuntimeError = true
        }
    }
    
    /// Used in the Scanner
    static func error(line: Int, message: String) {
        print("ScannerError[\(line)]: \(message)")
        Slox.hadError = true
    }
}
