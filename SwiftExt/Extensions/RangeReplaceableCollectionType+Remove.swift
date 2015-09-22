//
//  RangeReplaceableCollectionType+Remove.swift
//  SwiftExt
//
//  Created by Manfred Lau on 5/27/15.
//
//

extension RangeReplaceableCollectionType where Index: Comparable {
    mutating public func removeIndicesInPlace(indices: [Self.Index]) -> Self {
        guard indices.count > 0 else { return Self() }
        
        var removed = Self()
        
        let sortedIndices = indices.sort { $0 < $1}
        
        for eachIndex in sortedIndices {
            let finalIndex = eachIndex.advancedBy(
                removed.endIndex.distanceTo(removed.startIndex))
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
    mutating public func removeInPlace(elements: Self) -> Self {
        guard elements.count > 0 else { return Self() }
        
        var indicesToBeRemoved: [Self.Index] = []
        
        for eachElement in elements {
            if let index = indexOf(eachElement) {
                indicesToBeRemoved.append(index)
            }
        }
        
        var removed = Self()
        
        let sortedIndicesToBeRemoved = indicesToBeRemoved.sort {$0 < $1}
        
        for eachIndex in sortedIndicesToBeRemoved {
            let finalIndex = eachIndex.advancedBy(
                removed.endIndex.distanceTo(removed.startIndex))
            let target = self[finalIndex]
            removed.append(target)
            removeAtIndex(finalIndex)
        }
        
        return removed
    }
}