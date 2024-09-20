//
//  Scanner.swift
//  slox
//
//  Created by Milan Darjanin on 20/09/2024.
//

class Scanner {
    let source: String
    private var tokens: [Token] = []
    private var start: String.Index
    private var current: String.Index
    private var line: Int = 1
    
    private var isAtEnd: Bool {
        current >= source.endIndex
    }
    
    init(source: String) {
        self.source = source
        self.start = source.startIndex
        self.current = source.startIndex
    }
    
    public func scanTokens() -> [Token] {
        while !isAtEnd {
            start = current
            scanToken()
        }
        
        tokens.append(.init(type: .EOF, lexeme: "", literal: nil, line: line))
        return tokens
    }
    
    private func scanToken() {
        let character = advance()
        switch character {
        case "(": addToken(.LEFT_PAREN)
        case ")": addToken(.RIGHT_PAREN)
        case "{": addToken(.LEFT_BRACE)
        case "}": addToken(.RIGHT_BRACE)
        case ",": addToken(.COMMA)
        case ".": addToken(.DOT)
        case "-": addToken(.MINUS)
        case "+": addToken(.PLUS)
        case ";": addToken(.SEMICOLON)
        case "*": addToken(.STAR)
        case "!": addToken(match("=") ? .BANG_EQUAL : .BANG)
        case "=": addToken(match("=") ? .EQUAL_EQUAL : .EQUAL)
        case "<": addToken(match("=") ? .LESS_EQUAL : .LESS)
        case ">": addToken(match("=") ? .GREATER_EQUAL : .GREATER)
        case "/": if match("/") {
            while peek() != "\n" && !isAtEnd { advance() }
        } else if match("*") {
            blockComment()
        } else {
            addToken(.SLASH)
        }
        case " ", "\t", "\r": break
        case "\n": line += 1
        case "\"": string()
        default:
            if character.isDigit {
                number()
            } else if character.isAlpha {
                identifier()
            } else {
                Slox.error(line: line, message: "Unexpected character \(character)")
            }
        }
    }
    
    private func addToken(_ type: TokenType) {
        addToken(type, literal: nil)
    }
    
    private func addToken(_ type: TokenType, literal: Any?) {
        let text = String(source[start..<current])
        tokens.append(.init(type: type, lexeme: text, literal: literal, line: line))
    }
    
    // MARK: - Helpers
    @discardableResult
    private func advance() -> Character {
        let character = source[current]
        current = source.index(current, offsetBy: 1)
        return character
    }
    
    private func match(_ expected: Character) -> Bool {
        guard !isAtEnd, source[current] == expected else { return false }
        current = source.index(current, offsetBy: 1)
        return true
    }
    
    private func peek() -> Character {
        isAtEnd ? "\0" : source[current]
    }
    
    private func peekNext() -> Character {
        let currentNext = source.index(current, offsetBy: 1)
        return currentNext >= source.endIndex ? "\0" : source[currentNext]
    }
    
    // MARK: - Identify tokens
    
    private func string() {
        while peek() != "\"" && !isAtEnd {
            if peek() == "\n" { line += 1 }
            advance()
        }
        
        if isAtEnd {
            Slox.error(line: line, message: "Undetermined string")
            return
        }
        
        // The closing ".
        advance()
        
        // Remove the surrounding quotes.
        let value = String(source[source.index(start, offsetBy: 1)..<source.index(current, offsetBy: -1)])
        addToken(.STRING, literal: value)
    }
    
    private func number() {
        while peek().isDigit { advance() }
        
        if peek() == "." && peekNext().isDigit {
            advance()
            
            while peek().isDigit { advance() }
        }
        
        addToken(.NUMBER, literal: Double(String(source[start..<current])))
    }
    
    private func identifier() {
        while peek().isAlphaNumeric { advance() }
        
        let text = String(source[start..<current])
        let type = TokenType.keywords[text] ?? .IDENTIFIER
        addToken(type)
    }
    
    private func blockComment() {
        while !(peek() == "*" && peekNext() == "/") && !isAtEnd {
            if peek() == "\n" { line += 1 }
            advance()
        }
        
        if isAtEnd {
            Slox.error(line: line, message: "Undetermined block comment")
            return
        }
        
        // Consume * and / at the end.
        advance()
        advance()
    }
}
