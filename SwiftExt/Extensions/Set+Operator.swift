//
//  Set+Operator.swift
//  SwiftExt
//
//  Created by Manfred Lau on 2/22/15.
//
//

// MARK: Operators
// Addition
public func += <T>(inout lhs: Set<T>, rhs: T) {
    lhs.insert(rhs)
}

public func += <T>(inout lhs: Set<T>, rhs: Set<T>) {
    lhs.unionInPlace(rhs)
}

public func + <T>(lhs: Set<T>, rhs: T) -> Set<T> {
    return lhs.union([rhs])
}

public func + <T>(lhs: T, rhs: Set<T>) -> Set<T> {
    return rhs.union([lhs])
}

public func + <T>(lhs: Set<T>, rhs: Set<T>) -> Set<T> {
    return lhs.union(rhs)
}

// Subtraction
public func -= <T>(inout lhs: Set<T>, rhs: T) {
    lhs.remove(rhs)
}

public func -= <T>(inout lhs: Set<T>, rhs: Set<T>) {
    lhs.subtractInPlace(rhs)
}

public func - <T>(lhs: Set<T>, rhs: T) -> Set<T> {
    return lhs.subtract([rhs])
}

public func - <T>(lhs: Set<T>, rhs: Set<T>) -> Set<T> {
    return lhs.subtract(rhs)
}
