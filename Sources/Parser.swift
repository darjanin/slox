//
//  Parser.swift
//  slox
//
//  Created by Milan Darjanin on 19/09/2024.
//

class Parser {
    private let tokens: [Token]
    private var current = 0
    private var statements: [Stmt] = []
    
    private var peek: Token { tokens[current] }
    private var previous: Token { tokens[current - 1] }
    private var isAtEnd: Bool { peek.type == .EOF }
    
    init(tokens: [Token]) {
        self.tokens = tokens
    }
    
    public func parse() -> [Stmt] {
        do {
            while !isAtEnd {
                if let statement = try declaration() {
                    statements.append(statement)
                }
            }
        } catch let error as Slox.Error {
            Slox.handleError(error)
        } catch { }
        return statements
    }
    
    // MARK: - Rules
    
    private func declaration() throws -> Stmt? {
        do {
            if match(.VAR) { return try varDeclaration() }
            
            return try statement()
        } catch let error as Slox.Error {
            if case .parseError = error {
                synchronize()
            }

            return nil;
        }
    }
    
    private func varDeclaration() throws -> Stmt {
        let name = try consume(.IDENTIFIER, message: "Expect variable name.")
        let initializer = match(.EQUAL) ? try expression() : nil
        try consume(.SEMICOLON, message: "Expect ';' after variable declaration.")
        return Var(name: name, initializer: initializer)
    }
    
    private func statement() throws -> Stmt {
        if match(.PRINT) { return try printStatement() }

        return try expressionStatement()
    }
    
    private func printStatement() throws -> Stmt {
        let value = try expression()
        try consume(.SEMICOLON, message: "Expect ';' after value")
        return Print(expression: value)
    }
    
    private func expressionStatement() throws -> Stmt {
        let value = try expression()
        return Expression(expression: value)
    }
    
    private func expression() throws -> Expr {
        return try comma()
    }
    
    private func comma() throws -> Expr {
        var expr = try equality()
        
        while match(.COMMA) {
            let `operator` = previous
            let right = try equality()
            expr = Binary(left: expr, operator: `operator`, right: right)
        }
        
        return expr
    }

    private func equality() throws -> Expr {
        var expr = try comparison()
        
        while match(.BANG_EQUAL, .EQUAL_EQUAL) {
            let `operator` = previous
            let right = try comparison()
            expr = Binary(left: expr, operator: `operator`, right: right)
        }
        
        return expr
    }
    
    private func comparison() throws -> Expr {
        var expr = try term()
        
        while match(.GREATER, .GREATER_EQUAL, .LESS, .LESS_EQUAL) {
            let `operator` = previous
            let right = try term()
            expr = Binary(left: expr, operator: `operator`, right: right)
        }
        
        return expr
    }
    
    private func term() throws -> Expr {
        var expr = try factor()
        
        while match(.MINUS, .PLUS) {
            let `operator` = previous
            let right = try factor()
            expr = Binary(left: expr, operator: `operator`, right: right)
        }
        
        return expr
    }
    
    private func factor() throws -> Expr {
        var expr = try unary()
        
        while match(.SLASH, .STAR) {
            let `operator` = previous
            let right = try unary()
            expr = Binary(left: expr, operator: `operator`, right: right)
        }
        
        return expr
    }
    
    private func unary() throws -> Expr {
        if match(.BANG, .MINUS) {
            let `operator` = previous
            let right = try unary()
            return Unary(operator: `operator`, right: right)
        }
        
        return try primary()
    }
    
    private func primary() throws -> Expr {
        if match(.NUMBER) { return Literal(value: .number(previous.literal as! Double)) }
        if match(.STRING) { return Literal(value: .string(previous.literal as! String)) }
        if match(.TRUE) { return Literal(value: .bool(true)) }
        if match(.FALSE) { return Literal(value: .bool(false)) }
        if match(.NIL) { return Literal(value: .none) }
        if match(.IDENTIFIER) { return Variable(name: previous) }
        
        if match(.LEFT_PAREN) {
            let expr = try expression()
            try consume(.RIGHT_PAREN, message: "Expect ')' after expression.")
            return Grouping(expression: expr)
        }
        
        throw Slox.Error.parseError(token: peek, message: "Expect expression.")
    }
    
    // MARK: - Helpers
    private func match(_ types: TokenType...) -> Bool {
        for type in types {
            if check(type) {
                advance()
                return true
            }
        }
        
        return false
    }
    
    private func check(_ type: TokenType) -> Bool {
        !isAtEnd && peek.type == type
    }
    
    @discardableResult
    private func advance() -> Token {
        if !isAtEnd { current += 1 }
        return previous
    }
    
    @discardableResult
    private func consume(_ type: TokenType, message: String) throws -> Token {
        guard check(type) else { throw Slox.Error.parseError(token: peek, message: message) }
        return advance()
    }
    
    // MARK: - Synchronize
    
    private func synchronize() {
        advance()
        
        while !isAtEnd {
            if previous.type == .SEMICOLON { return }
            
            switch peek.type {
            case .CLASS, .FUN, .VAR, .FOR, .IF, .WHILE, .PRINT, .RETURN: return
            default: break
            }
            
            advance()
        }
    }
}
