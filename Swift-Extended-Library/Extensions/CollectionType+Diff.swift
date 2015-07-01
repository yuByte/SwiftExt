//
//  CollectionType+Diff.swift
//  Swift-Extended-Library
//
//  Created by Manfred Lau on 10/13/14.
//
//

/**
Sequence difference.

- Stationary: Indicates a collection element's position is not changed.

- Added: Indicates a collection element is newly inserted.

- Deleted: Indicates a collection element is deleted.

- Moved: Indicates a collection element's position is moved.

- Changed: Indicates a collection element's content is changed, which judged by your custom comparator.
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
        toIndex: Index?, toElement: Generator.Element?,
        changed: Bool?) -> Void
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
        self.diffFrom(comparedCollection,
            equalityComparator: indexComparator,
            contentComparator: contentComparator
            ).handleChanges(differences, handler: diffHandler
            ).commit()
    }
}

extension CollectionType where Generator.Element : Equatable {
    public typealias EquatableElementsCollectionDiffHandler = (
        change: CollectionDiff,
        fromIndex: Index?, fromElement: Generator.Element?,
        toIndex: Index?, toElement: Generator.Element?, changed: Bool?) -> Void
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

final internal class CollectionElementWrapper<E, I>: Equatable, CustomStringConvertible {
    internal typealias Element = E
    internal typealias Index = I
    
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
    
    internal class func wrapCollection<C: CollectionType>(collection: C,
        equalityComparator: (C.Generator.Element, C.Generator.Element) -> Bool)
        -> [CollectionElementWrapper<C.Generator.Element, C.Index>]
    {
        typealias ElementWrapper = CollectionElementWrapper<C.Generator.Element, C.Index>
        var wrappedElements = [ElementWrapper]()
        var index = collection.startIndex
        for element in collection {
            let wrappedElement = ElementWrapper(index,
                element, equalityComparator)
            wrappedElements.append(wrappedElement)
            index = index.successor()
        }
        return wrappedElements
    }
}

internal func == <Element, Index>
    (left: CollectionElementWrapper<Element, Index>,
    right: CollectionElementWrapper<Element, Index>) -> Bool
{
    return (left.traversed == right.traversed &&
        left.equalityComparator(left.element, right.element))
}
