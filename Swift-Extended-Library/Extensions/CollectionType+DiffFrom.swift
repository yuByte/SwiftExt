//
//  CollectionType+DiffWith.swift
//  Swift-Extended-Library
//
//  Created by Manfred on 6/30/15.
//
//

//AMRK: - Collection Type Extension
extension CollectionType {
    public func diffFrom(comparedCollection: Self,
        equalityComparator: CollectionDiffer<Self>.ElementComparator,
        contentComparator: CollectionDiffer<Self>.ElementComparator)
        -> CollectionDiffer<Self>
    {
        return CollectionDiffer(from: self,
            to: comparedCollection,
            equalityComparator: equalityComparator,
            contentComparator: contentComparator)
    }
}

extension CollectionType where Generator.Element : Equatable {
    public func diffFrom(comparedCollection: Self,
        contentComparator: CollectionDiffer<Self>.ElementComparator = {$0 == $1})
        -> CollectionDiffer<Self>
    {
        return CollectionDiffer(from: self,
            to: comparedCollection,
            equalityComparator: {$0 == $1},
            contentComparator: contentComparator)
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
    private let toCollection: Collection
    
    private init(from: Collection, to: Collection,
        equalityComparator theEqualityComparator: ElementComparator,
        contentComparator theContentComparator: ElementComparator)
    {
        fromCollection          = from
        toCollection            = to
        equalityComparator      = theEqualityComparator
        contentComparator       = theContentComparator
    }
    
    private var diffHandlers =
        [CollectionDiff: [CollectionDiffHandler<Collection>]]()
    
    private let equalityComparator: ElementComparator
    private let contentComparator: ElementComparator
    
    public func commit() {
        let shouldDiff = inspectedDiffs != [] &&
            (!fromCollection.isEmpty || !toCollection.isEmpty)
        
        if shouldDiff { diff() }
    }
    
    private func diff() {
        typealias ElementWrapper = CollectionElementWrapper<Element, Index>
        
        let fromElementsIterativeDiff = CollectionDiff.Deleted
        
        let toElementsIterativeDiff: CollectionDiff = [
            .Stationary, .Added, .Moved, .Changed]
        
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
                        !self.contentComparator(fromElement, toElement)
                }
                return nil
                }()
            
            for (diff, handlers) in diffHandlers
                where toElementsIterativeDiff.contains(diff)
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
                where fromElementsIterativeDiff.contains(diff)
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

//AMRK: Collection Differ Handle Commiting Methods
extension CollectionDiffer {
    public func handleAdded(
        handler: CollectionInsertionHandler<Collection>.Handler)
        -> CollectionDiffer<Collection>
    {
        let handler = CollectionInsertionHandler<Collection>(
            handler: handler)
        appendDiffHandler(handler, withDiff: handler.diff)
        return self
    }
    
    public func handleDeleted(
        handler: CollectionDeletionHandler<Collection>.Handler)
        -> CollectionDiffer<Collection>
    {
        let handler = CollectionDeletionHandler<Collection>(
            handler: handler)
        appendDiffHandler(handler, withDiff: handler.diff)
        return self
    }
    
    public func handleMoved(
        handler: CollectionMovingHandler<Collection>.Handler)
        -> CollectionDiffer<Collection>
    {
        let handler = CollectionMovingHandler<Collection>(
            handler: handler)
        appendDiffHandler(handler, withDiff: handler.diff)
        return self
    }
    
    public func handleMovedWithChange(
        handler: CollectionMovingWithChangeHandler<Collection>.Handler)
        -> CollectionDiffer<Collection>
    {
        let handler = CollectionMovingWithChangeHandler<Collection>(
            handler: handler)
        appendDiffHandler(handler, withDiff: handler.diff)
        return self
    }
    
    public func handleStationary(
        handler: CollectionStationaryHandler<Collection>.Handler)
        -> CollectionDiffer<Collection>
    {
        let handler = CollectionStationaryHandler<Collection>(
            handler: handler)
        appendDiffHandler(handler, withDiff: handler.diff)
        return self
    }
    
    public func handleStationaryWithChange(
        handler: CollectionStationaryWithChangeHandler<Collection>.Handler)
        -> CollectionDiffer<Collection>
    {
        let handler = CollectionStationaryWithChangeHandler<Collection>(
            handler: handler)
        appendDiffHandler(handler, withDiff: handler.diff)
        return self
    }
    
    public func handleChanged(
        handler: CollectionChangedHandler<Collection>.Handler)
        -> CollectionDiffer<Collection>
    {
        let handler = CollectionChangedHandler<Collection>(
            handler: handler)
        appendDiffHandler(handler, withDiff: handler.diff)
        return self
    }
    
    public func handleChanges(changes: CollectionDiff,
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
        } catch {
            assertionFailure("Diff is not valid and I don't know why...")
        }
        
    }
}

//MARK: - Collection Diff Diff-Form Infrastructure
extension CollectionDiff {
    enum Error: ErrorType {
        case ValidateError
    }
    
    private func validate () throws {
        let validDiffs: [CollectionDiff] = [
            .Stationary,
            .Added,
            .Deleted,
            .Moved,
            .Changed,
            [.Stationary, .Changed],
            [.Moved, .Changed],
            .All
        ]
        
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
        assertionFailure("You must override this method without calling its super")
    }
}

final private class CollectionInsertionHandler<C: CollectionType>:
    CollectionDiffHandler<C>
{
    typealias Handler = (toIndex: Index, toElement: Element) -> Void
    let handler: Handler
    init(handler: Handler) {
        self.handler = handler
        super.init(diff: .Added)
    }
    
    override func handleDiff(fromIndex fromIndex: Index?,
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

final private class CollectionDeletionHandler<C: CollectionType>:
    CollectionDiffHandler<C>
{
    typealias Handler = (fromIndex: Index, fromElement: Element) -> Void
    let handler: Handler
    init(handler: Handler) {
        self.handler = handler
        super.init(diff: .Deleted)
    }
    
    override func handleDiff(fromIndex fromIndex: Index?,
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

final private class CollectionMovingHandler<C: CollectionType>:
    CollectionDiffHandler<C>
{
    typealias Handler = (fromIndex: Index, fromElement: Element,
        toIndex: Index, toElement: Element) -> Void
    let handler: Handler
    init(handler: Handler) {
        self.handler = handler
        super.init(diff: .Moved)
    }
    
    override func handleDiff(fromIndex fromIndex: Index?,
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

final private class CollectionMovingWithChangeHandler<C: CollectionType>:
    CollectionDiffHandler<C>
{
    typealias Handler = (fromIndex: Index, fromElement: Element,
        toIndex: Index, toElement: Element,
        changed: Bool) -> Void
    let handler: Handler
    init(handler: Handler) {
        self.handler = handler
        super.init(diff: [.Moved, .Changed])
    }
    
    override func handleDiff(fromIndex fromIndex: Index?,
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

final private class CollectionStationaryHandler<C: CollectionType>:
    CollectionDiffHandler<C>
{
    typealias Handler = (index: Index, element: Element) -> Void
    let handler: Handler
    init(handler: Handler) {
        self.handler = handler
        super.init(diff: .Stationary)
    }
    
    override func handleDiff(fromIndex fromIndex: Index?,
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

final private class CollectionStationaryWithChangeHandler<C: CollectionType>:
    CollectionDiffHandler<C>
{
    typealias Handler = (index: Index,
        elment: Element, changed: Bool) -> Void
    let handler: Handler
    init(handler: Handler) {
        self.handler = handler
        super.init(diff: [.Stationary, .Changed])
    }
    
    override func handleDiff(fromIndex fromIndex: Index?,
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

final private class CollectionChangedHandler<C: CollectionType>:
    CollectionDiffHandler<C>
{
    typealias Handler = (fromIndex: Index, fromElement: Element,
        toIndex: Index, toElement: Element) -> Void
    let handler: Handler
    init(handler: Handler) {
        self.handler = handler
        super.init(diff: .Changed)
    }
    
    override func handleDiff(fromIndex fromIndex: Index?,
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

final private class CollectionMetaChangesHandler<C: CollectionType>:
    CollectionDiffHandler<C>
{
    typealias Handler = (changes: CollectionDiff,
        fromIndex: Index?, fromElement: Element?,
        toIndex: Index?, toElement: Element?,
        changed: Bool?) -> Void
    let handler: Handler
    init(diff: CollectionDiff, handler: Handler) {
        self.handler = handler
        super.init(diff: diff)
    }
    
    override func handleDiff(fromIndex fromIndex: Index?,
        fromElement: Element?,
        toIndex: Index?,
        toElement: Element?,
        changed: Bool?)
    {
        handler(changes: diff,
            fromIndex: fromIndex, fromElement: fromElement,
            toIndex: toIndex, toElement: toElement,
            changed: changed)
    }
}