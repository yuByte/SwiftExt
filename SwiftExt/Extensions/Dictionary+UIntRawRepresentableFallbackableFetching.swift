//
//  Dictionary+UIntRawRepresentableFallbackableFetching.swift
//  SwiftExt
//
//  Created by Manfred Lau on 1/6/15.
//
//

/**
`BitmaskFallback` defines the pattern of falling back of a bitmask.
*/
public enum BitmaskFallback<B: RawRepresentable> {
    case RightShift, LeftShift(max: B)
    
    typealias Bitmask = B
    typealias BitmaskRawValue = B.RawValue
}

extension BitmaskFallback where B.RawValue == UInt {
    /**
    Fall the bitmask back by following the given pattern.
    - parameter     value:      The original value
    - returns:      The fallbacked value. Can be nil if the original value is
    the min or max value of the bitmask's `RawValue` type. It also can be nil
    if the original value is greater than or equal to a given max value when
    the fallback pattern is `LeftShift`.
    */
    func fallback(value: BitmaskRawValue) -> BitmaskRawValue? {
        switch self {
        case let .LeftShift(max):
            if value == BitmaskRawValue.max || value >= max.rawValue {
                return nil
            }
            return value << 1
        case .RightShift:
            if value == BitmaskRawValue.min {
                return nil
            }
            return value >> 1
        }
    }
}

/**
Set value with a bitmask key in a dictionary. The dictionary must use UInt as
its `Key` type.

- parameter     value:           Value to be set

- parameter     bitmask:         The bitmask key

- parameter     dictionary:      A storage dictionary
*/
public func updateValue<V, B: RawRepresentable where B.RawValue == UInt>
    (value: V, forBitmask bitmask: B,
    inout inDictionary dictionary: Dictionary<UInt, V>)
{
    dictionary.updateValue(value, forKey: bitmask.rawValue)
}

/**
Get value for a bitmask key in a dictionary. The dictionary must use UInt as its
`Key` type.

- parameter     bitmask:        The bitmask key

- parameter     dictionary:     The storage dictionary

- parameter     fallback:       The pattern of falling back.

- returns:      Returns value if there is any stored value for given bitmask key
or its valid fallbacks. Otherwise, returns nil.
*/
public func valueForBitmask<V, B: RawRepresentable where
    B.RawValue == UInt>
    (bitmask: B,
    inDictionary dictionary: [B.RawValue: V],
    fallback: BitmaskFallback<B> = .RightShift)
    -> V?
{
    let object = dictionary[bitmask.rawValue]
    
    if object != nil {
        return object
    } else if bitmask.rawValue == 0 {
        return nil
    } else if bitmask.rawValue == B.RawValue.max {
        return nil
    } else {
        if let fallbackValue = fallback.fallback(bitmask.rawValue) {
            if let nextBitmask = B(rawValue: fallbackValue) {
                return valueForBitmask(nextBitmask,
                    inDictionary: dictionary,
                    fallback: fallback)
            }
        }
        return nil
    }
}