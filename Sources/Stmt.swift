//
//  Stmt.swift
//  slox
//
//  Created by Milan Darjanin on 20/09/2024.
//

protocol StmtVisitor<StmtReturnType> {
    associatedtype StmtReturnType
    
    func visitExpressionStmt(_ expr: Expression) throws -> StmtReturnType
    func visitPrintStmt(_ expr: Print) throws -> StmtReturnType
    func visitVarStmt(_ expr: Var) throws -> StmtReturnType
}

protocol Stmt {
    func accept<StmtReturnType>(_ visitor: any StmtVisitor<StmtReturnType>) throws  -> StmtReturnType
}

struct Expression: Stmt {
    let expression: Expr
    
    func accept<StmtReturnType>(_ visitor: any StmtVisitor<StmtReturnType>) throws -> StmtReturnType {
        try visitor.visitExpressionStmt(self)
    }
}

struct Print: Stmt {
    let expression: Expr
    
    func accept<StmtReturnType>(_ visitor: any StmtVisitor<StmtReturnType>) throws -> StmtReturnType {
        try visitor.visitPrintStmt(self)
    }
}

struct Var: Stmt {
    let name: Token
    let initializer: Expr?
    
    func accept<StmtReturnType>(_ visitor: any StmtVisitor<StmtReturnType>) throws -> StmtReturnType {
        try visitor.visitVarStmt(self)
    }
}
