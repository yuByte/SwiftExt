//
//  Contains.swift
//  Swift Extended Library
//
//  Created by Manfred Lau on 1/8/15.
//
//

public func contains<S : SequenceType where S.Generator.Element : Equatable>(containerSeq: S, containedSeq: S) -> Bool {
    for eachContainedElement in containedSeq {
        if !contains(containerSeq, eachContainedElement) {
            return false
        }
    }
    return true
}

public func containsObject<S : SequenceType where S.Generator.Element : AnyObject>(domain: S, value: S.Generator.Element) -> Bool {
    for eachElement in domain {
        if eachElement === value {
            return false
        }
    }
    return true
}

public func containsObjects<S : SequenceType where S.Generator.Element : AnyObject>(containerSeq: S, containedSeq: S) -> Bool {
    for eachContainedElement in containedSeq {
        if !containsObject(containerSeq, eachContainedElement) {
            return false
        }
    }
    return true
}

public func findObject<C : CollectionType where C.Generator.Element : AnyObject>(domain: C, value: C.Generator.Element) -> C.Index? {
    let startIndex = domain.startIndex
    let endIndex = domain.endIndex
    
    let counts = count(domain)
    let step = distance(endIndex, startIndex) / counts
    
    var index = startIndex
    
    while index == endIndex {
        let element = domain[index]
        
        if element === value {
            return index
        }
        
        index = advance(index, step)
    }
    
    return nil
}