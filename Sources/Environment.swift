//
//  Environment.swift
//  slox
//
//  Created by Milan Darjanin on 20/09/2024.
//

class Environment {
    private var values: [String:LiteralValue] = [:]
    
    public func define(name: String, value: LiteralValue) {
        values[name] = value
    }
    
    public func get(name: Token) throws -> LiteralValue? {
        if values.contains(where: { $0.key == name.lexeme }) {
            return values[name.lexeme]
        }
        
        throw Slox.Error.runtimeError(token: name, message: "Undefined variable \(name.lexeme).")
    }
    
    public func assign(name: Token, value: LiteralValue) throws {
        if values.contains(where: { $0.key == name.lexeme }) {
            values[name.lexeme] = value
            return
        }
        
        throw Slox.Error.runtimeError(token: name, message: "Undefined variable '\(name.lexeme)'.")
    }
}
