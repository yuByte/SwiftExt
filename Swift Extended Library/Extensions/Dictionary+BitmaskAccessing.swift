//
//  Dictionary+BitmaskAccessing.swift
//  Swift Extended Library
//
//  Created by Manfred Lau on 1/6/15.
//
//

public func setValue<V, B: RawOptionSetType where B.RawValue == UInt>(value: V, forBitmask bitmask: B, inout inDictionary dictionary: Dictionary<UInt, V>) {
    dictionary.updateValue(value, forKey: bitmask.rawValue)
}

public func getValueForBitmask<V, B: RawOptionSetType where B.RawValue == UInt>(bitmask: B, inDictionary dictionary: [UInt: V]) -> V? {
    let object = dictionary[bitmask.rawValue]
    if (object != nil) {
        return object
    } else if bitmask.rawValue == 0 {
        return nil
    } else {
        let nextBitmask = bitmask.rawValue >> 1
        return getValueForBitmask(B(rawValue: nextBitmask), inDictionary: dictionary)
    }
}