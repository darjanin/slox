//
//  AstPrinter.swift
//  slox
//
//  Created by Milan Darjanin on 19/09/2024.
//

protocol ExprVisitor<ExprReturnType> {
    associatedtype ExprReturnType
    func visitBinaryExpr(_ expr: Binary) throws -> ExprReturnType
    func visitUnaryExpr(_ expr: Unary) throws -> ExprReturnType
    func visitGroupingExpr(_ expr: Grouping) throws -> ExprReturnType
    func visitLiteralExpr(_ expr: Literal) throws -> ExprReturnType
    func visitVariableExpr(_ expr: Variable) throws -> ExprReturnType
    func visitAssignExpr(_ expr: Assign) throws -> ExprReturnType
}


protocol Expr {
    func accept<ExprReturnType>(_ visitor: any ExprVisitor<ExprReturnType>) throws -> ExprReturnType
}

struct Binary: Expr {
    let left: Expr
    let `operator`: Token
    let right: Expr
    
    func accept<ExprReturnType>(_ visitor: any ExprVisitor<ExprReturnType>) throws -> ExprReturnType {
        try visitor.visitBinaryExpr(self)
    }
}

struct Unary: Expr {
    let `operator`: Token
    let right: Expr
    
    func accept<ExprReturnType>(_ visitor: any ExprVisitor<ExprReturnType>) throws -> ExprReturnType {
        try visitor.visitUnaryExpr(self)
    }
}

struct Grouping: Expr {
    let expression: Expr
    
    func accept<ExprReturnType>(_ visitor: any ExprVisitor<ExprReturnType>) throws -> ExprReturnType {
        try visitor.visitGroupingExpr(self)
    }
}

struct Literal: Expr {
    let value: LiteralValue
    
    func accept<ExprReturnType>(_ visitor: any ExprVisitor<ExprReturnType>) throws -> ExprReturnType {
        try visitor.visitLiteralExpr(self)
    }
}

struct Variable: Expr {
    let name: Token
    
    func accept<ExprReturnType>(_ visitor: any ExprVisitor<ExprReturnType>) throws -> ExprReturnType {
        try visitor.visitVariableExpr(self)
    }
}

struct Assign: Expr {
    let name: Token
    let value: Expr
    
    func accept<ExprReturnType>(_ visitor: any ExprVisitor<ExprReturnType>) throws -> ExprReturnType {
        try visitor.visitAssignExpr(self)
    }
}
