//
//  RPNPrinter.swift
//  slox
//
//  Created by Milan Darjanin on 20/09/2024.
//
//
//class RPNPrinter: ExprVisitor {
//    typealias ReturnType = String
//    
//    func print(_ expr: Expr) throws -> ReturnType {
//        try expr.accept(self)
//    }
//    
//    func visitBinaryExpr(_ expr: Binary) throws -> ReturnType {
//        "\(try expr.left.accept(self)) \(try expr.right.accept(self)) \(expr.operator.lexeme)"
//    }
//    
//    func visitUnaryExpr(_ expr: Unary) throws -> ReturnType {
//        "\(try expr.right.accept(self)) \(expr.operator.lexeme)"
//    }
//    
//    func visitGroupingExpr(_ expr: Grouping) -> ReturnType {
//        "(\(expr.expression)"
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
//}
