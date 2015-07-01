//
//  Dictionary.swift
//  Swift-Extended-Library
//
//  Created by Manfred Lau on 11/13/14.
//
//

public func +=<K, V> (inout left: Dictionary<K, V>, right: Dictionary<K, V>) -> Dictionary<K, V> {
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
    return left
}