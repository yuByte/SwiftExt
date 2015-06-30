//
//  CollectionType+DiffWith.swift
//  Swift-Extended-Library
//
//  Created by Manfred on 6/30/15.
//
//

public class CollectionDiffer<C: CollectionType> {
    public typealias Collection = C
    public typealias Element = C.Generator.Element
    public typealias Index = C.Index
    
    private var _inspectedDifferences: CollectionDiff = []
    public var inspectedDifferences: CollectionDiff {
        return _inspectedDifferences
    }
    
    public let fromCollection: Collection
    public let toCollection: Collection
    
    private init(from: Collection, to: Collection,
        equalityComparator theEqualityComparator: ElementComparator,
        contentComparator theContentComparator: ElementComparator)
    {
        fromCollection          = from
        toCollection            = to
        equalityComparator      = theEqualityComparator
        contentComparator       = theContentComparator
    }
    
    public typealias UnaryHandler =
        (index: Index, from: Element) -> Void
    public typealias BinaryHandler =
        (fromIndex: Index, fromElement: Element,
        toIndex: Index, toElement: Element) -> Void
    
    public typealias UnaryWithChangeHandler =
        (index: Index, from: Element, changed: Bool) -> Void
    public typealias BinaryWithChangeHandler =
        (fromIndex: Index, fromElement: Element,
        toIndex: Index, toElement: Element, changed: Bool) -> Void
    
    public typealias ElementComparator =
        (Element, Element) -> Bool
    
    private var _insertionHandler: UnaryHandler?
    private var _deletionHandler: UnaryHandler?
    private var _movingHandler: BinaryHandler?
    private var _movingWithChangeHandler: BinaryWithChangeHandler?
    private var _stationaryHandler: UnaryHandler?
    private var _stationaryWithChangeHandler: UnaryWithChangeHandler?
    private var _changeHandler: BinaryHandler?
    
    public var insertionHandler: UnaryHandler?
        { return _insertionHandler }
    public var deletionHandler: UnaryHandler?
        { return _deletionHandler }
    public var movingHandler: BinaryHandler?
        { return _movingHandler }
    public var movingWithChangeHandler: BinaryWithChangeHandler?
        { return _movingWithChangeHandler }
    public var stationaryHandler: UnaryHandler?
        { return _stationaryHandler }
    public var stationaryWithChangeHandler: UnaryWithChangeHandler?
        { return _stationaryWithChangeHandler }
    public var changeHandler: BinaryHandler?
        { return _changeHandler }
    
    public let equalityComparator: ElementComparator
    public let contentComparator: ElementComparator
    
    public func handleInsertion(handler: UnaryHandler)
        -> CollectionDiffer<Collection>
    {
        if _insertionHandler == nil {
            _inspectedDifferences += .Added
            _insertionHandler = handler
        } else {
            assertionFailure("Cannot assign insertion handler multiple times")
        }
        return self
    }
    
    public func handleDeletion(handler: UnaryHandler)
        -> CollectionDiffer<Collection>
    {
        if _deletionHandler == nil {
            _inspectedDifferences += .Deleted
            _deletionHandler = handler
        } else {
            assertionFailure("Cannot assign deletion handler multiple times")
        }
        return self
    }
    
    public func handleMoving(handler: BinaryHandler)
        -> CollectionDiffer<Collection>
    {
        if _movingWithChangeHandler == nil && _movingHandler == nil {
            _inspectedDifferences += .Moved
            _movingHandler = handler
        } else {
            assertionFailure("Cannot assign moving handler multiple times")
        }
        return self
    }
    
    public func handleMovingWithChange(handler: BinaryWithChangeHandler)
        -> CollectionDiffer<Collection>
    {
        assert(_changeHandler == nil, "Cannot handle change and moving with change at the same time")
        if _movingWithChangeHandler == nil && _movingHandler == nil {
            _inspectedDifferences += .Moved + .Changed
            _movingWithChangeHandler = handler
        } else {
            assertionFailure("Cannot assign moving handler multiple times")
        }
        return self
    }
    
    public func handleStationary(handler: UnaryHandler)
        -> CollectionDiffer<Collection>
    {
        if _stationaryWithChangeHandler == nil && _stationaryHandler == nil {
            _inspectedDifferences += .Stationary
            _stationaryHandler = handler
        } else {
            assertionFailure("Cannot assign stationary handler multiple times")
        }
        return self
    }
    
    public func handleStationaryWithChange(handler: UnaryWithChangeHandler)
        -> CollectionDiffer<Collection>
    {
        assert(_changeHandler == nil, "Cannot handle change and stationary with change at the same time")
        if _stationaryWithChangeHandler == nil && _stationaryHandler == nil {
            _inspectedDifferences += .Stationary + .Changed
            _stationaryWithChangeHandler = handler
        } else {
            assertionFailure("Cannot assign stationary handler multiple times")
        }
        return self
    }
    
    public func handleChange(handler: BinaryHandler)
        -> CollectionDiffer<Collection>
    {
        assert(_stationaryWithChangeHandler == nil &&
            _stationaryHandler == nil,
            "Cannot handle change and stationary with change at the same time")
        assert(_movingWithChangeHandler == nil &&
            _movingHandler == nil,
            "Cannot handle change and moving with change at the same time")
        
        if _changeHandler == nil {
            _inspectedDifferences += .Changed
            _changeHandler = handler
        } else {
            assertionFailure("Cannot assign change handler multiple times")
        }
        return self
    }
    
    public func begin() {
        let shouldInspectStationary = inspectedDifferences.contains(.Stationary)
        let shouldInspectInserted   = inspectedDifferences.contains(.Added)
        let shouldInspectDeleted    = inspectedDifferences.contains(.Deleted)
        let shouldInspectMoved      = inspectedDifferences.contains(.Moved)
        let shouldInspectChanged    = inspectedDifferences.contains(.Changed)
        
        var wrappedFromElements =
        [CollectionElementWrapper<Element, Index>]()
        var wrappedToElements =
        [CollectionElementWrapper<Element, Index>]()
        
        let shouldWrap = (shouldInspectInserted ||
            shouldInspectStationary ||
            shouldInspectDeleted ||
            shouldInspectMoved)
        
        if shouldWrap {
            var fromIndex = fromCollection.startIndex
            for fromElement in fromCollection {
                let wrappedElement =
                CollectionElementWrapper<Element, Index>(fromIndex,
                    fromElement, equalityComparator)
                wrappedFromElements.append(wrappedElement)
                fromIndex = fromIndex.successor()
            }
            
            var toIndex = toCollection.startIndex
            for toElement in toCollection {
                let wrappedElement =
                CollectionElementWrapper<Element, Index>(toIndex,
                    toElement, equalityComparator)
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
                        insertionHandler?(
                            index: wrappedToElement.index,
                            from: wrappedToElement.element)
                    }
                }
                
                if let fromIndex = fromIndex {
                    let toIndex = wrappedToElement.index
                    
                    let changed: Bool? = {
                        if shouldInspectChanged {
                            return !contentComparator(
                                wrappedToElement.element,
                                wrappedFromElement!.element)
                        }
                        return nil
                        }()
                    
                    if fromIndex == toIndex {
                        if (shouldInspectStationary ||
                            shouldInspectChanged)
                        {
                            if let changed = changed {
                                stationaryWithChangeHandler?(
                                    index: wrappedToElement.index,
                                    from: wrappedToElement.element,
                                    changed: changed)
                                
                                if changed {
                                    changeHandler?(
                                        fromIndex: wrappedFromElement!.index,
                                        fromElement: wrappedFromElement!.element,
                                        toIndex: wrappedToElement.index,
                                        toElement: wrappedToElement.element)
                                }
                            } else {
                                stationaryHandler?(
                                    index: wrappedToElement.index,
                                    from: wrappedToElement.element)
                            }
                        }
                    } else {
                        if (shouldInspectMoved || shouldInspectChanged) {
                            if let changed = changed {
                                movingWithChangeHandler?(
                                    fromIndex: wrappedFromElement!.index,
                                    fromElement: wrappedFromElement!.element,
                                    toIndex: wrappedToElement.index,
                                    toElement: wrappedToElement.element,
                                    changed: changed)
                                
                                if changed {
                                    changeHandler?(
                                        fromIndex: wrappedFromElement!.index,
                                        fromElement: wrappedFromElement!.element,
                                        toIndex: wrappedToElement.index,
                                        toElement: wrappedToElement.element)
                                }
                            } else {
                                movingHandler?(
                                    fromIndex: wrappedFromElement!.index,
                                    fromElement: wrappedFromElement!.element,
                                    toIndex: wrappedToElement.index,
                                    toElement: wrappedToElement.element)
                            }
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
                    deletionHandler?(index: wrappedFromElement.index,
                        from: wrappedFromElement.element)
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

extension CollectionType {
    func diffWith(comparedCollection: Self,
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
    func diffWith(comparedCollection: Self,
        contentComparator: CollectionDiffer<Self>.ElementComparator = {$0 == $1})
        -> CollectionDiffer<Self>
    {
        return CollectionDiffer(from: self,
            to: comparedCollection,
            equalityComparator: {$0 == $1},
            contentComparator: contentComparator)
    }
}
