//
//  CollectionType+Diff.swift
//  Swift Extended Library
//
//  Created by Manfred Lau on 10/13/14.
//
//

/**
Sequence difference.

- Stationary: Indicates a sequence element's position is not changed.

- Added: Indicates a sequence element is newly inserted.

- Deleted: Indicates a sequence element is deleted.

- Moved: Indicates a sequence element's position is moved.

- Changed: Indicates a sequence element's content is changed, which judged by your custom comparator.
*/
public struct CollectionDiff: OptionSetType,
CustomDebugStringConvertible, CustomStringConvertible, Hashable
{
    public typealias RawValue = UInt
    
    public let rawValue: RawValue
    
    public init(rawValue value: RawValue) { self.rawValue = value }
    
    public static var Stationary    = CollectionDiff(rawValue: 1 << 0)
    public static var Added         = CollectionDiff(rawValue: 1 << 1)
    public static var Deleted       = CollectionDiff(rawValue: 1 << 2)
    public static var Moved         = CollectionDiff(rawValue: 1 << 3)
    public static var Changed       = CollectionDiff(rawValue: 1 << 4)
    
    public static var All: CollectionDiff =
        [.Stationary, .Added, .Deleted, .Moved, .Changed]
    
    public var hashValue: Int { return Int(rawValue) }
    
    public var description: String {
        get {
            var descriptions = [String]()
            if contains(.Stationary) {
                descriptions.append("Stationary")
            }
            if contains(.Added) {
                descriptions.append("Added")
            }
            if contains(.Deleted) {
                descriptions.append("Deleted")
            }
            if contains(.Changed) {
                descriptions.append("Moved")
            }
            if contains(.Moved) {
                descriptions.append("Moved")
            }
            return "<\(self.dynamicType): " + " | ".join(descriptions) + ">"
        }
    }
    
    public var debugDescription: String {
        get {
            return description
        }
    }
}

extension CollectionType {
    public typealias CollectionDiffHandler = (
        change: CollectionDiff,
        fromIndex: Index?, fromElement: Generator.Element?,
        toIndex: Index?, toElement: Generator.Element?) -> Void
    public typealias CollectionElementComparator = (Generator.Element,
        Generator.Element) -> Bool
    /**
    Diff two arbitrary sequences by using custom equality and unchange comparator.
    
    - parameter     fromSequence:            The original sequence
    
    - parameter     toSequence:              The changed sequence
    
    - parameter     differences:             A SequenceDifference value which indicates what differences shall be inspected
    
    - parameter     equalComparator:         The comparator handles equality checking
    
    - parameter     unchangedComparator:     The comparator handles unchange checking
    
    - parameter     changesHandler:          The handler being used to handle captured difference
    
    */
    public func diff(comparedCollection: Self, differences: CollectionDiff,
        indexComparator: CollectionElementComparator,
        contentComparator: CollectionElementComparator,
        withHandler diffHandler: CollectionDiffHandler)
    {
        typealias Element = Generator.Element
        typealias Index = Self.Index
        
        let shouldInspectStationary = differences.contains(.Stationary)
        let shouldInspectInserted   = differences.contains(.Added)
        let shouldInspectDeleted    = differences.contains(.Deleted)
        let shouldInspectMoved      = differences.contains(.Moved)
        let shouldInspectChanged    = differences.contains(.Changed)
        
        var wrappedFromElements =
            [CollectionElementWrapper<Element, Index>]()
        var wrappedToElements =
            [CollectionElementWrapper<Element, Index>]()
        
        let shouldWrap = (shouldInspectInserted ||
            shouldInspectStationary ||
            shouldInspectDeleted || 
            shouldInspectMoved)
        
        if shouldWrap {
            var fromIndex = self.startIndex
            for fromElement in self {
                let wrappedElement =
                    CollectionElementWrapper<Element, Index>(fromIndex,
                        fromElement, indexComparator)
                wrappedFromElements.append(wrappedElement)
                fromIndex = fromIndex.successor()
            }
            
            var toIndex = comparedCollection.startIndex
            for toElement in comparedCollection {
                let wrappedElement =
                    CollectionElementWrapper<Element, Index>(toIndex,
                        toElement, indexComparator)
                wrappedToElements.append(wrappedElement)
                toIndex = toIndex.successor()
            }
        }
        
        if (shouldInspectInserted ||
            shouldInspectStationary ||
            shouldInspectMoved)
        {
            // Traversal to sequence to find inserted, stationary and moved
            for wrappedToElement in wrappedToElements {
                let wrappedFromElement = wrappedFromElements.filter(
                    {$0 == wrappedToElement}).first
                let fromIndex = wrappedFromElement?.index
                
                if shouldInspectInserted {
                    if fromIndex == nil {
                        diffHandler(change: .Added,
                            fromIndex: nil,
                            fromElement: nil,
                            toIndex: wrappedToElement.index,
                            toElement: wrappedToElement.element)
                    }
                }
                
                if let fromIndex = fromIndex {
                    let toIndex = wrappedToElement.index
                    
                    var changes: CollectionDiff = []
                    
                    if shouldInspectChanged {
                        if !contentComparator(
                            wrappedToElement.element,
                            wrappedFromElement!.element)
                        {
                            changes += .Changed
                        }
                    }
                    
                    if fromIndex == toIndex {
                        if (shouldInspectStationary ||
                            shouldInspectChanged)
                        {
                            diffHandler(
                                change: changes + .Stationary,
                                fromIndex: wrappedFromElement!.index,
                                fromElement: wrappedFromElement!.element,
                                toIndex: wrappedToElement.index,
                                toElement: wrappedToElement.element)
                        }
                    } else {
                        if (shouldInspectMoved ||
                            shouldInspectChanged)
                        {
                            diffHandler(change: changes + .Moved,
                                fromIndex: wrappedFromElement!.index,
                                fromElement: wrappedFromElement!.element,
                                toIndex: wrappedToElement.index,
                                toElement: wrappedToElement.element)
                        }
                    }
                }
                
                wrappedToElement.traversed = true
                if wrappedFromElement != nil {
                    wrappedFromElement!.traversed = true
                }
            }
        }
        
        if shouldInspectDeleted {
            for wrappedFromElement in wrappedFromElements {
                let toIndex = wrappedToElements.indexOf(
                    wrappedFromElement)
                
                if toIndex == nil {
                    diffHandler(change: .Deleted,
                        fromIndex: wrappedFromElement.index,
                        fromElement: wrappedFromElement.element,
                        toIndex: nil,
                        toElement: nil)
                }
                
                wrappedFromElement.traversed = true
                
                if toIndex != nil {
                    let wrappedToElement = (wrappedToElements[toIndex!])
                    wrappedToElement.traversed = true
                }
            }
        }
    }
}

extension CollectionType where Generator.Element : Equatable {
    public typealias EquatableElementsCollectionDiffHandler = (
        change: CollectionDiff,
        fromIndex: Index?, fromElement: Generator.Element?,
        toIndex: Index?, toElement: Generator.Element?) -> Void
    public typealias EquatableElementsCollectionElementComparator = (
        Generator.Element, Generator.Element) -> Bool
    
    /**
    Diff two sequences whose generator's element type conforms to Equatable protocol.
    
    - parameter     fromSequence:            The original sequence
    
    - parameter     toSequence:              The changed sequence
    
    - parameter     differences:             A SequenceDifference value which indicates what differences shall be inspected
    
    - parameter     changesHandler:          The handler being used to handle captured difference
    
    */
    public func diff(comparedCollection: Self,
        differences: CollectionDiff,
        contentComparator:
            EquatableElementsCollectionElementComparator = {$0 == $1},
        withHandler diffHandler: EquatableElementsCollectionDiffHandler)
    {
        diff(comparedCollection,
            differences: differences,
            indexComparator: {$0 == $1},
            contentComparator: contentComparator,
            withHandler: diffHandler)
    }
}

internal class CollectionElementWrapper<Element, Index>: Equatable, CustomStringConvertible {
    // typealias Element = C.Generator.Element
    // typealias Index = C.Index
    internal var traversed = false
    internal let index: Index
    internal let element: Element
    internal let equalityComparator: (Element, Element) -> Bool
    internal init(_ theIndex: Index, _ theEmenet: Element,
        _ theEqualityComparator: (Element, Element) -> Bool)
    {
        index = theIndex
        element = theEmenet
        equalityComparator = theEqualityComparator
    }
    
    internal var description: String {
        return "<\(CollectionElementWrapper.self); Index = \(index); Element = \(element); Traversed = \(traversed)>>"
    }
}

internal func == <Element, Index>
    (left: CollectionElementWrapper<Element, Index>,
    right: CollectionElementWrapper<Element, Index>) -> Bool
{
    return (left.traversed == right.traversed &&
        left.equalityComparator(left.element, right.element))
}
