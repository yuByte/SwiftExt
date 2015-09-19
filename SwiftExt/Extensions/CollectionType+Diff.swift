//
//  CollectionType+Diff.swift
//  SwiftExt
//
//  Created by Manfred on 6/30/15.
//
//

/**
Collection difference.

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
    public static var Inserted      = CollectionDiff(rawValue: 1 << 1)
    public static var Deleted       = CollectionDiff(rawValue: 1 << 2)
    public static var Moved         = CollectionDiff(rawValue: 1 << 3)
    public static var Changed       = CollectionDiff(rawValue: 1 << 4)
    
    public static var All: CollectionDiff =
    [.Stationary, .Inserted, .Deleted, .Moved, .Changed]
    
    public var hashValue: Int { return Int(rawValue) }
    
    public var description: String {
        get {
            var descriptions = [String]()
            if contains(.Stationary) {
                descriptions.append("Stationary")
            }
            if contains(.Inserted) {
                descriptions.append("Inserted")
            }
            if contains(.Deleted) {
                descriptions.append("Deleted")
            }
            if contains(.Changed) {
                descriptions.append("Changed")
            }
            if contains(.Moved) {
                descriptions.append("Moved")
            }
            return "<\(self.dynamicType): " +
                descriptions.joinWithSeparator(" | ") + ">"
        }
    }
    
    public var debugDescription: String { return description }
}

//AMRK: - Collection Type Extension
extension CollectionType {
    public var diffAndHandle: CollectionDiffer<Self> {
        return CollectionDiffer(from: self)
    }
}

extension CollectionType where Generator.Element: Equatable {
    public var diffAndHandle: CollectionDiffer<Self> {
        return CollectionDiffer(from: self,
            equalityComparator: {$0 == $1},
            contentComparator: {$0 == $1})
    }
}

//AMRK: - Collection Differ
final public class CollectionDiffer<C: CollectionType> {
    public typealias Collection = C
    public typealias Element = C.Generator.Element
    public typealias Index = C.Index
    
    public typealias ElementComparator =
        (Element, Element) -> Bool
    
    private var inspectedDiffs: CollectionDiff = []
    
    private let fromCollection: Collection
    
    private init(from: Collection,
        equalityComparator: ElementComparator? = nil,
        contentComparator: ElementComparator? = nil)
    {
        fromCollection = from
        self.equalityComparator = equalityComparator
        self.contentComparator = contentComparator
    }
    
    private var diffHandlers =
        [CollectionDiff: [CollectionDiffHandler<Collection>]]()
    
    private var equalityComparator: ElementComparator?
    private var contentComparator: ElementComparator?
    
    public func to(collection: Collection) {
        let shouldDiff = inspectedDiffs != [] &&
            (!fromCollection.isEmpty || !collection.isEmpty)
        
        if shouldDiff { diffToCollection(collection) }
    }
    
    private func diffToCollection(toCollection: Collection) {
        typealias ElementWrapper = CollectionElementWrapper<Collection>
        
        guard let equalityComparator = self.equalityComparator else {
            assertionFailure("Equality comparator shall not be nil")
            return
        }
        
        guard let contentComparator = self.contentComparator == nil ?
            self.equalityComparator :
            self.contentComparator
            else
        {
            assertionFailure("Content and equality comparator shall not be nil at the same time")
            return
        }
        
        let fromElementsIterativeDiff = CollectionDiff.Deleted
        
        let toElementsIterativeDiff: CollectionDiff = [
            .Stationary, .Inserted, .Moved, .Changed]
        
        let wrappedFromElements = ElementWrapper.wrapCollection(
            fromCollection, equalityComparator: equalityComparator)
        
        let wrappedToElements = ElementWrapper.wrapCollection(
            toCollection, equalityComparator: equalityComparator)
        
        let shouldInspectChanged = inspectedDiffs.contains(.Changed)
        
        // Traversal to sequence to find inserted, stationary and moved
        for wrappedToElement in wrappedToElements {
            let wrappedFromElement = wrappedFromElements.filter(
                {$0 == wrappedToElement}).first
            let fromIndex = wrappedFromElement?.index
            let fromElement = wrappedFromElement?.element
            let toIndex = wrappedToElement.index
            let toElement = wrappedToElement.element
            
            let changed: Bool? = {
                if let fromElement = fromElement {
                    return shouldInspectChanged &&
                        !contentComparator(fromElement, toElement)
                }
                return nil
                }()
            
            for (diff, handlers) in diffHandlers
                where !toElementsIterativeDiff.intersect(diff).isEmpty
            {
                for eachHandler in handlers {
                    eachHandler.handleDiff(
                        fromIndex: fromIndex,
                        fromElement: fromElement,
                        toIndex: toIndex,
                        toElement: toElement,
                        changed: changed)
                }
            }
            
            wrappedFromElement?.traversed = true
            wrappedToElement.traversed = true
        }
        
        for wrappedFromElement in wrappedFromElements
            where !wrappedFromElement.traversed
        {
            let wrappedToElement = wrappedToElements.filter(
                {$0 == wrappedFromElement}).first
            
            let toIndex = wrappedToElement?.index
            let toElement = wrappedToElement?.element
            
            let fromIndex = wrappedFromElement.index
            let fromElement = wrappedFromElement.element
            
            for (diff, handlers) in diffHandlers
                where !fromElementsIterativeDiff.intersect(diff).isEmpty
            {
                for eachHandler in handlers {
                    eachHandler.handleDiff(
                        fromIndex: fromIndex,
                        fromElement: fromElement,
                        toIndex: toIndex,
                        toElement: toElement,
                        changed: nil)
                }
            }
            
            wrappedFromElement.traversed = true
            wrappedToElement?.traversed = true
        }
    }
}

//MARK: Collection Differ Comparator Commiting Methods
extension CollectionDiffer {
    public func withEqualityComparator(comparator: ElementComparator)
        -> CollectionDiffer<Collection>
    {
        equalityComparator = comparator
        return self
    }
    
    public func withContentComparator(comparator: ElementComparator)
        -> CollectionDiffer<Collection>
    {
        contentComparator = comparator
        return self
    }
}

//MARK: Collection Differ Handler Commiting Methods
extension CollectionDiffer {
    public func insertion(
        handler: CollectionInsertionHandler<Collection>.Handler)
        -> CollectionDiffer<Collection>
    {
        let handler = CollectionInsertionHandler<Collection>(
            handler: handler)
        appendDiffHandler(handler, withDiff: handler.diff)
        return self
    }
    
    public func deletion(
        handler: CollectionDeletionHandler<Collection>.Handler)
        -> CollectionDiffer<Collection>
    {
        let handler = CollectionDeletionHandler<Collection>(
            handler: handler)
        appendDiffHandler(handler, withDiff: handler.diff)
        return self
    }
    
    public func moving(
        handler: CollectionMovingHandler<Collection>.Handler)
        -> CollectionDiffer<Collection>
    {
        let handler = CollectionMovingHandler<Collection>(
            handler: handler)
        appendDiffHandler(handler, withDiff: handler.diff)
        return self
    }
    
    public func movingWithContentChange(
        handler: CollectionMovingWithChangeHandler<Collection>.Handler)
        -> CollectionDiffer<Collection>
    {
        let handler = CollectionMovingWithChangeHandler<Collection>(
            handler: handler)
        appendDiffHandler(handler, withDiff: handler.diff)
        return self
    }
    
    public func stationary(
        handler: CollectionStationaryHandler<Collection>.Handler)
        -> CollectionDiffer<Collection>
    {
        let handler = CollectionStationaryHandler<Collection>(
            handler: handler)
        appendDiffHandler(handler, withDiff: handler.diff)
        return self
    }
    
    public func stationaryWithContentChange(
        handler:
        CollectionStationaryWithChangeHandler<Collection>.Handler)
        -> CollectionDiffer<Collection>
    {
        let handler = CollectionStationaryWithChangeHandler<Collection>(
            handler: handler)
        appendDiffHandler(handler, withDiff: handler.diff)
        return self
    }
    
    public func contentChange(
        handler: CollectionChangedHandler<Collection>.Handler)
        -> CollectionDiffer<Collection>
    {
        let handler = CollectionChangedHandler<Collection>(
            handler: handler)
        appendDiffHandler(handler, withDiff: handler.diff)
        return self
    }
    
    public func changes(changes: CollectionDiff,
        handler: CollectionMetaChangesHandler<Collection>.Handler)
        -> CollectionDiffer<Collection>
    {
        let handler = CollectionMetaChangesHandler<Collection>(
            diff: changes, handler: handler)
        appendDiffHandler(handler, withDiff: handler.diff)
        return self
    }
    
    private func appendDiffHandler(
        handler: CollectionDiffHandler<Collection>,
        withDiff diff: CollectionDiff)
    {
        do {
            try diff.validate()
            
            inspectedDiffs += diff
            if var handlerContainer = diffHandlers[diff] {
                handlerContainer.append(handler)
                diffHandlers[diff] = handlerContainer
            } else {
                diffHandlers[diff] = [handler]
            }
            
        } catch CollectionDiff.Error.ValidateError {
            assertionFailure("Diff is not valid: \(diff)")
        } catch let error {
            assertionFailure("Diff is not valid: \(error)")
        }
        
    }
}

//MARK: - Collection Diffing Infrastructure
private let validDiffs: [CollectionDiff] = [
    .Stationary,
    .Inserted,
    .Deleted,
    .Moved,
    .Changed,
    [.Stationary, .Changed],
    [.Moved, .Changed],
    .All
]

extension CollectionDiff {
    private enum Error: ErrorType {
        case ValidateError
    }
    
    private func validate () throws {
        if !validDiffs.contains(self) {
            throw Error.ValidateError
        }
    }
}

//MARK: - Collection Diff Handler
private class CollectionDiffHandler<C: CollectionType> {
    typealias Collection = C
    typealias Element = C.Generator.Element
    typealias Index = C.Index
    
    let diff: CollectionDiff
    init(diff: CollectionDiff) { self.diff = diff }
    
    func handleDiff(fromIndex fromIndex: Index?,
        fromElement: Element?,
        toIndex: Index?,
        toElement: Element?,
        changed: Bool?)
    {
        assertionFailure("You must override this method without calling super")
    }
}

final public class CollectionInsertionHandler<C: CollectionType>:
    CollectionDiffHandler<C>
{
    public typealias Handler = (toIndex: Index, toElement: Element) -> Void
    private let handler: Handler
    private init(handler: Handler) {
        self.handler = handler
        super.init(diff: .Inserted)
    }
    
    private override func handleDiff(fromIndex fromIndex: Index?,
        fromElement: Element?,
        toIndex: Index?,
        toElement: Element?,
        changed: Bool?)
    {
        switch (fromIndex, fromElement, toIndex, toElement, changed) {
        case let (nil, nil, .Some(toIndex), .Some(toElement), nil):
            handler(toIndex: toIndex, toElement: toElement)
        default:    return
        }
    }
}

final public class CollectionDeletionHandler<C: CollectionType>:
    CollectionDiffHandler<C>
{
    public typealias Handler = (fromIndex: Index, fromElement: Element) -> Void
    private let handler: Handler
    private init(handler: Handler) {
        self.handler = handler
        super.init(diff: .Deleted)
    }
    
    private override func handleDiff(fromIndex fromIndex: Index?,
        fromElement: Element?,
        toIndex: Index?,
        toElement: Element?,
        changed: Bool?)
    {
        switch (fromIndex, fromElement, toIndex, toElement, changed) {
        case let (.Some(fromIndex), .Some(fromElement), nil, nil, nil):
            handler(fromIndex: fromIndex, fromElement: fromElement)
        default:    return
        }
    }
}

final public class CollectionMovingHandler<C: CollectionType>:
    CollectionDiffHandler<C>
{
    public typealias Handler = (fromIndex: Index, fromElement: Element,
        toIndex: Index, toElement: Element) -> Void
    private let handler: Handler
    private init(handler: Handler) {
        self.handler = handler
        super.init(diff: .Moved)
    }
    
    private override func handleDiff(fromIndex fromIndex: Index?,
        fromElement: Element?,
        toIndex: Index?,
        toElement: Element?,
        changed: Bool?)
    {
        switch (fromIndex, fromElement, toIndex, toElement, changed) {
        case let (.Some(fromIndex), .Some(fromElement), .Some(toIndex),
            .Some(toElement), _) where fromIndex != toIndex :
            handler(fromIndex: fromIndex, fromElement: fromElement,
                toIndex: toIndex, toElement: toElement)
        default:    return
        }
    }
}

final public class CollectionMovingWithChangeHandler<C: CollectionType>:
    CollectionDiffHandler<C>
{
    public typealias Handler = (fromIndex: Index, fromElement: Element,
        toIndex: Index, toElement: Element,
        changed: Bool) -> Void
    private let handler: Handler
    private init(handler: Handler) {
        self.handler = handler
        super.init(diff: [.Moved, .Changed])
    }
    
    private override func handleDiff(fromIndex fromIndex: Index?,
        fromElement: Element?,
        toIndex: Index?,
        toElement: Element?,
        changed: Bool?)
    {
        switch (fromIndex, fromElement, toIndex, toElement, changed) {
        case let (.Some(fromIndex), .Some(fromElement), .Some(toIndex),
            .Some(toElement), .Some(changed)) where fromIndex != toIndex :
            
            handler(fromIndex: fromIndex, fromElement: fromElement,
                toIndex: toIndex, toElement: toElement,
                changed: changed)
        default:    return
        }
    }
}

final public class CollectionStationaryHandler<C: CollectionType>:
    CollectionDiffHandler<C>
{
    public typealias Handler = (index: Index, element: Element) -> Void
    private let handler: Handler
    private init(handler: Handler) {
        self.handler = handler
        super.init(diff: .Stationary)
    }
    
    private override func handleDiff(fromIndex fromIndex: Index?,
        fromElement: Element?,
        toIndex: Index?,
        toElement: Element?,
        changed: Bool?)
    {
        switch (fromIndex, fromElement, toIndex, toElement, changed) {
        case let (.Some(fromIndex), .Some(fromElement), .Some(toIndex),
            .Some(_), _) where fromIndex == toIndex :
            
            handler(index: fromIndex, element: fromElement)
        default:    return
        }
    }
}

final public class CollectionStationaryWithChangeHandler<
    C: CollectionType>: CollectionDiffHandler<C>
{
    public typealias Handler = (index: Index,
        elment: Element, changed: Bool) -> Void
    private let handler: Handler
    private init(handler: Handler) {
        self.handler = handler
        super.init(diff: [.Stationary, .Changed])
    }
    
    private override func handleDiff(fromIndex fromIndex: Index?,
        fromElement: Element?,
        toIndex: Index?,
        toElement: Element?,
        changed: Bool?)
    {
        switch (fromIndex, fromElement, toIndex, toElement, changed) {
        case let (.Some(fromIndex), .Some(fromElement), .Some(toIndex),
            .Some(_), .Some(changed)) where fromIndex == toIndex :
            
            handler(index: fromIndex, elment: fromElement,
                changed: changed)
        default:    return
        }
    }
}

final public class CollectionChangedHandler<C: CollectionType>:
    CollectionDiffHandler<C>
{
    public typealias Handler = (fromIndex: Index, fromElement: Element,
        toIndex: Index, toElement: Element) -> Void
    private let handler: Handler
    private init(handler: Handler) {
        self.handler = handler
        super.init(diff: .Changed)
    }
    
    private override func handleDiff(fromIndex fromIndex: Index?,
        fromElement: Element?,
        toIndex: Index?,
        toElement: Element?,
        changed: Bool?)
    {
        switch (fromIndex, fromElement, toIndex, toElement, changed) {
        case let (.Some(fromIndex), .Some(fromElement),
            .Some(toIndex), .Some(toElement), .Some(true)):
            
            handler(fromIndex: fromIndex, fromElement: fromElement,
                toIndex: toIndex, toElement: toElement)
        default:    return
        }
    }
}

final public class CollectionMetaChangesHandler<C: CollectionType>:
    CollectionDiffHandler<C>
{
    public typealias Handler = (changes: CollectionDiff,
        fromIndex: Index?, fromElement: Element?,
        toIndex: Index?, toElement: Element?,
        changed: Bool?) -> Void
    private let handler: Handler
    private init(diff: CollectionDiff, handler: Handler) {
        self.handler = handler
        super.init(diff: diff)
    }
    
    private override func handleDiff(fromIndex fromIndex: Index?,
        fromElement: Element?,
        toIndex: Index?,
        toElement: Element?,
        changed: Bool?)
    {
        let change: CollectionDiff = {
            let diffs: CollectionDiff = {
                switch (fromIndex, fromElement, toIndex, toElement) {
                case let (.Some(fromIndex), _, .Some(toIndex), _)
                    where fromIndex == toIndex:
                    return self.diff.intersect(.Stationary)
                case let (.Some(fromIndex), _, .Some(toIndex), _)
                    where fromIndex != toIndex:
                    return self.diff.intersect(.Moved)
                case (.Some(_), _, nil, _):
                    return self.diff.intersect(.Deleted)
                case (nil, _, .Some(_), _):
                    return self.diff.intersect(.Inserted)
                default: return []
                }
                }()
            
            if changed == true && self.diff.contains(.Changed) {
                return diffs.union(.Changed)
            }
            
            return diffs
        }()
        
        
        handler(changes: change,
            fromIndex: fromIndex, fromElement: fromElement,
            toIndex: toIndex, toElement: toElement,
            changed: changed)
    }
}

//MARK: - CollectionElementWrapper
final private class CollectionElementWrapper<C: CollectionType>: Equatable,
    CustomStringConvertible
{
    typealias Element = C.Generator.Element
    typealias Index = C.Index
    
    var traversed = false
    let index: Index
    let element: Element
    let equalityComparator: (Element, Element) -> Bool
    init(_ theIndex: Index, _ theEmenet: Element,
        _ theEqualityComparator: (Element, Element) -> Bool)
    {
        index = theIndex
        element = theEmenet
        equalityComparator = theEqualityComparator
    }
    
    var description: String {
        return "<\(CollectionElementWrapper.self); Index = \(index); Element = \(element); Traversed = \(traversed)>>"
    }
    
    class func wrapCollection<C: CollectionType>(collection: C,
        equalityComparator:
        (C.Generator.Element, C.Generator.Element) -> Bool)
        -> [CollectionElementWrapper<C>]
    {
        typealias ElementWrapper = CollectionElementWrapper<C>
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

private func == <C: CollectionType>
    (left: CollectionElementWrapper<C>,
    right: CollectionElementWrapper<C>) -> Bool
{
    return (left.traversed == right.traversed &&
        left.equalityComparator(left.element, right.element))
}