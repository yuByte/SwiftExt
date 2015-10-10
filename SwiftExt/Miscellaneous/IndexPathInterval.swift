//
//  IndexPathInterval.swift
//  SwiftExt
//
//  Created by Manfred on 10/1/15.
//
//

public typealias PrimitiveIndexPathInterval = protocol<Hashable,
    Comparable>

public struct IndexPathInterval<I: IndexPathIndexable>:
    PrimitiveIndexPathInterval
{
    public typealias Index = I
    public typealias Distance = IndexPathInterval<Index>
    public var indices: [Index]
    
    public subscript (index: Int) -> Index {
        return indices[index]
    }
    
    public var length: Int { return indices.count }
    
    public init(var fromIndexPath: IndexPath<Index>,
        var toIndexPath: IndexPath<Index>)
    {
        let maxLength = max(fromIndexPath.length, toIndexPath.length)
        
        for _ in fromIndexPath.length..<maxLength {
            fromIndexPath.indices.append(0)
        }
        
        for _ in toIndexPath.length..<maxLength {
            toIndexPath.indices.append(0)
        }
        
        var indicesDiff = [Index]()
        
        for (from, to) in zip(fromIndexPath.indices, toIndexPath.indices) {
            indicesDiff.append(from - to)
        }
        
        indices = indicesDiff
        hashValue = indicesDiff.map{"\($0)"}.joinWithSeparator(",").hashValue
    }
    
    public var hashValue: Int
}

public func + <I: IndexPathIndexable>(var lhs: IndexPath<I>,
    var rhs: IndexPathInterval<I>)
    -> IndexPath<I>
{
    let maxLength = max(lhs.length, rhs.length)
    
    for _ in (maxLength - lhs.length)..<maxLength {
        lhs.indices.append(0)
    }
    
    for _ in (maxLength - rhs.length)..<maxLength {
        rhs.indices.append(0)
    }
    
    var indicesSum = [I]()
    
    for (from, to) in zip(lhs.indices, rhs.indices) {
        indicesSum.append(from + to)
    }
    
    return IndexPath<I>(indices: indicesSum)
}

public func ==<I: IndexPathIndexable>(lhs: IndexPathInterval<I>,
    rhs: IndexPathInterval<I>)
    -> Bool
{
    return lhs.indices == rhs.indices
}

public func < <I: IndexPathIndexable>(lhs: IndexPathInterval<I>,
    rhs: IndexPathInterval<I>)
    -> Bool
{
    if lhs.length < rhs.length {
        return true
    } else if lhs.length > lhs.length {
        return false
    } else {
        for (lhs, rhs) in zip(lhs.indices, rhs.indices) {
            if lhs == rhs {
                continue
            } else {
                return lhs < rhs
            }
        }
        return false
    }
}