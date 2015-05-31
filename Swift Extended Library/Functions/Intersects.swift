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
public func intersected<C : ExtensibleCollectionType
    where C.Generator.Element : Equatable>
    (collection1: C,
    collection2: C,
    handler: ((element: C.Generator.Element, index1: C.Index?, index2: C.Index?, contains: Bool)-> Void)? = nil)
    -> C
{
    var results = C()
    
    var intersectedElementsInColelction2 = C()
    
    for element1 in collection1 {
        let index1 = find(collection1, element1)
        let index2 = find(collection2, element1)
        if !contains(results, element1) && index2 != nil {
            results.append(element1)
            intersectedElementsInColelction2.append(element1)
            handler?(element: element1, index1: index1, index2: index2, contains: true)
        } else {
            handler?(element: element1, index1: index1, index2: index2, contains: false)
        }
    }
    
    if let handler = handler {
        for element2 in collection2 {
            if !contains(intersectedElementsInColelction2, element2) {
                let index1 = find(collection1, element2)
                let index2 = find(collection2, element2)
                
                handler(element: element2, index1: index1, index2: index2, contains: false)
            }
        }
    }
    
    return results
}