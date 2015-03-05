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
public struct SequenceDifference: RawOptionSetType, DebugPrintable, Printable {
    public typealias RawValue = UInt
    
    public let rawValue: RawValue
    
    public init(_ value: RawValue) { self.rawValue = value }
    public init(rawValue value: RawValue) { self.rawValue = value }
    public init(nilLiteral: ()) { self.rawValue = 0 }
    
    public static var allZeros:     SequenceDifference  { return self(0) }
    
    public static var Stationary:   SequenceDifference  { return self(0) }
    public static var Added:        SequenceDifference  { return self(1 << 0) }
    public static var Deleted:      SequenceDifference  { return self(1 << 1) }
    public static var Moved:        SequenceDifference  { return self(1 << 2) }
    public static var Changed:      SequenceDifference  { return self(1 << 3) }
    
    public static var All:          SequenceDifference  { return .Stationary | .Added | .Deleted | .Moved | .Changed }
    
    public var description: String {
        get {
            var descriptions = [String]()
            enumerate(self, withOptions: .HandleOccurred) { (options, option) -> Bool in
                switch option {
                case SequenceDifference.Stationary:
                    descriptions.append("Stationary")
                case SequenceDifference.Added:
                    descriptions.append("Added")
                case SequenceDifference.Deleted:
                    descriptions.append("Deleted")
                case SequenceDifference.Moved:
                    descriptions.append("Moved")
                default:
                    descriptions.append("\(self.rawValue)")
                }
                return false
            }
            return "<SequenceChanges: " + join(" | ", descriptions) + ">"
        }
    }
    
    public var debugDescription: String {
        get {
            return description
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

/**
Diff two sequences whose generator's element type conforms to Equatable protocol.

:param:     fromSequence            The original sequence

:param:     toSequence              The changed sequence

:param:     differences             A SequenceDifference value which indicates what differences shall be inspected

:param:     changesHandler          The handler being used to handle captured difference

*/
public func diff<Seq: SequenceType where Seq.Generator.Element : Equatable>
    (from fromSequence: Seq?, to toSequence: Seq?,
    #differences: SequenceDifference,
    usingClosure changesHandler: (change: SequenceDifference,
    fromElement: (index: Int, element: Seq.Generator.Element)?,
    toElement: (index: Int, element: Seq.Generator.Element)?) -> Void)
{
    diff(from: fromSequence, to: toSequence, differences: differences, equalComparator: {$0 == $1}, unchangedComparator: {$0 == $1}, usingClosure: changesHandler)
}


/**
Diff two arbitrary sequences by using custom equality and unchange comparator.

:param:     fromSequence            The original sequence

:param:     toSequence              The changed sequence

:param:     differences             A SequenceDifference value which indicates what differences shall be inspected

:param:     equalComparator         The comparator handles equality checking

:param:     unchangedComparator     The comparator handles unchange checking

:param:     changesHandler          The handler being used to handle captured difference

*/
public func diff<Seq: SequenceType>
    (from fromSequence: Seq?, to toSequence: Seq?,
    #differences: SequenceDifference,
    #equalComparator: ((Seq.Generator.Element, Seq.Generator.Element) -> Bool),
    #unchangedComparator: ((Seq.Generator.Element, Seq.Generator.Element) -> Bool),
    usingClosure changesHandler: (change: SequenceDifference,
    fromElement: (index: Int, element: Seq.Generator.Element)?,
    toElement: (index: Int, element: Seq.Generator.Element)?) -> Void)
{
    typealias Element = Seq.Generator.Element
    
    let shouldInspectStationary =   differences |? .Stationary
    let shouldInspectInserted =     differences |? .Added
    let shouldInspectDeleted =      differences |? .Deleted
    let shouldInspectMoved =        differences |? .Moved
    let shouldInspectChanged =      differences |? .Changed
    
    var wrappedFromElements: [SequenceElementContainer<Element>] = []
    var wrappedToElements: [SequenceElementContainer<Element>] = []
    
    let shouldWrap = shouldInspectInserted || shouldInspectStationary || shouldInspectDeleted || shouldInspectMoved
    
    if shouldWrap {
        if fromSequence != nil {
            for fromElement in enumerate(fromSequence!) {
                let wrappedElement = SequenceElementContainer<Element>(fromElement.index, fromElement.element, equalComparator, unchangedComparator)
                wrappedFromElements.append(wrappedElement)
            }
        }
        
        if toSequence != nil {
            for toElement in enumerate(toSequence!) {
                let wrappedElement = SequenceElementContainer<Element>(toElement.index, toElement.element, equalComparator, unchangedComparator)
                wrappedToElements.append(wrappedElement)
            }
        }
    }
    
    if shouldInspectInserted || shouldInspectStationary || shouldInspectMoved {
        // Traversal to sequence to find inserted, stationary and moved
        for (var wrappedToElement) in wrappedToElements {
            let fromIndex = find(wrappedFromElements, wrappedToElement)
            var wrappedFromElement: SequenceElementContainer<Element>? = (fromIndex == nil ? nil : wrappedFromElements[fromIndex!])
            if shouldInspectInserted {
                if fromIndex == nil {
                    let toIndex = wrappedToElement.index
                    changesHandler(change: .Added, fromElement: nil,
                        toElement: (wrappedToElement.index, wrappedToElement.element))
                }
            }
            
            if fromIndex != nil {
                let toIndex = wrappedToElement.index
                
                var changes: SequenceDifference = .allZeros
                
                if shouldInspectChanged {
                    if !wrappedToElement.unchangedComparator(wrappedToElement.element, wrappedFromElement!.element) {
                        changes |= .Changed
                    }
                }
                
                if fromIndex! == toIndex {
                    if shouldInspectStationary || shouldInspectChanged {
                        changesHandler(change: .Stationary | changes, fromElement: (wrappedFromElement!.index, wrappedFromElement!.element),
                            toElement: (wrappedToElement.index, wrappedToElement.element))
                    }
                } else {
                    if shouldInspectMoved || shouldInspectChanged {
                        changesHandler(change: .Moved | changes, fromElement: (wrappedFromElement!.index, wrappedFromElement!.element),
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
        for (var wrappedFromElement) in wrappedFromElements {
            let toIndex = find(wrappedToElements, wrappedFromElement)
            
            if toIndex == nil {
                changesHandler(change: .Deleted, fromElement: (wrappedFromElement.index, wrappedFromElement.element), toElement: nil)
            }
            
            wrappedFromElement.traversed = true
            if toIndex != nil {
                var wrappedToElement = (wrappedToElements[toIndex!])
                wrappedToElement.traversed = true
            }
        }
    }
}
