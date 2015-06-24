//
//  SequenceChanges.swift
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
public struct SequenceDifference: OptionSetType, CustomDebugStringConvertible, CustomStringConvertible {
    public typealias RawValue = UInt
    
    public let rawValue: RawValue
    
    public init(rawValue value: RawValue) { self.rawValue = value }
    
    public static var Stationary:   SequenceDifference  { return self.init(rawValue: 0) }
    public static var Added:        SequenceDifference  { return self.init(rawValue: 1 << 0) }
    public static var Deleted:      SequenceDifference  { return self.init(rawValue: 1 << 1) }
    public static var Moved:        SequenceDifference  { return self.init(rawValue: 1 << 2) }
    public static var Changed:      SequenceDifference  { return self.init(rawValue: 1 << 3) }
    
    public static var All:          SequenceDifference  { return [.Stationary, .Added, .Deleted, .Moved, .Changed] }
    
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
            return "<SequenceChanges: " + " | ".join(descriptions) + ">"
        }
    }
    
    public var debugDescription: String {
        get {
            return description
        }
    }
}

extension SequenceType where Generator.Element : Equatable {
    /**
    Diff two sequences whose generator's element type conforms to Equatable protocol.
    
    - parameter     fromSequence:            The original sequence
    
    - parameter     toSequence:              The changed sequence
    
    - parameter     differences:             A SequenceDifference value which indicates what differences shall be inspected
    
    - parameter     changesHandler:          The handler being used to handle captured difference
    
    */
    public func diff(comparedSequence: Self?,
        differences: SequenceDifference,
        usingClosure changesHandler: (change: SequenceDifference,
        fromElement: (index: Int, element: Generator.Element)?,
        toElement: (index: Int, element: Generator.Element)?) -> Void)
    {
        diff(comparedSequence, differences: differences, equalComparator: {$0 == $1}, unchangedComparator: {$0 == $1}, usingClosure: changesHandler)
    }
}

extension SequenceType {
    /**
    Diff two arbitrary sequences by using custom equality and unchange comparator.
    
    - parameter     fromSequence:            The original sequence
    
    - parameter     toSequence:              The changed sequence
    
    - parameter     differences:             A SequenceDifference value which indicates what differences shall be inspected
    
    - parameter     equalComparator:         The comparator handles equality checking
    
    - parameter     unchangedComparator:     The comparator handles unchange checking
    
    - parameter     changesHandler:          The handler being used to handle captured difference
    
    */
    public func diff(comparedSequence: Self?,
        differences: SequenceDifference,
        equalComparator: ((Generator.Element, Generator.Element) -> Bool),
        unchangedComparator: ((Generator.Element, Generator.Element) -> Bool),
        usingClosure changesHandler: (change: SequenceDifference,
        fromElement: (index: Int, element: Generator.Element)?,
        toElement: (index: Int, element: Generator.Element)?) -> Void)
    {
        typealias Element = Generator.Element
        
        let shouldInspectStationary = differences.contains(.Stationary)
        let shouldInspectInserted   = differences.contains(.Added)
        let shouldInspectDeleted    = differences.contains(.Deleted)
        let shouldInspectMoved      = differences.contains(.Moved)
        let shouldInspectChanged    = differences.contains(.Changed)
        
        var wrappedFromElements: [SequenceElementContainer<Element>] = []
        var wrappedToElements: [SequenceElementContainer<Element>] = []
        
        let shouldWrap = shouldInspectInserted || shouldInspectStationary || shouldInspectDeleted || shouldInspectMoved
        
        if shouldWrap {
            for fromElement in self.enumerate() {
                let wrappedElement = SequenceElementContainer<Element>(fromElement.index, fromElement.element, equalComparator, unchangedComparator)
                wrappedFromElements.append(wrappedElement)
            }
            
            if comparedSequence != nil {
                for toElement in (comparedSequence!).enumerate() {
                    let wrappedElement = SequenceElementContainer<Element>(toElement.index, toElement.element, equalComparator, unchangedComparator)
                    wrappedToElements.append(wrappedElement)
                }
            }
        }
        
        if shouldInspectInserted || shouldInspectStationary || shouldInspectMoved {
            // Traversal to sequence to find inserted, stationary and moved
            for wrappedToElement in wrappedToElements {
                let fromIndex = wrappedFromElements.indexOf(wrappedToElement)
                let wrappedFromElement: SequenceElementContainer<Element>? = (fromIndex == nil ? nil : wrappedFromElements[fromIndex!])
                if shouldInspectInserted {
                    if fromIndex == nil {
                        changesHandler(change: .Added, fromElement: nil,
                            toElement: (wrappedToElement.index, wrappedToElement.element))
                    }
                }
                
                if fromIndex != nil {
                    let toIndex = wrappedToElement.index
                    
                    var changes: SequenceDifference = []
                    
                    if shouldInspectChanged {
                        if !wrappedToElement.unchangedComparator(wrappedToElement.element, wrappedFromElement!.element) {
                            changes = changes.union(.Changed)
                        }
                    }
                    
                    if fromIndex! == toIndex {
                        if shouldInspectStationary || shouldInspectChanged {
                            changesHandler(change: changes.union(.Stationary), fromElement: (wrappedFromElement!.index, wrappedFromElement!.element),
                                toElement: (wrappedToElement.index, wrappedToElement.element))
                        }
                    } else {
                        if shouldInspectMoved || shouldInspectChanged {
                            changesHandler(change: changes.union(.Moved), fromElement: (wrappedFromElement!.index, wrappedFromElement!.element),
                                toElement: (wrappedToElement.index, wrappedToElement.element))
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
                let toIndex = wrappedToElements.indexOf(wrappedFromElement)
                
                if toIndex == nil {
                    changesHandler(change: .Deleted, fromElement: (wrappedFromElement.index, wrappedFromElement.element), toElement: nil)
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

private class SequenceElementContainer<Element>: Equatable {
    var traversed = false
    let index: Int
    let element: Element
    let equalComparator: (Element, Element) -> Bool
    let unchangedComparator: (Element, Element) -> Bool
    init(_ theIndex: Int, _ theEmenet: Element,
        _ equalComparator: (Element, Element) -> Bool,
        _ unchangedComparator: (Element, Element) -> Bool)
    {
        index = theIndex
        element = theEmenet
        self.equalComparator = equalComparator
        self.unchangedComparator = unchangedComparator
    }
}

private func == <Element> (left: SequenceElementContainer<Element>, right: SequenceElementContainer<Element>) -> Bool {
    return (left.traversed == right.traversed && left.equalComparator(left.element, right.element))
}
