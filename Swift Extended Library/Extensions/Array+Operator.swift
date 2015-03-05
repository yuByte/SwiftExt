//
//  Array.swift
//  Swift Extended Library
//
//  Created by Manfred Lau on 10/20/14.
//
//

import Swift

extension Array {
    //FIXME: Needs to be declared as public when Swift allows adding extension to a generic type
    var indexCap: Int {
        return max(0, count - 1)
    }
}

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
            if let indexInLhs = find(lhs, object) {
                lhs.removeAtIndex(indexInLhs)
            }
        }
    }
}

public func -= <T: Equatable> (inout lhs: Array<T>, rhs: T?) {
    if rhs != nil {
        if let indexInLhs = find(lhs, rhs!) {
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
    if let indexInCopied = find(copied, rhs) {
        copied.removeAtIndex(indexInCopied)
    }
    return copied
}

public func - <T: Equatable> (lhs: Array<T>, rhs: Array<T>) -> Array<T> {
    var copied = lhs
    for object in rhs {
        if let indexInCopied = find(copied, object) {
            copied.removeAtIndex(indexInCopied)
        }
    }
    return copied
}

/**
To get the index cap of a given CollectionType conformed type value

:param:     x               The CollectionType conformed type value

:returns:   The index cap for x
*/
public func indexCap<T : CollectionType>(x: T) -> T.Index.Distance {
    return max(count(x) - T.Index.Distance(1), T.Index.Distance(0))
}

/**
To get the last index of a given CollectionType conformed type value

:param:     x               The CollectionType conformed type value

:returns:   The last index for x
*/
public func lastIndex<T : CollectionType>(x: T) -> T.Index.Distance? {
    let elementsCount = count(x)
    if elementsCount == 0 {
        return nil
    } else {
        return max(elementsCount - T.Index.Distance(1), T.Index.Distance(0))
    }
}
