//
//  Double+Fractional.swift
//  slox
//
//  Created by Milan Darjanin on 20/09/2024.
//

extension Double {
    var isFractional: Bool {
        truncatingRemainder(dividingBy: 1) != 0
    }
}
