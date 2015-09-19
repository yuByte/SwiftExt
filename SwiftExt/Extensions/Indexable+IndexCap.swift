//
//  Indexable+Conveniences.swift
//  SwiftExt
//
//  Created by Manfred Lau on 6/8/15.
//
//

extension Indexable {
    /**
    To get the index cap of a given CollectionType conformed type value
    
    - parameter     x:               The CollectionType conformed type value
    
    - returns:   The index cap for x
    */
    public var indexCap: Self.Index? {
        if startIndex == endIndex {
            return nil
        } else {
            let distance = startIndex.distanceTo(endIndex) - Index.Distance(1)
            return startIndex.advancedBy(distance)
        }
    }
}
