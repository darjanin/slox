//
//  Token.swift
//  slox
//
//  Created by Milan Darjanin on 20/09/2024.
//

enum TokenType {
    // Single-character tokens.
    case LEFT_PAREN, RIGHT_PAREN, LEFT_BRACE, RIGHT_BRACE, COMMA, DOT, MINUS, PLUS, SEMICOLON, SLASH, STAR
    
    // One or two character tokens.
    case BANG, BANG_EQUAL, EQUAL, EQUAL_EQUAL, GREATER, GREATER_EQUAL, LESS, LESS_EQUAL
    
    // Literals.
    case IDENTIFIER, STRING, NUMBER
    
    // Keywords.
    case AND, CLASS, ELSE, FALSE, FUN, FOR, IF, NIL, OR, PRINT, RETURN, SUPER, THIS, TRUE, VAR, WHILE
    
    case EOF
    
    static let keywords: [String:TokenType] = [
        "and": .AND,
        "class": .CLASS,
        "else": .ELSE,
        "false": .FALSE,
        "for": .FOR,
        "fun": .FUN,
        "if": .IF,
        "nil": .NIL,
        "or": .OR,
        "print": .PRINT,
        "return": .RETURN,
        "super": .SUPER,
        "this": .THIS,
        "true": .TRUE,
        "var": .VAR,
        "while": .WHILE
    ]
}

struct Token {
    let type: TokenType
    let lexeme: String
    let literal: Any?
    let line: Int
}

extension Token: CustomStringConvertible {
    public var description: String {
        "\(type) \(lexeme) \(literal ?? "")"
    }
}
