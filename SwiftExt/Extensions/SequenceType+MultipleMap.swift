//
//  Collection+MultipleMap.swift
//  SwiftExt
//
//  Created by Manfred on 9/9/15.
//
//

extension SequenceType {
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
    
    /// Return an `Array` containing the results of mapping `transform`
    /// over `self`. This function can be stopped while in excution.
    ///
    /// - Complexity: O(N).
    @warn_unused_result
    public func multipleMapStoppably<T>(
        @noescape transform: (Self.Generator.Element, inout Bool) throws -> [T])
        rethrows
        -> [T]
    {
        var mapped = [T]()
        
        var shouldStop = false
        
        for each in self {
            let results = try transform(each, &shouldStop)
            for eachResult in results {
                mapped.append(eachResult)
            }
            if shouldStop { break }
        }
        
        return mapped
    }
}