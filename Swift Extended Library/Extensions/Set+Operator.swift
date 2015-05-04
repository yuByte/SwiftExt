//
//  Set+Operator.swift
//  Swift Extended Library
//
//  Created by Manfred Lau on 2/22/15.
//
//

// MARK: Operators
// Plus
public func += <T>(inout lhs: Set<T>, rhs: T) {
    lhs.insert(rhs)
}

public func += <T>(inout lhs: Set<T>, rhs: Set<T>) {
    for each in rhs {
        lhs.insert(each)
    }
}

public func + <T>(lhs: Set<T>, rhs: T) -> Set<T> {
    var copied = lhs
    copied.insert(rhs)
    return copied
}

public func + <T>(lhs: T, rhs: Set<T>) -> Set<T> {
    var copied = rhs
    copied.insert(lhs)
    return copied
}

public func + <T>(lhs: Set<T>, rhs: Set<T>) -> Set<T> {
    return lhs.union(rhs)
}

// Minus
public func -= <T>(inout lhs: Set<T>, rhs: T) {
    lhs.remove(rhs)
}

public func -= <T>(inout lhs: Set<T>, rhs: Set<T>) {
    for each in rhs {
        lhs.remove(each)
    }
}

public func - <T>(lhs: Set<T>, rhs: T) -> Set<T> {
    var copied = lhs
    copied.remove(rhs)
    return copied
}

public func - <T>(lhs: T, rhs: Set<T>) -> Set<T> {
    var copied = rhs
    copied.remove(lhs)
    return copied
}

public func - <T>(lhs: Set<T>, rhs: Set<T>) -> Set<T> {
    return lhs.subtract(rhs)
}
