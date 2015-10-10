//
//  MultiTransactionCoalescer.swift
//  SwiftExt
//
//  Created by Manfred on 10/2/15.
//
//

/**
`MultiTransactionCoalescer` assumes changes in each transaction and its nested
transactions are described based on a same snapshot of data, but those in coming
transactions and their nested transactions are not.

- Discussion: Transactions of Update.
Considering the following update:

                   +-------------- Transaction --------------+
                   |                                         |
                   |                                         |
                   |                                         |
        Snapshot Before Update                     Snapshot After Update

--------+-----------------------------------------------------------------------
Row No. |                              Value
--------+-----------------------------------------------------------------------
        |
0       |          0                                         0
        |
1       |          1                                         1
        |                       == Delete Row 3 =>
2       |          2                                         2
        |                       == Insert Row 4 =>
3       |          3                                         4
        |
4       |          4                                         5
        |
--------+-----------------------------------------------------------------------

In the previous update example, *Delete Row 3* described the row in the snapshot
before the transaction and *Insert Row 4* described the row in the snapshot 
after the transaction. Thus we can be aware of that for an update transaction,
update actions are described based on different time of the transaction - some
of them are before the transaction and some of them are after.

For all supported update actions: 
Insert      : Describe based on snapshot *AFTER* transaction.
Delete      : Describe based on snapshot *BEFORE* transaction.
Move        : Describe based on snapshot *BEFORE* transaction.
Update      : Describe based on snapshot *BEFORE* transaction.

Due to such a thing, there are two common conventions in many update system:
1) Defers all update actions described based on the snapshot after transaction.
2) Process all update actions described based on the snapshot before transaction
at first by following: Update -> Move -> Deletion.

And `MultiTransactionCoalescer` assumes that your update system following such 
two conventions.
*/

private enum ItemChangesRelation: Int {
    case NoRelation
    case Inverse
    case Overriding
    case Overridden
    case Duplicate
}

public enum ItemChange<I: PrimitiveIndexPathType>: Equatable {
    case Insert(I)
    case Delete(I)
    case Move(from: I, to: I)
    case Update(I)
    
    /**
    - Discussion: This function assumes you passed a same-transaction item 
    change in to it
    */
    private func relationWithItemChange(itemChange: ItemChange<I>)
        -> ItemChangesRelation
    {
        switch (self, itemChange) {
        case let (.Insert(selfIndexPath), .Insert(indexPath))
            where selfIndexPath == indexPath:
            return .Duplicate
            
        case let (.Delete(selfIndexPath), .Delete(indexPath))
            where selfIndexPath == indexPath:
            return .Duplicate
            
        case let (.Delete(selfIndexPath), .Move(from, _))
            where selfIndexPath == from:
            return .Overriding
            
        case let (.Move(selfFrom, selfTo), .Move(from, to))
            where selfFrom == to && selfTo == from:
            return .Inverse
            
        case let (.Move(selfFrom, _), .Delete(indexPath))
            where selfFrom == indexPath:
            return .Overridden
            
        case let (.Update(selfIndexPath), .Update(indexPath))
            where selfIndexPath == indexPath:
            return .Duplicate
            
        case let (.Update(selfIndexPath), .Delete(indexPath))
            where selfIndexPath == indexPath:
            return .Duplicate
            
        default:
            return .NoRelation
        }
    }
    
    private func hasTheSameScopeWithItemChange(itemChange: ItemChange<I>)
        -> Bool
    {
        switch (self, itemChange) {
        case let (.Insert(selfIndexPath), .Insert(indexPath))
            where selfIndexPath.length == indexPath.length:
            return true
        case let (.Insert(selfIndexPath), .Delete(indexPath))
            where selfIndexPath.length == indexPath.length:
            return true
        case let (.Insert(selfIndexPath), .Move(from, to))
            where selfIndexPath.length == from.length ||
                selfIndexPath.length == to.length:
            return true
        case let (.Insert(selfIndexPath), .Update(indexPath))
            where selfIndexPath.length == indexPath.length:
            return true
            
            
        case let (.Delete(selfIndexPath), .Insert(indexPath))
            where selfIndexPath.length == indexPath.length:
            return true
        case let (.Delete(selfIndexPath), .Delete(indexPath))
            where selfIndexPath.length == indexPath.length:
            return true
        case let (.Delete(selfIndexPath), .Move(from, to))
            where selfIndexPath.length == from.length ||
                selfIndexPath.length == to.length:
            return true
        case let (.Delete(selfIndexPath), .Update(indexPath))
            where selfIndexPath.length == indexPath.length:
            return true
            
            
        case let (.Move(selfForm, selfTo), .Insert(indexPath))
            where selfForm.length == indexPath.length ||
                selfTo.length == indexPath.length:
            return true
        case let (.Move(selfForm, selfTo), .Delete(indexPath))
            where selfForm.length == indexPath.length ||
                selfTo.length == indexPath.length:
            return true
        case let (.Move(selfForm, selfTo), .Move(from, to))
            where selfForm.length == from.length ||
                selfForm.length == to.length ||
                selfTo.length == from.length ||
                selfTo.length == to.length:
            return true
        case let (.Move(selfForm, selfTo), .Update(indexPath))
            where selfForm.length == indexPath.length ||
                selfTo.length == indexPath.length:
            return true
            
            
        case let (.Update(selfIndexPath), .Insert(indexPath))
            where selfIndexPath.length == indexPath.length:
            return true
        case let (.Update(selfIndexPath), .Delete(indexPath))
            where selfIndexPath.length == indexPath.length:
            return true
        case let (.Update(selfIndexPath), .Move(from, to))
            where selfIndexPath.length == from.length ||
                selfIndexPath.length == to.length:
            return true
        case let (.Update(selfIndexPath), .Update(indexPath))
            where selfIndexPath.length == indexPath.length:
            return true
            
        default: return false
        }
    }
}

public func == <I: PrimitiveIndexPathType>
    (lhs: ItemChange<I>, rhs: ItemChange<I>)
    -> Bool
{
    switch (lhs, rhs) {
    case let (.Insert(lhsIndexPath), .Insert(rhsIndexPath)):
        return lhsIndexPath == rhsIndexPath
    case let (.Delete(lhsIndexPath), .Delete(rhsIndexPath)):
        return lhsIndexPath == rhsIndexPath
    case let (.Move(lhsFrom, lhsTo), .Move(rhsFrom, rhsTo)):
        return lhsFrom == rhsFrom && lhsTo == rhsTo
    case let (.Update(lhsIndexPath), .Update(rhsIndexPath)):
        return lhsIndexPath == rhsIndexPath
    default:
        return false
    }
}

public enum ItemChangesCrossTransactionCoalesceTiming: Int {
    case WhenRootTransactionEnd
    case WhenPop
}

public class MultiTransactionCoalescer<I: PrimitiveIndexPathType> {
    
    public typealias IndexPath = I
    
    private typealias ItemChangeTransaction = [ItemChange<IndexPath>]
    
    private var closedTransactions: [ItemChangeTransaction] = []
    private var openTransaction: ItemChangeTransaction = []
    
    private var interactiveTransactionCount: Int = 0
    
    public var coalesceTiming: ItemChangesCrossTransactionCoalesceTiming
    
    public var isEmpty: Bool {
        return closedTransactions.count == 0 && openTransaction.count == 0
    }
    
    public var isInTransaction: Bool {
        return interactiveTransactionCount != 0
    }
    
    public init(
        coalesceTiming: ItemChangesCrossTransactionCoalesceTiming = .WhenPop)
    {
        self.coalesceTiming = coalesceTiming
    }
    
    public func beginTransaction() {
        interactiveTransactionCount += 1
    }
    
    public func endTransaction() {
        interactiveTransactionCount -= 1
        
        if interactiveTransactionCount == 0 {
            if openTransaction.count > 0 {
                closedTransactions.append(openTransaction)
                openTransaction = []
                if coalesceTiming == .WhenRootTransactionEnd {
                    let coalescedChagnes = self.coalescedChagnes()
                    closedTransactions = [coalescedChagnes]
                }
            }
        }
    }
    
    public func push(pendingChange: ItemChange<IndexPath>) {
        for (indexOfChange, change) in openTransaction.reverse().enumerate() {
            switch change.relationWithItemChange(pendingChange) {
            case .NoRelation:   continue
            case .Duplicate:    return
            case .Overridden:   return
            case .Overriding:
                openTransaction[indexOfChange] = pendingChange
                return
            case .Inverse:
                openTransaction.removeAtIndex(indexOfChange)
                return
            }
        }
        
        openTransaction.append(pendingChange)
    }
    
    public func pushInsertion(index: IndexPath) {
        let pendingChange: ItemChange<IndexPath> = .Insert(index)
        push(pendingChange)
    }
    
    public func pushDeletion(index: IndexPath) {
        let pendingChange: ItemChange<IndexPath> = .Delete(index)
        push(pendingChange)
    }
    
    public func pushUpdate(index: IndexPath) {
        let pendingChange: ItemChange<IndexPath> = .Update(index)
        push(pendingChange)
    }
    
    public func pushMoveFrom(fromIndex: IndexPath,
        to toIndex: IndexPath)
    {
        let pendingChange: ItemChange<IndexPath> = .Move(
            from: fromIndex,
            to: toIndex)
        push(pendingChange)
    }
    
    public func pop() -> [ItemChange<IndexPath>] {
        guard interactiveTransactionCount == 0 else {
            fatalError("Inbalanced begin/endTransaction() call!")
        }
        
        let coalescedChagnes = self.coalescedChagnes()
        closedTransactions.removeAll()
        return coalescedChagnes
    }
    
    private func pushSuccedingTransactionChange(
        var succedingTrnsactionChange: ItemChange<IndexPath>,
        inout inToPrecedingTransaction
        precedingTransaction: [ItemChange<IndexPath>])
        -> Void
    {
        var eliminatedChangesInPrecedingTransaction = 0
        
        var shouldPush = true
        
        // Do eliminate in this loop
        for (index, coalescedChange) in precedingTransaction.enumerate()
            where succedingTrnsactionChange
                .hasTheSameScopeWithItemChange(coalescedChange)
        {
            // Tough there are appendings to preceding transaction, but due to
            // there are appended to the end of the array, it doesn't affect
            // the index value of existed changes
            let affectedIndex = index + eliminatedChangesInPrecedingTransaction
            
            switch (coalescedChange, succedingTrnsactionChange) {
            case let (.Insert(coalescedIndexPath),
                .Insert(uncoalescedIndexPath)):
                
                /* I did a trick here:
                For repeatedly inserting the same index path or inserting homo-
                length(refers to the length property in the type of IndexPath) 
                descending index paths cross transactions, it results that the
                last index of index paths inserted in coming transactions should
                be increased by 1 when mapping the coming transactions to the
                first transaction.
                
                Consider transactions below:
                
                --- Transaction 1 ->- Transaction 2 ->- Transaction 3 ---
                
                    Insert Row 0      Insert Row 0      Insert Row 0
                
                
                Those transactions exactly mean a coalesced transaction:
                
                --- Transaction 1' ---
                
                    Insert Row 2 (Insert Row 0 in Transaction 1)
                
                    Insert Row 1 (Insert Row 0 in Transaction 2)
                
                    Insert Row 0 (Insert Row 0 in Transaction 3)
                
                But since modifying existed insertion info to make such an
                adjustion has an almost equal effect to modifying the pending
                insertion here, I used the second way to do the adjustion.
                
                --- Transaction 1'' ---
                
                    Insert Row 0 (Insert Row 0 in Transaction 1)
                
                    Insert Row 1 (Insert Row 0 in Transaction 2)
                
                    Insert Row 2 (Insert Row 0 in Transaction 3)
                
                */
                if coalescedIndexPath >= uncoalescedIndexPath {
                    succedingTrnsactionChange =
                        .Insert(uncoalescedIndexPath.successor())
                }
                
            case let (.Insert(coalescedIndexPath),
                .Delete(uncoalescedIndexPath)):
                
                if coalescedIndexPath == uncoalescedIndexPath {
                    precedingTransaction.removeAtIndex(affectedIndex)
                    eliminatedChangesInPrecedingTransaction += 1
                }
            case (.Insert, .Move): break
                
            case let (.Insert(coalescedIndexPath),
                .Update(uncoalescedIndexPath)):
                
                if coalescedIndexPath == uncoalescedIndexPath {
                    shouldPush = false
                }
                
                
                
            case (.Delete, .Insert): break
            case let (.Delete(coalescedIndexPath),
                .Delete(uncoalescedIndexPath)):
                
                /*
                For repeatedly deleting the same index path or deleing homo-
                length(refers to the length property in the type of IndexPath)
                ascending index paths cross transactions, it results that the
                last index of index paths deleted in coming transactions should
                be increased by 1 when mapping the coming transactions to the
                first transaction.
                
                Consider transactions below:
                
                --- Transaction 1 ->- Transaction 2 ->- Transaction 3 ---
                
                    Delete Row 0      Delete Row 0      Delete Row 0
                
                
                Those transactions exactly mean a coalesced transaction:
                
                --- Transaction 1' ---
                
                    Delete Row 0 (Insert Row 0 in Transaction 1)
                
                    Delete Row 1 (Insert Row 0 in Transaction 2)
                
                    Delete Row 2 (Insert Row 0 in Transaction 3)
                */
                
                if coalescedIndexPath <= uncoalescedIndexPath {
                    succedingTrnsactionChange =
                        .Delete(uncoalescedIndexPath.successor())
                }
                
            case let (.Delete(coalescedIndexPath),
                .Move(_, uncoalescedTo)):
                
                if coalescedIndexPath <= uncoalescedTo {
                    precedingTransaction.removeAtIndex(affectedIndex)
                    eliminatedChangesInPrecedingTransaction += 1
                    shouldPush = false
                }
                
            case let (.Delete(coalescedIndexPath),
                .Update(uncoalescedIndexPath)):
                
                if coalescedIndexPath == uncoalescedIndexPath {
                    shouldPush = false
                }
                
                
                
            case (.Move, .Insert): break
            case let (.Move(coalescedFrom, coalescedTo),
                .Delete(uncoalescedIndexPath)):
                
                if uncoalescedIndexPath < coalescedTo {
                    precedingTransaction[affectedIndex] =
                        .Move(from: coalescedFrom,
                        to: coalescedTo.predecessor())
                }
                
                if uncoalescedIndexPath == coalescedTo {
                    precedingTransaction[affectedIndex] =
                        .Delete(coalescedFrom)
                    shouldPush = false
                }
                
            case let (.Move(coalescedFrom, coalescedTo),
                .Move(uncoalescedFrom, uncoalescedTo)):
                
                if coalescedFrom == uncoalescedTo &&
                    coalescedTo == uncoalescedFrom
                {
                    precedingTransaction.removeAtIndex(affectedIndex)
                    eliminatedChangesInPrecedingTransaction += 1
                    shouldPush = false
                }
                
            case (.Move, .Update): break
                
                
                
            case (.Update, .Insert): break
                
            case (.Update, .Delete): break
                
            case (.Update, .Move): break
                
            case let (.Update(coalescedIndexPath),
                .Update(uncoalescedIndexPath)):
                
                if coalescedIndexPath == uncoalescedIndexPath {
                    shouldPush = false
                }
            }
        }
        
        if shouldPush {
            precedingTransaction.append(succedingTrnsactionChange)
        }
    }
    
    private func coalescedChagnes() -> [ItemChange<IndexPath>] {
        typealias ItemChangeType = ItemChange<IndexPath>
        
        var coalescedChanges = [ItemChangeType]()
        
        // Only coalesce for two or more closed transactions
        guard closedTransactions.count > 1 else { return closedTransactions[0] }
        
        let uncoalescedTransactions = closedTransactions
        
        for eachUncoalescedTransaction in uncoalescedTransactions {
            for eachUncoalesced in eachUncoalescedTransaction {
                
                pushSuccedingTransactionChange(eachUncoalesced,
                    inToPrecedingTransaction: &coalescedChanges)
            }
        }
        
        return coalescedChanges
    }
}