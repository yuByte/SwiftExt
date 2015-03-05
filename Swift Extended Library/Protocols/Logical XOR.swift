//
//  Logical XOR.swift
//  Swift Extended Library
//
//  Created by Manfred Lau on 3/5/15.
//
//

/// Logical exclusive or (XOR)
public func ^ (lhs: Bool, rhs: Bool) -> Bool {
    return (lhs && !rhs) || (!lhs && rhs)
}
