//
//  IndexPath.swift
//  SwiftExt
//
//  Created by Manfred on 9/30/15.
//
//

public typealias IndexPathIndexable = protocol<Hashable,
    Comparable,
    SignedIntegerType>

public protocol PrimitiveIndexPathType: Hashable,
    Comparable
{
    typealias Index: IndexPathIndexable
    var indices: [Index] { get }
    
    var length: Int { get }
    
    func predecessor() -> Self
    
    func successor() -> Self
    
    static func withPrimitiveIndexPath<I: PrimitiveIndexPathType>(
        primitiveIndexPath: I)
        -> Self
}

public struct IndexPath<I: IndexPathIndexable>: PrimitiveIndexPathType {
    public typealias Index = I
    public typealias Distance = IndexPathInterval<Index>
    public var indices: [Index]
    
    public init(index: Index)      { self.init(indices: [index]) }
    public init(indices: Index...) { self.init(indices: indices) }
    
    public init(indices anArrayOfIndices: [Index])  {
        guard anArrayOfIndices.count > 0 else {
            fatalError("Empty indices is not allowed for creating IndexPath<\(Index.self)>")
        }
        indices = anArrayOfIndices
    }
    
    public static func withPrimitiveIndexPath<I : PrimitiveIndexPathType>(
        primitiveIndexPath: I) -> IndexPath<Index> {
        return self.init(
            indices: primitiveIndexPath.indices.map { Index($0.toIntMax()) })
    }
    
    public subscript (index: Int) -> Index {
        return indices[index]
    }
    
    public mutating func appendIndex(index: Index) {
        indices.append(index)
    }
    
    public mutating func removeLastIndex() -> Index {
        let last = indices.removeLast()
        return last
    }
    
    public var startIndex: Index {
        return indices.first!
    }
    
    public var endIndex: Index {
        return indices.last!
    }
    
    public var length: Int { return indices.count }
    
    public var hashValue: Int {
        return indices.map{"\($0)"}.joinWithSeparator(",").hashValue
    }
    
    public func predecessor() -> IndexPath<Index> {
        guard let lastIndex = self.indices.last else {
            fatalError("No index")
        }
        
        var indices = self.indices
        indices.removeLast()
        indices += lastIndex.predecessor()
        
        return IndexPath<Index>(indices: indices)
    }
    
    public func successor() -> IndexPath<Index> {
        guard let lastIndex = self.indices.last else {
            fatalError("No index")
        }
        
        var indices = self.indices
        indices.removeLast()
        indices += lastIndex.successor()
        
        return IndexPath<Index>(indices: indices)
    }
    
    public func advancedBy(n: Distance) -> IndexPath<Index> {
        return self + n
    }
    
    public func distanceTo(end: IndexPath<Index>) -> Distance {
        return IndexPathInterval<Index>(fromIndexPath: self, toIndexPath: end)
    }
    
    public func indexPathByAddingIndex(index: Index) -> IndexPath<Index> {
        return IndexPath<Index>(indices: indices + index)
    }
    
    public func indexPathByRemovingLastIndex(index: Index) -> IndexPath<Index>?
    {
        return indices.count == 1 ? nil :
            { var new = self; new.indices.removeLast(); return new }()
    }
}

extension IndexPath: ArrayLiteralConvertible {
    public typealias Element = Index
    public init(arrayLiteral elements: Element...) {
        self.init(indices: elements)
    }
}

public func ==<I: IndexPathIndexable>(lhs: IndexPath<I>, rhs: IndexPath<I>)
    -> Bool
{
    return lhs.indices == rhs.indices
}

public func < <I: IndexPathIndexable>(lhs: IndexPath<I>, rhs: IndexPath<I>)
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
