//
//  Contains.swift
//  Swift-Extended-Library
//
//  Created by Manfred Lau on 1/8/15.
//
//

extension SequenceType where Generator.Element : Equatable {
    /**
    To check if a sequence is contained in the receiver.
    
    - parameter     containedSeq:    The contained sequence
    
    - returns:   A result indicates if the receiver contains the containedSeq
    */
    public func contains(containedSeq: Self) -> Bool {
        for eachContainedElement in containedSeq {
            if !contains(eachContainedElement) {
                return false
            }
        }
        return true
    }
}

extension SequenceType {
    /**
    To check if a sequence is contained in the receiver.
    
    - parameter     containedSeq:    The contained sequence
    
    - returns:   A result indicates if the receiver contains the containedSeq
    */
    public func contains(containedSeq: Self, @noescape predicate: (Self.Generator.Element) -> Bool) -> Bool {
        for eachContainedElement in containedSeq {
            if !predicate(eachContainedElement) {
                return false
            }
        }
        return true
    }
}
