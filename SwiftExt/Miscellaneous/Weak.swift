//
//  Weak.swift
//  SwiftExt
//
//  Created by Manfred on 7/26/15.
//
//

public struct Weak<T: AnyObject>: Hashable {
    private weak var _value: T?
    public weak var value: T? { return _value }
    public init(_ aValue: T) { _value = aValue }
    
    public var hashValue: Int {
        guard let value = self.value else { return 0 }
        return ObjectIdentifier(value).hashValue
    }
}

public func ==<T: AnyObject>(lhs: Weak<T>, rhs: Weak<T>) -> Bool {
    return lhs.value === rhs.value
}
