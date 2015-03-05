//
//  Dictionary+BitmaskAccessing.swift
//  Swift Extended Library
//
//  Created by Manfred Lau on 1/6/15.
//
//

/**
Set value for a bitmask key in a dictionary

:param:     value           Value to be set

:param:     bitmask         The bitmask key

:param:     dictionary      A storage dictionary
*/
public func setValue<V, B: RawOptionSetType where B.RawValue == UInt>(value: V, forBitmask bitmask: B, inout inDictionary dictionary: Dictionary<UInt, V>) {
    dictionary.updateValue(value, forKey: bitmask.rawValue)
}

/**
Get value for a bitmask key in a dictionary

:param:     bitmask         The bitmask key

:param:     dictionary      A storage dictionary

:returns:   Returns value if there were any value set for given bitmask key. Otherwise, returns nil.
*/
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