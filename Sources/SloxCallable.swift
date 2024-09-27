//
//  SloxCallable.swift
//  slox
//
//  Created by Milan Darjanin on 27/09/2024.
//

protocol SloxCallable: CustomStringConvertible {
    var arity: Int { get }

    func call(_ interpreter: Interpreter, arguments: [LiteralValue]) throws -> LiteralValue
}
