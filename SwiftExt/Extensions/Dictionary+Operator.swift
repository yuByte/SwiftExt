//
//  Dictionary+Operator.swift
//  SwiftExt
//
//  Created by Manfred Lau on 11/13/14.
//
//

public func +=<K, V> (inout left: Dictionary<K, V>,
    right: Dictionary<K, V>)
    -> Dictionary<K, V>
{
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
    return left
}

public func -=<K, V> (inout left: Dictionary<K, V>,
    right: Dictionary<K, V>)
    -> Dictionary<K, V>
{
    for k in right.keys {
        left.removeValueForKey(k)
    }
    return left
}