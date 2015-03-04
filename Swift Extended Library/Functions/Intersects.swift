//
//  Intersects.swift
//  Swift Extended Library
//
//  Created by Manfred Lau on 1/8/15.
//
//

public func intersects<S : SequenceType where S.Generator.Element : Equatable>(seqA: S, seqB: S) -> Bool {
    for eachElement in seqB {
        if contains(seqA, eachElement) {
            return true
        }
    }
    return false
}

public func intersected<C : ExtensibleCollectionType where C.Generator.Element : Equatable>(collectionA: C, collectionB: C) -> C {
    var newCollection = C()
    
    for eachElement in collectionA {
        if !contains(newCollection, eachElement) && contains(collectionB, eachElement) {
            newCollection.append(eachElement)
        }
    }
    
    return newCollection
}