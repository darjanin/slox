//
//  AstPrinter.swift
//  slox
//
//  Created by Milan Darjanin on 19/09/2024.
//
//
//class AstPrinter: ExprVisitor {
//    typealias ReturnType = String
//    
//    func visitBinaryExpr(_ expr: Binary) throws -> ReturnType {
//        try parenthesize(expr.operator.lexeme, expr.left, expr.right)
//    }
//    
//    func visitUnaryExpr(_ expr: Unary) throws -> ReturnType {
//        try parenthesize(expr.operator.lexeme, expr.right)
//    }
//    
//    func visitGroupingExpr(_ expr: Grouping) throws -> ReturnType {
//        try parenthesize("group", expr.expression)
//    }
//    
//    func visitLiteralExpr(_ expr: Literal) -> ReturnType {
//        switch expr.value {
//        case .number(let number):
//            return String(number)
//        case .bool(let bool):
//            return bool.description
//        case .string(let string):
//            return string
//        case .none:
//            return "nil"
//        }
//    }
//    
//    func print(_ expr: Expr) throws -> ReturnType {
//        try expr.accept(self)
//    }
//    
//    private func parenthesize(_ name: String, _ exprs: Expr...) throws -> ReturnType {
//        var result = ""
//        
//        result += "(\(name)"
//        for expr in exprs {
//            result += " "
//            result += try expr.accept(self)
//        }
//        result += ")"
//        
//        return result
//    }
//}
