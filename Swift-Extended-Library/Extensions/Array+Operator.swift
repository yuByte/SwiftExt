//
//  Array.swift
//  Swift Extended Library
//
//  Created by Manfred Lau on 10/20/14.
//
//

import Swift

public func += <T> (inout lhs: Array<Any>, rhs: Array<T>?) {
    if rhs != nil {
        for object in rhs! {
            lhs.append(object)
        }
    }
}

public func += <T> (inout lhs: Array<T>, rhs: T?) {
    if rhs != nil {
        lhs.append(rhs!)
    }
}

public func -= <T: Equatable> (inout lhs: Array<T>, rhs: Array<T>?) {
    if rhs != nil {
        for object in rhs! {
            if let indexInLhs = lhs.indexOf(object) {
                lhs.removeAtIndex(indexInLhs)
            }
        }
    }
}

public func -= <T: Equatable> (inout lhs: Array<T>, rhs: T?) {
    if rhs != nil {
        if let indexInLhs = lhs.indexOf(rhs!) {
            lhs.removeAtIndex(indexInLhs)
        }
    }
}

public func + <T> (lhs: Array<T>, rhs: T?) -> Array<T> {
    if rhs != nil {
        var copied = lhs
        copied.append(rhs!)
        return copied
    }
    return lhs
}

public func + <T> (lhs: T, rhs: Array<T>?) -> Array<T> {
    if rhs != nil {
        var copied = rhs!
        copied.append(lhs)
        return copied
    } else {
        return [lhs]
    }
}

public func - <T: Equatable> (lhs: Array<T>, rhs: T) -> Array<T> {
    var copied = lhs
    if let indexInCopied = copied.indexOf(rhs) {
        copied.removeAtIndex(indexInCopied)
    }
    return copied
}

public func - <T: Equatable> (lhs: Array<T>, rhs: Array<T>) -> Array<T> {
    var copied = lhs
    for object in rhs {
        if let indexInCopied = copied.indexOf(object) {
            copied.removeAtIndex(indexInCopied)
        }
    }
    return copied
}
