//
//  Dictionary+BitmaskAccessing.swift
//  Swift-Extended-Library
//
//  Created by Manfred Lau on 1/6/15.
//
//

/**
Set value for a bitmask key in a dictionary

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

public enum BitmaskFallbackStrategy: Int {
    case RightShift, LeftShift
    
    func fallback(value: UInt) -> UInt? {
        switch self {
        case .LeftShift:
            if value == UInt.max {
                return nil
            }
            return value << 1
        case .RightShift:
            if value == UInt.min {
                return nil
            }
            return value >> 1
        }
    }
}

/**
Get value for a bitmask key in a dictionary

- parameter     bitmask:         The bitmask key

- parameter     dictionary:      A storage dictionary

- returns:   Returns value if there were any value set for given bitmask key. Otherwise, returns nil.
*/
public func valueForBitmask<V, B: RawRepresentable where
    B.RawValue == UInt>
    (bitmask: B,
    inDictionary dictionary: [UInt: V])
    -> V?
{
    return valueForBitmask(bitmask,
        inDictionary: dictionary,
        fallback: .RightShift)
}

public func valueForBitmask<V, B: RawRepresentable where
    B.RawValue == UInt>
    (bitmask: B,
    inDictionary dictionary: [UInt: V],
    fallback: BitmaskFallbackStrategy,
    max: B? = nil)
    -> V?
{
    let object = dictionary[bitmask.rawValue]
    
    if object != nil {
        return object
    } else if bitmask.rawValue == 0 {
        return nil
    } else if bitmask.rawValue == max?.rawValue {
        return nil
    } else if bitmask.rawValue == UInt.max {
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