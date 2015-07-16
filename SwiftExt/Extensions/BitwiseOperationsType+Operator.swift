//
//  BitwiseOperationsType+Operator.swift
//  Swift-Extended-Library
//
//  Created by Manfred Lau on 10/13/14.
//
//

infix operator |? { associativity left precedence 120}
public func |? <T where T: protocol<BitwiseOperationsType, Equatable>>
    (left: T, right: T) -> Bool
{
    return (right & left) != T.allZeros
}

infix operator !|? { associativity left precedence 120}
public func !|? <T where T: protocol<BitwiseOperationsType, Equatable>>
    (left: T, right: T) -> Bool
{
    return (right & left) == T.allZeros
}
