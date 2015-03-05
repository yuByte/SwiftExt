//
//  Intersects.swift
//  Swift Extended Library
//
//  Created by Manfred Lau on 1/8/15.
//
//

/**
To check if a sequence insertects with an other whose generator's element type conforms to Equatable protocol.

:param:     seqA                A sequence

:param:     seqB                An other sequence

:returns:   A result indicates if seqA contains seqB
*/
public func intersects<S : SequenceType where S.Generator.Element : Equatable>(seqA: S, seqB: S) -> Bool {
    for eachElement in seqB {
        if contains(seqA, eachElement) {
            return true
        }
    }
    return false
}

/**
To check if a collection insertects with an other whose generator's element type conforms to Equatable protocol.

:param:     collectionA         A collection

:param:     collectionB         An other collection

:returns:   A result indicates if collectionA contains collectionB
*/
public func intersected<C : ExtensibleCollectionType where C.Generator.Element : Equatable>(collectionA: C, collectionB: C) -> C {
    var newCollection = C()
    
    for eachElement in collectionA {
        if !contains(newCollection, eachElement) && contains(collectionB, eachElement) {
            newCollection.append(eachElement)
        }
    }
    
    return newCollection
}