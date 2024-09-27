//
//  Stmt.swift
//  slox
//
//  Created by Milan Darjanin on 20/09/2024.
//

protocol StmtVisitor<StmtReturnType> {
    associatedtype StmtReturnType
    
    func visitExpressionStmt(_ stmt: Expression) throws -> StmtReturnType
    func visitPrintStmt(_ stmt: Print) throws -> StmtReturnType
    func visitVarStmt(_ stmt: Var) throws -> StmtReturnType
    func visitBlockStmt(_ stmt: Block) throws -> StmtReturnType
    func visitIfStmt(_ stmt: If) throws -> StmtReturnType
    func visitWhileStmt(_ stmt: While) throws -> StmtReturnType
    func visitFunctionStmt(_ stmt: Function) throws -> StmtReturnType
    func visitReturnStmt(_ stmt: Return) throws -> StmtReturnType
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

struct Return: Stmt {
    let keyword: Token
    let value: Expr?
    
    func accept<StmtReturnType>(_ visitor: any StmtVisitor<StmtReturnType>) throws -> StmtReturnType {
        try visitor.visitReturnStmt(self)
    }
}

struct Var: Stmt {
    let name: Token
    let initializer: Expr?
    
    func accept<StmtReturnType>(_ visitor: any StmtVisitor<StmtReturnType>) throws -> StmtReturnType {
        try visitor.visitVarStmt(self)
    }
}

struct Block: Stmt {
    let statements: [Stmt]
    
    func accept<StmtReturnType>(_ visitor: any StmtVisitor<StmtReturnType>) throws -> StmtReturnType {
        try visitor.visitBlockStmt(self)
    }
}

struct Function: Stmt {
    let name: Token
    let params: [Token]
    let body: [Stmt]
    
    func accept<StmtReturnType>(_ visitor: any StmtVisitor<StmtReturnType>) throws -> StmtReturnType {
        try visitor.visitFunctionStmt(self)
    }
}

struct If: Stmt {
    let condition: Expr
    let thenBranch: Stmt
    let elseBranch: Stmt?
    
    func accept<StmtReturnType>(_ visitor: any StmtVisitor<StmtReturnType>) throws -> StmtReturnType {
        try visitor.visitIfStmt(self)
    }
}

struct While: Stmt {
    let condition: Expr
    let body: Stmt
    
    func accept<StmtReturnType>(_ visitor: any StmtVisitor<StmtReturnType>) throws -> StmtReturnType {
        try visitor.visitWhileStmt(self)
    }
}
