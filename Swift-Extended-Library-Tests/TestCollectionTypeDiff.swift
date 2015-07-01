//
//  TestCollectionTypeDiff.swift
//  Swift-Extended-Library
//
//  Created by Manfred on 6/30/15.
//
//

@testable
import SwiftExt

import XCTest

class TestCollectionTypeDiff: XCTestCase {
    var from: [Int] = []
    
    var to: [Int] = []
    
    let toAdd = [11,22,33,44,55,66,77,88,99]
    let toRemove = [0,2,4,6,8,10]
    let toMove = [1,3,5,7,9]
    var toBeStationary: [Int] = [23,34,56,67]
    
    var added: [Int] = []
    var removed: [Int] = []
    var moved: [Int] = []
    var stationary: [Int] = []
    var changed: [(Int, Int)] = []
    
    override func setUp() {
        super.setUp()
        from = [0,1,2,3,4,5,6,7,8,9,10]
        to = {
            var to = from
            for eachToAdd in toAdd {
                let previous = eachToAdd % 10
                if let previousIndex = to.indexOf(previous) {
                    to.insert(eachToAdd, atIndex: previousIndex + 1)
                }
            }
            
            to.remove(toRemove)
            
            for index in 0..<toMove.count/2 {
                let leftElement = toMove[index]
                let rightElement = toMove[toMove.indexCap! - index]
                if let leftIndex = to.indexOf(leftElement),
                    rightIndex = to.indexOf(rightElement)
                {
                    to.removeAtIndex(leftIndex)
                    to.insert(rightElement, atIndex: leftIndex)
                    
                    to.removeAtIndex(rightIndex)
                    to.insert(leftElement, atIndex: rightIndex)
                }
            }
            
            for eachToBeStationary in toBeStationary {
                from.insert(eachToBeStationary, atIndex: 0)
                to.insert(eachToBeStationary, atIndex: 0)
            }
            
            return to
            }()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        from = []
        to = []
        added = []
        removed = []
        moved = []
        stationary = []
    }
    
    func testDiff() {
        
    }
    
    func testEquatableDiffFrom() {
        from.diffFrom(to).handleAdded { (_, toElement) -> Void in
            self.added.append(toElement)
        }.handleDeleted { (_, fromElement) -> Void in
            self.removed.append(fromElement)
        }.handleMoved { (_, fromElement, _, _) -> Void in
            self.moved.append(fromElement)
        }.handleStationary { (_, fromElement) -> Void in
            self.stationary.append(fromElement)
        }.handleChanged({ (_, fromElement, _, toElement) -> Void in
            let change = (fromElement, toElement)
            self.changed.append(change)
        }).commit()
        
        added.sortInPlace()
        removed.sortInPlace()
        moved.sortInPlace()
        stationary.sortInPlace()
        
        XCTAssert(toAdd == added,
            "Equatable-diff-from added items inspecting doesn't pass:\n\tTo add:\(toAdd)\n\tAdded:\(added)")
        XCTAssert(toRemove == removed,
            "Equatable-diff-from removed items inspecting doesn't pass:\n\tTo Remove:\(toRemove)\n\tRemoved:\(removed)")
        XCTAssert(toMove == moved,
            "Equatable-diff-from moved items inspecting doesn't pass:\n\tTo move:\(toMove)\n\tMoved:\(moved)")
        XCTAssert(toBeStationary == stationary,
            "Equatable-diff-from stationary items inspecting doesn't pass:\n\tTo be stationary:\(toBeStationary)\n\tStationary: \(stationary)")
        XCTAssert(changed.isEmpty,
            "Equatable-diff-from changed items inspecting doesn't pass:\n\tChanged:\(changed)")
    }

    func testEquatableDiff() {
        from.diff(to, differences: CollectionDiff.All) { (change, fromIndex, fromElement, toIndex, toElement, changed) -> Void in
            if change.contains(.Added) {
                XCTAssert(!change.contains(.Deleted),
                    "It is impossible that \(CollectionDiff.Added) be with \(CollectionDiff.Deleted) at same time during diffing!")
                XCTAssert(!change.contains(.Moved),
                    "It is impossible that \(CollectionDiff.Added) be with \(CollectionDiff.Moved) at same time during diffing!")
                XCTAssert(!change.contains(.Changed),
                    "It is impossible that \(CollectionDiff.Added) be with \(CollectionDiff.Changed) at same time during diffing!")
                self.added.append(toElement!)
            }
            if change.contains(.Deleted) {
                XCTAssert(!change.contains(.Added),
                    "It is impossible that \(CollectionDiff.Deleted) be with \(CollectionDiff.Added) at same time during diffing!")
                XCTAssert(!change.contains(.Moved),
                    "It is impossible that \(CollectionDiff.Deleted) be with \(CollectionDiff.Moved) at same time during diffing!")
                XCTAssert(!change.contains(.Changed),
                    "It is impossible that \(CollectionDiff.Deleted) be with \(CollectionDiff.Changed) at same time during diffing!")
                self.removed.append(fromElement!)
            }
            if change.contains(.Moved) {
                XCTAssert(!change.contains(.Deleted),
                    "It is impossible that \(CollectionDiff.Moved) be with \(CollectionDiff.Deleted) at same time during diffing!")
                XCTAssert(!change.contains(.Added),
                    "It is impossible that \(CollectionDiff.Moved) be with \(CollectionDiff.Added) at same time during diffing!")
                XCTAssert(!change.contains(.Stationary),
                    "It is impossible that \(CollectionDiff.Moved) be with \(CollectionDiff.Stationary) at same time during diffing!")
                self.moved.append(fromElement!)
            }
            if change.contains(.Stationary) {
                XCTAssert(!change.contains(.Deleted),
                    "It is impossible that \(CollectionDiff.Stationary) be with \(CollectionDiff.Deleted) at same time during diffing!")
                XCTAssert(!change.contains(.Moved),
                    "It is impossible that \(CollectionDiff.Stationary) be with \(CollectionDiff.Moved) at same time during diffing!")
                XCTAssert(!change.contains(.Added),
                    "It is impossible that \(CollectionDiff.Stationary) be with \(CollectionDiff.Added) at same time during diffing!")
                self.stationary.append(fromElement!)
            }
            if change.contains(.Changed) {
                XCTAssert(!change.contains(.Deleted),
                    "It is impossible that \(CollectionDiff.Changed) be with \(CollectionDiff.Deleted) at same time during diffing!")
                XCTAssert(!change.contains(.Moved),
                    "It is impossible that \(CollectionDiff.Changed) be with \(CollectionDiff.Moved) at same time during diffing!")
                XCTAssert(!change.contains(.Added),
                    "It is impossible that \(CollectionDiff.Changed) be with \(CollectionDiff.Added) at same time during diffing!")
            }
        }
        
        added.sortInPlace()
        removed.sortInPlace()
        moved.sortInPlace()
        stationary.sortInPlace()
        
        XCTAssert(toAdd == added,
            "Equatable diff adding doesn't pass:\n\tTo add:\(toAdd)\n\tAdded:\(added)")
        XCTAssert(toRemove == removed,
            "Equatable diff remove doesn't pass:\n\tTo Remove:\(toRemove)\n\tRemoved:\(removed)")
        XCTAssert(toMove == moved,
            "Equatable diff move doesn't pass:\n\tTo move:\(toMove)\n\tMoved:\(moved)")
        XCTAssert(toBeStationary == stationary,
            "Equatable diff stationary doesn't pass:\n\tTo be stationary:\(toBeStationary)\n\tStationary: \(stationary)")
    }

}
