//
//  Slox.swift
//  slox
//
//  Created by Milan Darjanin on 20/09/2024.
//

import Darwin
import Foundation




struct Slox {
    enum Error: Swift.Error {
        case runtimeError(token: Token, message: String)
        case parseError(token: Token, message: String)
    }
    
    private static let interpreter = Interpreter()
    static var hadError = false
    static var hadRuntimeError = false
    
    public static func runFile(_ file: String) throws {
        let url = URL(fileURLWithPath: file)
        let content = try String(contentsOf: url, encoding: .utf8)
        Slox.run(content)
        if hadError { Darwin.exit(65) }
        if hadRuntimeError { Darwin.exit(70) }
    }
    
    public static func runPrompt() {
        while true {
            print("> ", terminator: "")
            if let line = readLine() {
                Slox.run(line)
                Slox.hadError = false
            } else {
                break
            }
        }
    }
    
    static func error(line: Int, message: String) {
        report(line: line, where: "", message: message)
    }
    
    static func error(token: Token, message: String) {
        if token.type == .EOF {
            report(line: token.line, where: " at end", message: message)
        } else {
            report(line: token.line, where: " at '\(token.lexeme)'", message: message)
        }
    }
    
    /// Handlle Slox specific errors
    /// - Parameter error: Enum containing Slox errros.
    static func handleError(_ error: Slox.Error) {
        switch error {
        case let .parseError(token, message):
            print("ParseError at line [\(token.line)]: \(message)")
            Slox.hadError = true
        case let .runtimeError(token, message):
            print("RuntimeError at line [\(token.line)]: \(message)")
            Slox.hadRuntimeError = true
        }
    }
    
    // MARK: - Private
    
    private static func report(line: Int, `where`: String, message: String) {
        print("\(line): \(`where`): \(message)")
        Slox.hadError = true
    }
    
    private static func run(_ source: String) {
        let scanner = Scanner(source: source)
        let tokens = scanner.scanTokens()
        let parser = Parser(tokens: tokens)
        let statements = parser.parse()
        
        if hadError { return }
        
        interpreter.interpret(statements)
    }
}
