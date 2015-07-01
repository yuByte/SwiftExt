//
//  Intersects.swift
//  Swift-Extended-Library
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
    public func intersects(sequence: Self) -> Bool {
        for eachElement in sequence {
            if contains(eachElement) {
                return true
            }
        }
        return false
    }
}

extension ExtensibleCollectionType where Generator.Element : Equatable {
    /**
    To check if a collection insertects with an other whose generator's element type conforms to Equatable protocol.
    
    - parameter     collection:     The collection to be intersected with
    
    - returns:      A result indicates if collectionA contains collectionB
    */
    public func intersected
        (collection: Self,
        handler: ((element: Self.Generator.Element, index: Self.Index?, indexInCollection: Self.Index?, contains: Bool)-> Void)? = nil)
        -> Self
    {
        var results = Self()
        
        var intersectedElementsInColelction2 = Self()
        
        for element1 in self {
            let index1 = self.indexOf(element1)
            let index2 = collection.indexOf(element1)
            if !results.contains(element1) && index2 != nil {
                results.append(element1)
                intersectedElementsInColelction2.append(element1)
                handler?(element: element1, index: index1, indexInCollection: index2, contains: true)
            } else {
                handler?(element: element1, index: index1, indexInCollection: index2, contains: false)
            }
        }
        
        if let handler = handler {
            for element2 in collection {
                if !intersectedElementsInColelction2.contains(element2) {
                    let index1 = self.indexOf(element2)
                    let index2 = collection.indexOf(element2)
                    
                    handler(element: element2, index: index1, indexInCollection: index2, contains: false)
                }
            }
        }
        
        return results
    }
}
