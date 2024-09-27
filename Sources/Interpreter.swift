//
//  Interpreter.swift
//  slox
//
//  Created by Milan Darjanin on 20/09/2024.
//

import Foundation

struct Clock: SloxCallable {
    var arity: Int { 0 }
    
    func call(_ interpreter: Interpreter, arguments: [LiteralValue]) -> LiteralValue {
        return .number(Double(DispatchTime.now().uptimeNanoseconds / 1_000_000))
    }
    
    var description: String { "<native fn>" }
}

class Interpreter {
    final let globals = Environment()
    private var environment: Environment
    
    init() {
        self.environment = globals
        globals.define(name: "clock", value: .function(Clock()))
    }
    
    public func interpret(_ statements: [Stmt]) {
        do {
            for statement in statements {
                try execute(statement)
            }
        } catch let error as Slox.Error {
            Slox.handleError(error)
        } catch {
            fatalError("Unexpected error: \(error).")
        }
    }
    
    private func execute(_ stmt: Stmt) throws {
        try stmt.accept(self)
    }
    
    func executeBlock(statements: [Stmt], environment: Environment) throws {
        let previousEnvironment = self.environment
        defer {
            self.environment = previousEnvironment
        }
            
        self.environment = environment
        for statement in statements {
            try execute(statement)
        }
    }
    
    @discardableResult
    private func evaluate(_ expr: Expr) throws -> ExprReturnType {
        try expr.accept(self)
    }
    
    private func isTruthy(_ value: LiteralValue) -> Bool {
        if value == .none { return false }
        if case let .bool(bool) = value { return bool }
        return true
    }
    
    private func checkSameType(_ `operator`: Token, _ left: LiteralValue, _ right: LiteralValue) throws {
        if left !== right {
            throw Slox.Error.runtimeError(
                token: `operator`,
                message: "Operands must be of same type."
            )
        }
    }
}

// MARK: - ExprVisitor
extension Interpreter: ExprVisitor {
    typealias ExprReturnType = LiteralValue
    
    func visitBinaryExpr(_ expr: Binary) throws -> ExprReturnType {
        let left = try evaluate(expr.left)
        let right = try evaluate(expr.right)
        
        switch expr.operator.type {
        case .MINUS:
            switch (left, right) {
            case (.number(let lhsNumber), .number(let rhsNumber)):
                return .number(lhsNumber - rhsNumber)
            default:
                throw Slox.Error.runtimeError(
                    token: expr.operator,
                    message: "Operands must be numbers."
                )
            }
        case .SLASH:
            switch (left, right) {
            case (.number(let lhsNumber), .number(let rhsNumber)):
                if rhsNumber == 0 {
                    throw Slox.Error.runtimeError(
                        token: expr.operator,
                        message: "Division by 0 is not allowed."
                    )
                }
                return .number(lhsNumber / rhsNumber)
            default:
                throw Slox.Error.runtimeError(
                    token: expr.operator,
                    message: "Operands must be numbers."
                )
            }
        case .STAR:
            switch (left, right) {
            case let (.number(lhsNumber), .number(rhsNumber)):
                return .number(lhsNumber * rhsNumber)
            default:
                throw Slox.Error.runtimeError(
                    token: expr.operator,
                    message: "Operands must be numbers."
                )
            }
        case .PLUS:
            switch (left, right) {
            case let (.number(lhsNumber), .number(rhsNumber)):
                return .number(lhsNumber + rhsNumber)
            case let (.string(lhsString), .string(rhsString)):
                return .string(lhsString + rhsString)
            case (.number, .string), (.string, .number):
                return .string("\(left)\(right)")
            default:
                throw Slox.Error.runtimeError(
                    token: expr.operator,
                    message: "Operands must be two numbers or two strings."
                )
            }
        case .GREATER:
            try checkSameType(expr.operator, left, right)
            return .bool(left > right)
        case .GREATER_EQUAL:
            try checkSameType(expr.operator, left, right)
            return .bool(left >= right)
        case .LESS:
            try checkSameType(expr.operator, left, right)
            return .bool(left < right)
        case .LESS_EQUAL:
            try checkSameType(expr.operator, left, right)
            return .bool(left <= right)
        case .EQUAL_EQUAL:
            try checkSameType(expr.operator, left, right)
            return .bool(left == right)
        case .BANG_EQUAL:
            try checkSameType(expr.operator, left, right)
            return .bool(left != right)
        case .COMMA:
            return right
        default:
            throw Slox.Error.runtimeError(
                token: expr.operator,
                message: "Unknown operator."
            )
        }
    }
    
    func visitUnaryExpr(_ expr: Unary) throws -> ExprReturnType {
        let right = try evaluate(expr.right)
        
        switch expr.operator.type {
        case .BANG: return .bool(!isTruthy(right))
        case .MINUS:
            switch right {
            case let .number(rhsNumber):
                return .number(-rhsNumber)
            default:
                throw Slox.Error.runtimeError(
                    token: expr.operator,
                    message: "Operand must be a number."
                )
            }
        default: return .none
        }
    }
    
    func visitCallExpr(_ expr: Call) throws -> ExprReturnType {
        let callee = try evaluate(expr.callee)
        
        var arguments: [ExprReturnType] = []
        for argument in expr.arguments {
            arguments.append(try evaluate(argument))
        }
        
        guard case let .function(function) = callee else {
            throw Slox.Error.runtimeError(token: expr.paren, message: "Can only call functions and classes.")
        }
        
        if arguments.count != function.arity {
            throw Slox.Error.runtimeError(token: expr.paren, message: "Expected \(function.arity) arguments but got \(arguments.count).")
        }
        return try function.call(self, arguments: arguments)
    }
    
    func visitGroupingExpr(_ expr: Grouping) throws -> ExprReturnType {
        try evaluate(expr.expression)
    }
    
    func visitLiteralExpr(_ expr: Literal) -> ExprReturnType {
        expr.value
    }
    
    func visitVariableExpr(_ expr: Variable) throws -> ExprReturnType {
        try environment.get(name: expr.name) ?? .none
    }
    
    func visitAssignExpr(_ expr: Assign) throws -> ExprReturnType {
        let value = try evaluate(expr.value)
        try environment.assign(name: expr.name, value: value)
        return value
    }
    
    func visitLogicalExpr(_ expr: Logical) throws -> ExprReturnType {
        let left = try evaluate(expr.left)
        
        if (expr.operator.type == .OR && isTruthy(left)) ||
           (expr.operator.type == .AND && !isTruthy(left)) {
            return left
        }
                
        return try evaluate(expr.right)
    }
}

// MARK: - StmtVisitor
extension Interpreter: StmtVisitor {
    typealias StmtReturnType = Void
    
    func visitExpressionStmt(_ stmt: Expression) throws -> StmtReturnType {
        try evaluate(stmt.expression)
    }
    
    func visitPrintStmt(_ stmt: Print) throws -> StmtReturnType {
        let value = try evaluate(stmt.expression)
        print(value)
    }
    
    func visitVarStmt(_ stmt: Var) throws -> StmtReturnType {
        environment.define(name: stmt.name.lexeme, value: .none)
        let value = stmt.initializer != nil ? try evaluate(stmt.initializer!) : nil;
        environment.define(name: stmt.name.lexeme, value: value ?? .none)
    }
    
    func visitBlockStmt(_ stmt: Block) throws -> StmtReturnType {
        try executeBlock(
            statements: stmt.statements,
            environment: Environment(enclosing: environment)
        )
    }
    
    func visitFunctionStmt(_ stmt: Function) throws -> StmtReturnType {
        let function = SloxFunction(declaration: stmt, closure: environment)
        environment.define(name: stmt.name.lexeme, value: .function(function))
    }
    
    func visitIfStmt(_ stmt: If) throws -> StmtReturnType {
        if isTruthy(try evaluate(stmt.condition)) {
            try execute(stmt.thenBranch)
            return
        }
        
        if let elseBranch = stmt.elseBranch {
            try execute(elseBranch)
        }
    }
    
    func visitWhileStmt(_ stmt: While) throws -> StmtReturnType {
        while isTruthy(try evaluate(stmt.condition)) {
            try execute(stmt.body)
        }
    }
    
    func visitReturnStmt(_ stmt: Return) throws -> StmtReturnType {
        let value: LiteralValue = stmt.value == nil ? .none : try evaluate(stmt.value!)
        throw Slox.Runtime.return(value: value)
    }
}
