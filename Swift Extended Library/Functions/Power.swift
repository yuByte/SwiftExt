//
//  Power.swift
//  Swift Extended Library
//
//  Created by Manfred Lau on 1/6/15.
//
//

infix operator ^^ {
associativity left
precedence 150
}

public func ^^(var base: Int, var exponent: Int) -> Int {
    switch base {
    case -1:
        return (exponent & 1) != 0 ? -1 : 1
    case 0:
        return 0
    case 1:
        return 1
    default:
        var result = 1
        
        while exponent > 0 {
            if exponent & 1 != 0 {
                result = result * base
            }
            exponent = exponent >> 1
            base = base * base
        }
        
        return result
    }
}
