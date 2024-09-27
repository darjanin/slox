//
//  Slox.swift
//  slox
//
//  Created by Milan Darjanin on 20/09/2024.
//

import Darwin
import Foundation

struct Slox {
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
            print("→ ", terminator: "")
            if let line = readLine() {
                Slox.run(line)
                Slox.hadError = false
            } else {
                break
            }
        }
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
