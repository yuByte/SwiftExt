//
//  CollectionType+Merge.swift
//  SwiftExt
//
//  Created by Manfred on 10/20/15.
//
//

extension RangeReplaceableCollectionType where Generator.Element: Comparable {
    public func merge(mergedCollection: Self) -> Self {
        return merge(mergedCollection,
            equalityPredicate: {$0 == $1},
            ascendingPreidicate: {$0 < $1})
    }
    
    public mutating func mergeInPlace(mergedCollection: Self) {
        self = merge(mergedCollection,
            equalityPredicate: {$0 == $1},
            ascendingPreidicate: {$0 < $1})
    }
}

extension RangeReplaceableCollectionType where Generator.Element: Equatable {
    public func merge(mergedCollection: Self,
        ascendingPreidicate: ((Generator.Element, Generator.Element) -> Bool)?
        = nil)
        -> Self
    {
        return merge(mergedCollection,
            equalityPredicate: {$0 == $1},
            ascendingPreidicate: ascendingPreidicate)
    }
    
    public mutating func mergeInPlace(mergedCollection: Self,
        ascendingPreidicate: ((Generator.Element, Generator.Element) -> Bool)?
        = nil)
    {
        self = merge(mergedCollection,
            equalityPredicate: {$0 == $1},
            ascendingPreidicate: ascendingPreidicate)
    }
}

extension RangeReplaceableCollectionType {
    public func merge(mergedCollection: Self,
        equalityPredicate: (Generator.Element, Generator.Element) -> Bool,
        ascendingPreidicate: ((Generator.Element, Generator.Element) -> Bool)?
        = nil)
        -> Self
    {
        if let ascendingPreidicate = ascendingPreidicate{
            return _merge(mergedCollection,
                equalityPredicate: equalityPredicate,
                ascendingPreidicate: ascendingPreidicate)
        } else {
            return _merge(mergedCollection,
                equalityPredicate: equalityPredicate)
        }
    }
    
    public mutating func mergeInPlace(mergedCollection: Self,
        equalityPredicate: (Generator.Element, Generator.Element) -> Bool,
        ascendingPreidicate: ((Generator.Element, Generator.Element) -> Bool)?
        = nil)
    {
        if let ascendingPreidicate = ascendingPreidicate{
            self = _merge(mergedCollection,
                equalityPredicate: equalityPredicate,
                ascendingPreidicate: ascendingPreidicate)
        } else {
            self = _merge(mergedCollection,
                equalityPredicate: equalityPredicate)
        }
    }
}

extension RangeReplaceableCollectionType {
    private func _merge(mergedCollection: Self,
        equalityPredicate: (Generator.Element, Generator.Element) -> Bool,
        ascendingPreidicate: (Generator.Element, Generator.Element) -> Bool)
        -> Self
    {
        let mergeQueue = BiRailMergeQueue<Generator.Element>(
            mergingCollection: self,
            mergedCollection: mergedCollection,
            ascendingPredicate: ascendingPreidicate,
            equalityPredicate: equalityPredicate)
        
        var merged = Self()
        
        while let dequeued = mergeQueue.dequeue() {
            merged.append(dequeued)
        }
        
        return merged
    }
    
    private func _merge(mergedCollection: Self,
        equalityPredicate: (Generator.Element, Generator.Element) -> Bool)
        -> Self
    {
        var copiedSelf = self
        
        for each in mergedCollection {
            if !copiedSelf.contains({ equalityPredicate(each, $0)}) {
                copiedSelf.append(each)
            }
        }
        
        return copiedSelf
    }
}

private class BiRailMergeQueue<E> {
    typealias Element = E
    var mergingRail: [Element]
    var mergedRail: [Element]
    
    let isAscending: (Element, Element) -> Bool
    let isEqual: (Element, Element) -> Bool
    
    init<C: CollectionType where C.Generator.Element == E>
        (mergingCollection: C,
        mergedCollection: C,
        ascendingPredicate: (Element, Element) -> Bool,
        equalityPredicate: (Element, Element) -> Bool)
    {
        self.isAscending = ascendingPredicate
        self.isEqual = equalityPredicate
        
        let sortedA = mergingCollection.sort(ascendingPredicate)
        let sortedB = mergedCollection.sort(ascendingPredicate)
        
        mergingRail = sortedA
        mergedRail = sortedB
    }
    
    func dequeue() -> Element? {
        let headOfMergingRail = mergingRail.first
        let headOfMergedRail = mergedRail.first
        
        switch (headOfMergingRail, headOfMergedRail) {
        case let (.None, .Some(headOfMergedRail)):
            mergedRail.removeFirst()
            return headOfMergedRail
        case let (.Some(headOfMergingRail), .None):
            mergingRail.removeFirst()
            return headOfMergingRail
        case let (.Some(headOfMergingRail), .Some(headOfMergedRail)):
            if isEqual(headOfMergingRail, headOfMergedRail) {
                mergingRail.removeFirst()
                mergedRail.removeFirst()
                return headOfMergingRail
            } else {
                if isAscending(headOfMergingRail, headOfMergedRail) {
                    mergingRail.removeFirst()
                    return headOfMergingRail
                } else {
                    mergedRail.removeFirst()
                    return headOfMergedRail
                }
            }
        default:
            return nil
        }
    }
}
