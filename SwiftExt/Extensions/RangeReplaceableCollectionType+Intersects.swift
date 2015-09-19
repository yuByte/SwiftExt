//
//  RangeReplaceableCollectionType+Intersects.swift
//  SwiftExt
//
//  Created by Manfred on 9/19/15.
//
//

extension RangeReplaceableCollectionType where Generator.Element : Equatable {
    /**
    To check if a collection insertects with an other whose generator's element type conforms to Equatable protocol.
    
    - parameter     collection:     The collection to be intersected with
    
    - returns:      A result indicates if collectionA contains collectionB
    */
    public func intersect
        (collection: Self,
        handler: ((element: Self.Generator.Element,
        index: Self.Index?,
        indexInCollection: Self.Index?,
        contains: Bool)-> Void)? = nil)
        -> Self
    {
        var results = Self()
        
        var intersectedElementsInColelction2 = Self()
        
        for selfElement in self {
            let indexSelf = self.indexOf(selfElement)
            let indexCollection = collection.indexOf(selfElement)
            if !results.contains(selfElement) && indexCollection != nil {
                results.append(selfElement)
                intersectedElementsInColelction2.append(selfElement)
                handler?(element: selfElement, index: indexSelf,
                    indexInCollection: indexCollection, contains: true)
            } else {
                handler?(element: selfElement, index: indexSelf,
                    indexInCollection: indexCollection, contains: false)
            }
        }
        
        if let handler = handler {
            for elementSelf in collection {
                if !intersectedElementsInColelction2.contains(elementSelf)
                {
                    let indexSelf = self.indexOf(elementSelf)
                    let indexCollection = collection.indexOf(elementSelf)
                    
                    handler(element: elementSelf, index: indexSelf,
                        indexInCollection: indexCollection,
                        contains: false)
                }
            }
        }
        
        return results
    }
}