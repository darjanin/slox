//
//  Environment.swift
//  slox
//
//  Created by Milan Darjanin on 20/09/2024.
//

class Environment {
    let enclosing: Environment?
    private var values: [String:LiteralValue] = [:]
    
    init() {
        enclosing = nil
    }
    
    init(enclosing: Environment) {
        self.enclosing = enclosing
    }
    
    public func define(name: String, value: LiteralValue) {
        values[name] = value
    }
    
    public func get(name: Token) throws -> LiteralValue? {
        if values.contains(where: { $0.key == name.lexeme }) {
            guard let value = values[name.lexeme], value != .none else {
                throw Slox.Error.runtimeError(token: name, message: "Cannot use unitialized variable '\(name.lexeme)'.")
            }
            
            return value
        }
        
        if let enclosing = enclosing {
            return try enclosing.get(name: name)
        }
        
        throw Slox.Error.runtimeError(token: name, message: "Undefined variable \(name.lexeme).")
    }
    
    public func assign(name: Token, value: LiteralValue) throws {
        if values.contains(where: { $0.key == name.lexeme }) {
            values[name.lexeme] = value
            return
        }
        
        if let enclosing = enclosing {
            try enclosing.assign(name: name, value: value)
            return
        }
        
        throw Slox.Error.runtimeError(token: name, message: "Undefined variable '\(name.lexeme)'.")
    }
}
