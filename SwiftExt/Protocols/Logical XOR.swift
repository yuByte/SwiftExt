//
//  Logical XOR.swift
//  Swift-Extended-Library
//
//  Created by Manfred Lau on 3/5/15.
//
//

infix operator ^^ {
associativity left
precedence 140
}

/**
Logical exclusive-or(XOR) calculator

- parameter     lhs:             A boolean value

- parameter     rhs:             An other boolean value

- returns:   The exclusive-or calculation result
*/
public func ^^ (lhs: Bool, rhs: Bool) -> Bool {
    return !lhs != !rhs
}
