//
//  SloxFunction.swift
//  slox
//
//  Created by Milan Darjanin on 27/09/2024.
//

struct SloxFunction: SloxCallable {
    let declaration: Function
    let closure: Environment
    
    var arity: Int { declaration.params.count }
    var description: String { "<fn \(declaration.name.lexeme)>" }
    
    func call(_ interpreter: Interpreter, arguments: [LiteralValue]) throws -> LiteralValue {
        let environment = Environment(enclosing: closure)
        for (index, _) in declaration.params.enumerated() {
            environment.define(
                name: declaration.params[index].lexeme,
                value: arguments[index]
            )
        }
        do {
            try interpreter.executeBlock(statements: declaration.body, environment: environment)
        } catch let runtime as Slox.Runtime {
            if case let .return(value) = runtime {
                return value
            }
        }
        return .none
    }
}
