//
//  Collection+MultipleMap.swift
//  SwiftExt
//
//  Created by Manfred on 9/9/15.
//
//

extension CollectionType {
    /// Return an `Array` containing the results of mapping `transform`
    /// over `self`.
    ///
    /// - Complexity: O(N).
    @warn_unused_result
    public func multipleMap<T>(
        @noescape transform: (Self.Generator.Element) throws -> [T])
        rethrows
        -> [T]
    {
        var mapped = [T]()
        
        for each in self {
            let results = try transform(each)
            for eachResult in results {
                mapped.append(eachResult)
            }
        }
        
        return mapped
    }
}