//
//  Remove.swift
//  Swift-Extended-Library
//
//  Created by Manfred Lau on 5/27/15.
//
//

extension RangeReplaceableCollectionType where Index: Comparable {
    mutating public func removeIndices(indices: [Self.Index]) -> Self {
        var removed = Self()
        
        let sortedIndices = indices.sort { $0 < $1}
        
        for eachIndex in sortedIndices {
            let finalIndex = advance(eachIndex,
                distance(removed.endIndex, removed.startIndex))
            let target = self[finalIndex]
            removed.append(target)
            removeAtIndex(finalIndex)
        }
        
        return removed
    }
}

extension RangeReplaceableCollectionType where
    Generator.Element : Equatable,
    Index: Comparable
{
    mutating public func remove(elements: Self) -> Self {
        var indicesToBeRemoved: [Self.Index] = []
        
        for eachElement in elements {
            if let index = indexOf(eachElement) {
                indicesToBeRemoved.append(index)
            }
        }
        
        var removed = Self()
        
        let sortedIndicesToBeRemoved = indicesToBeRemoved.sort {$0 < $1}
        
        for eachIndex in sortedIndicesToBeRemoved {
            let finalIndex = advance(eachIndex,
                distance(removed.endIndex, removed.startIndex))
            let target = self[finalIndex]
            removed.append(target)
            removeAtIndex(finalIndex)
        }
        
        return removed
    }
}