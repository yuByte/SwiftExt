//
//  Dictionary+BitmaskAccessing.swift
//  Swift Extended Library
//
//  Created by Manfred Lau on 1/6/15.
//
//

public func setValue<V>(value: V, forBitmask bitmask: UInt, inout inDictionary dictionary: Dictionary<UInt, V>) {
    dictionary.updateValue(value, forKey: bitmask)
}

public func getValueForBitmask<V>(bitmask: UInt, inDictionary dictionary: [UInt: V]) -> V? {
    let object = dictionary[bitmask]
    if (object != nil) {
        return object
    } else if bitmask == 0 {
        return nil
    } else {
        let nextBitmask = bitmask >> 1
        return getValueForBitmask(nextBitmask, inDictionary: dictionary)
    }
}