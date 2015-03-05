//
//  Logical XOR.swift
//  Swift Extended Library
//
//  Created by Manfred Lau on 3/5/15.
//
//

/**
Logical exclusive-or(XOR) calculator

:param:     lhs             A boolean value

:param:     rhs             An other boolean value

:returns:   The exclusive-or calculation result
*/
public func ^ (lhs: Bool, rhs: Bool) -> Bool {
    return (lhs && !rhs) || (!lhs && rhs)
}
