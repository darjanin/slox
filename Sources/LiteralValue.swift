//
//  LiteralValue.swift
//  slox
//
//  Created by Milan Darjanin on 20/09/2024.
//

enum LiteralValue: Equatable, Comparable {
    case number(Double)
    case string(String)
    case bool(Bool)
    case none
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.number(let lhsNumber), .number(let rhsNumber)):
            return lhsNumber == rhsNumber
        case (.string(let lhsString), .string(let rhsString)):
            return lhsString == rhsString
        case (.bool(let lhsBool), .bool(let rhsBool)):
            return lhsBool == rhsBool
        case (.none, .none):
            return true
        default:
            return false
        }
    }
    
    static func < (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.number(let lhsNumber), .number(let rhsNumber)):
            return lhsNumber < rhsNumber
        case (.string(let lhsString), .string(let rhsString)):
            return lhsString < rhsString
        case (.bool(let lhsBool), .bool(let rhsBool)):
            return !lhsBool && rhsBool
        case (.none, .none):
            return false
        default:
            return false
        }
    }
    
    static func === (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.number, .number): return true
        case (.string, .string): return true
        case (.bool, .bool): return true
        case (.none, .none): return true
        default: return false
        }
    }
    
    static func !== (lhs: Self, rhs: Self) -> Bool {
        !(lhs === rhs)
    }
}

extension LiteralValue: CustomStringConvertible {
    var description: String {
        switch self {
        case let .number(number):
            if number.isFractional {
                return String(number)
            } else {
                return String(Int(number))
            }
        case let .string(string): return string
        case let .bool(bool): return String(bool)
        case .none: return "nil"
        }
    }
}
