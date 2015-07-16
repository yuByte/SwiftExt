//
//  CollectionType+Conveniences.swift
//  Swift-Extended-Library
//
//  Created by Manfred Lau on 6/8/15.
//
//

extension CollectionType {
    /**
    To get the index cap of a given CollectionType conformed type value
    
    - parameter     x:               The CollectionType conformed type value
    
    - returns:   The index cap for x
    */
    public var indexCap: Self.Index? {
        if startIndex == endIndex {
            return nil
        } else {
            return advance(startIndex,
                distance(startIndex, endIndex) - Self.Index.Distance(1))
        }
    }
}
