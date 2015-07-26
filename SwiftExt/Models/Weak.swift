//
//  Weak.swift
//  SwiftExt
//
//  Created by Manfred on 7/26/15.
//
//

public struct Weak<T: AnyObject> {
    private weak var _value: T?
    public weak var value: T? { return _value }
    public init(_ aValue: T) { _value = aValue }
}
