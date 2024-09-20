//
//  Character+Validation.swift
//  slox
//
//  Created by Milan Darjanin on 20/09/2024.
//

extension Character {
    var isAlpha: Bool {
        (self >= "a" && self <= "z") || (self >= "A" && self <= "Z") || self == "_"
    }
    
    var isDigit: Bool { self >= "0" && self <= "9" }
    
    var isAlphaNumeric: Bool { isAlpha || isDigit }
}
