//
//  Intersects.swift
//  SwiftExt
//
//  Created by Manfred Lau on 1/8/15.
//
//

extension SequenceType where Generator.Element : Equatable {
    /**
    To check if a sequence insertects with an other whose generator's element type conforms to Equatable protocol.
    
    - parameter     sequence:   The sequence to be evaluated
    
    - returns:      A result indicates if the receiver intersects the evaluated sequence
    */
    public func isIntersect(sequence: Self) -> Bool {
        for eachElement in sequence {
            if contains(eachElement) {
                return true
            }
        }
        return false
    }
}

extension SequenceType {
    public func isIntersect(sequence: Self,
        @noescape predicate: (Generator.Element,
        Generator.Element) -> Bool)
        -> Bool
    {
        for eachElement in sequence {
            for eachSelfElement in self {
                if predicate(eachSelfElement, eachElement) {
                    return true
                }
            }
        }
        return false
    }
}

