//
//  Dictionary+UIntOptionSetTypeFallbackableFetching.swift
//  SwiftExt
//
//  Created by Manfred on 9/19/15.
//
//

public enum OptionSetFallback<O: OptionSetType> {
    case RightShift, LeftShift(max: O)
    
    typealias OptionSet = O
    typealias OptionSetRawValue = O.RawValue
}

extension Dictionary where Key: OptionSetType, Key.RawValue == UInt {
    public func valueForKey(key: Key,
        fallback: OptionSetFallback<Key>)
        -> Value?
    {
        let object = self[key]
        
        if object != nil {
            return object
        } else if key.rawValue == 0 {
            return nil
        } else if key.rawValue == Key.RawValue.max {
            return nil
        } else {
            if let fallbackValue = fallback.fallback(key.rawValue) {
                let nextBitmask = Key(rawValue: fallbackValue)
                return valueForKey(nextBitmask,
                    fallback: fallback)
            }
            return nil
        }
    }
}

extension OptionSetFallback where O.RawValue == UInt {
    func fallback(value: OptionSetRawValue) -> OptionSetRawValue? {
        switch self {
        case let .LeftShift(max):
            if value == OptionSetRawValue.max || value == max.rawValue {
                return nil
            }
            return (value << OptionSetRawValue(1))
        case .RightShift:
            if value == OptionSetRawValue.min {
                return nil
            }
            return (value >> OptionSetRawValue(1))
        }
    }
}

extension Dictionary where Key: OptionSetType, Key.RawValue == UInt8 {
    public func valueForKey(key: Key,
        fallback: OptionSetFallback<Key>)
        -> Value?
    {
        let object = self[key]
        
        if object != nil {
            return object
        } else if key.rawValue == 0 {
            return nil
        } else if key.rawValue == Key.RawValue.max {
            return nil
        } else {
            if let fallbackValue = fallback.fallback(key.rawValue) {
                let nextBitmask = Key(rawValue: fallbackValue)
                return valueForKey(nextBitmask,
                    fallback: fallback)
            }
            return nil
        }
    }
}

extension OptionSetFallback where O.RawValue == UInt8 {
    func fallback(value: OptionSetRawValue) -> OptionSetRawValue? {
        switch self {
        case let .LeftShift(max):
            if value == OptionSetRawValue.max || value == max.rawValue {
                return nil
            }
            return (value << OptionSetRawValue(1))
        case .RightShift:
            if value == OptionSetRawValue.min {
                return nil
            }
            return (value >> OptionSetRawValue(1))
        }
    }
}

extension Dictionary where Key: OptionSetType, Key.RawValue == UInt16 {
    public func valueForKey(key: Key,
        fallback: OptionSetFallback<Key>)
        -> Value?
    {
        let object = self[key]
        
        if object != nil {
            return object
        } else if key.rawValue == 0 {
            return nil
        } else if key.rawValue == Key.RawValue.max {
            return nil
        } else {
            if let fallbackValue = fallback.fallback(key.rawValue) {
                let nextBitmask = Key(rawValue: fallbackValue)
                return valueForKey(nextBitmask,
                    fallback: fallback)
            }
            return nil
        }
    }
}

extension OptionSetFallback where O.RawValue == UInt16 {
    func fallback(value: OptionSetRawValue) -> OptionSetRawValue? {
        switch self {
        case let .LeftShift(max):
            if value == OptionSetRawValue.max || value == max.rawValue {
                return nil
            }
            return (value << OptionSetRawValue(1))
        case .RightShift:
            if value == OptionSetRawValue.min {
                return nil
            }
            return (value >> OptionSetRawValue(1))
        }
    }
}

extension Dictionary where Key: OptionSetType, Key.RawValue == UInt32 {
    public func valueForKey(key: Key,
        fallback: OptionSetFallback<Key>)
        -> Value?
    {
        let object = self[key]
        
        if object != nil {
            return object
        } else if key.rawValue == 0 {
            return nil
        } else if key.rawValue == Key.RawValue.max {
            return nil
        } else {
            if let fallbackValue = fallback.fallback(key.rawValue) {
                let nextBitmask = Key(rawValue: fallbackValue)
                return valueForKey(nextBitmask,
                    fallback: fallback)
            }
            return nil
        }
    }
}

extension OptionSetFallback where O.RawValue == UInt32 {
    func fallback(value: OptionSetRawValue) -> OptionSetRawValue? {
        switch self {
        case let .LeftShift(max):
            if value == OptionSetRawValue.max || value == max.rawValue {
                return nil
            }
            return (value << OptionSetRawValue(1))
        case .RightShift:
            if value == OptionSetRawValue.min {
                return nil
            }
            return (value >> OptionSetRawValue(1))
        }
    }
}

extension Dictionary where Key: OptionSetType, Key.RawValue == UInt64 {
    public func valueForKey(key: Key,
        fallback: OptionSetFallback<Key>)
        -> Value?
    {
        let object = self[key]
        
        if object != nil {
            return object
        } else if key.rawValue == 0 {
            return nil
        } else if key.rawValue == Key.RawValue.max {
            return nil
        } else {
            if let fallbackValue = fallback.fallback(key.rawValue) {
                let nextBitmask = Key(rawValue: fallbackValue)
                return valueForKey(nextBitmask,
                    fallback: fallback)
            }
            return nil
        }
    }
}

extension OptionSetFallback where O.RawValue == UInt64 {
    func fallback(value: OptionSetRawValue) -> OptionSetRawValue? {
        switch self {
        case let .LeftShift(max):
            if value == OptionSetRawValue.max || value == max.rawValue {
                return nil
            }
            return (value << OptionSetRawValue(1))
        case .RightShift:
            if value == OptionSetRawValue.min {
                return nil
            }
            return (value >> OptionSetRawValue(1))
        }
    }
}