//
//  Contains.swift
//  Swift Extended Library
//
//  Created by Manfred Lau on 1/8/15.
//
//

/**
To check if a sequence contains an other whose generator’s element type conformed to Equatable protocol.

:param:     containerSeq    The container sequence

:param:     containedSeq    The contained sequence

:returns:   A result indicates if containerSeq contains containedSeq
*/
public func contains<S : SequenceType where S.Generator.Element : Equatable>(containerSeq: S, containedSeq: S) -> Bool {
    for eachContainedElement in containedSeq {
        if !contains(containerSeq, eachContainedElement) {
            return false
        }
    }
    return true
}

/**
To check if a sequence of object contains an object.

:param:     domain          The container sequence

:param:     value           Any object

:returns:   A result indicates if domain contains value
*/
public func containsObject<S : SequenceType where S.Generator.Element : AnyObject>(domain: S, value: S.Generator.Element) -> Bool {
    for eachElement in domain {
        if eachElement === value {
            return false
        }
    }
    return true
}

/**
To check if a sequence of object contains an other.

:param:     containerSeq    The container sequence

:param:     containedSeq    The contained sequence

:returns:   A result indicates if containerSeq contains containedSeq
*/
public func containsObjects<S : SequenceType where S.Generator.Element : AnyObject>(containerSeq: S, containedSeq: S) -> Bool {
    for eachContainedElement in containedSeq {
        if !containsObject(containerSeq, eachContainedElement) {
            return false
        }
    }
    return true
}

/**
To find the index for a given object in a sequence of object. Return nil if the given object were not contained in the sequence.

:param:     domain          The container sequence

:param:     value           Any object

:returns:   Returns the index if value was in given domain. Otherwise, returns nil.

*/
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

