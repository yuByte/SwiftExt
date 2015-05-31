//
//  Remove.swift
//  Swift Extended Library
//
//  Created by Manfred Lau on 5/27/15.
//
//

import Swift

private func getAffectedIndex<I: protocol<Comparable, BidirectionalIndexType>>
    (originalIndex: I, removedIndicesCount: Int)
    -> I
{
    var affectedIndex = originalIndex
    for _ in 0..<removedIndicesCount {
        affectedIndex = affectedIndex.predecessor()
    }
    return affectedIndex
}

/*
Remove

:param:     lhs             A given string

:param:     rhs             Repeat times
*/
public func removeIndices<C : RangeReplaceableCollectionType where
    C.Generator.Element : Equatable,
    C.Index: protocol<Comparable, BidirectionalIndexType>>
    (inout collection: C, indices: [C.Index])
    -> C
{
    var removed = C()
    
    var removedIndicesCount = 0
    
    let sortedIndices = indices.sorted { $0 < $1}
    
    for eachIndex in sortedIndices {
        let finalIndex = getAffectedIndex(eachIndex, removedIndicesCount)
        let target = collection[finalIndex]
        removed.append(target)
        removedIndicesCount += 1
        collection.removeAtIndex(finalIndex)
    }
    
    return removed
}

public func remove<C : RangeReplaceableCollectionType where
    C.Generator.Element : Equatable,
    C.Index: protocol<Comparable, BidirectionalIndexType>>
    (inout collection: C, elements: C)
    -> C
{
    var indices = [Any]()
    
    for eachElement in elements {
        if let index = find(collection, eachElement) {
            indices.append(index)
        }
    }
    
    var removed = C()
    
    var removedIndicesCount = 0
    
    let sortedIndices = indices.sorted {
        if let index1 = $0 as? C.Index,
        let index2 = $1 as? C.Index{
            return index1 < index2
        }
        return true
    } as! [C.Index]
    
    for eachIndex in sortedIndices {
        let finalIndex = getAffectedIndex(eachIndex, removedIndicesCount)
        let target = collection[finalIndex]
        removed.append(target)
        removedIndicesCount += 1
        collection.removeAtIndex(finalIndex)
    }
    
    return removed
}