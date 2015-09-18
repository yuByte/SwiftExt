//
//  RawRepresentable+Enumerate.swift
//  Swift-Extended-Library
//
//  Created by Manfred Lau on 6/20/15.
//
//

/**
Bitmask traversal options.

- HandleOccurred: Handle occurred options

- HandleNotOccurred: Handle not occurred options

- ReverselyEnumerate: Enumerate reversely
*/
public struct BitmaskTraversalOptions: OptionSetType {
    public typealias RawValue = UInt
    public let rawValue: RawValue
    
    public init(rawValue value: RawValue) { self.rawValue = value }
    
    public static var HandleOccurred        = BitmaskTraversalOptions(rawValue: 1 << 0)
    public static var HandleNotOccurred     = BitmaskTraversalOptions(rawValue: 1 << 1)
    public static var ReverselyEnumerate    = BitmaskTraversalOptions(rawValue: 1 << 2)
}

/**
Enumerate each occurred/not occurred option in a given RawOptionSetType conformed type value.

- parameter     optionSet:               A RawOptionSetType conformed type value to enumerate

- parameter     options:                 Options instructs enumeration

- parameter     handler:                 Handler to handle enumeration
*/
public func enumerate<B: RawRepresentable where B.RawValue == UInt>(bitmask: B, withOptions options: BitmaskTraversalOptions, usingClosure handler:(bitmask: B, bit: B) -> Bool) {
    
    let shouldHandleOccurred        = options.contains(.HandleOccurred)
    let shouldHandleNotOccurred     = options.contains(.HandleNotOccurred)
    let shouldReverselyEnumerate    = options.contains(.ReverselyEnumerate)
    
    let examinedRawValue  = bitmask.rawValue
    var currentRawValue     = examinedRawValue
    var referenceRawValue   = shouldReverselyEnumerate ? examinedRawValue : 1
    
    var shouldStop = false
    
    while currentRawValue != 0 && !shouldStop {
        if let relativeOption = B(rawValue: referenceRawValue) {
            let hasOccurred = (examinedRawValue | referenceRawValue) != 0
            
            if shouldHandleOccurred && hasOccurred && !shouldStop {
                shouldStop = handler(bitmask: bitmask, bit: relativeOption)
            }
            if shouldHandleNotOccurred && !hasOccurred && !shouldStop {
                shouldStop = handler(bitmask: bitmask, bit: relativeOption)
            }
        }
        
        referenceRawValue = shouldReverselyEnumerate ?
            referenceRawValue >> 1 :
            referenceRawValue << 1
        
        currentRawValue = currentRawValue >> 1
    }
}

/**
Enumerate each occurred/not occurred option in a given RawOptionSetType conformed type value.

- parameter     optionSet:               A RawOptionSetType conformed type value to enumerate

- parameter     options:                 Options instructs enumeration

- parameter     handler:                 Handler to handle enumeration
*/
public func enumerate<B: RawRepresentable where B.RawValue == UInt8>(bitmask: B, withOptions options: BitmaskTraversalOptions, usingClosure handler:(bitmask: B, bit: B) -> Bool) {
    
    let shouldHandleOccurred        = options.contains(.HandleOccurred)
    let shouldHandleNotOccurred     = options.contains(.HandleNotOccurred)
    let shouldReverselyEnumerate    = options.contains(.ReverselyEnumerate)
    
    let examinedRawValue    = bitmask.rawValue
    var currentRawValue       = examinedRawValue
    var referenceRawValue   = shouldReverselyEnumerate ? examinedRawValue : 1
    
    var shouldStop = false
    
    while currentRawValue != 0 && !shouldStop {
        if let relativeOption = B(rawValue: referenceRawValue) {
            let hasOccurred = (examinedRawValue & referenceRawValue) != 0
            
            if shouldHandleOccurred && hasOccurred && !shouldStop {
                shouldStop = handler(bitmask: bitmask, bit: relativeOption)
            }
            if shouldHandleNotOccurred && !hasOccurred && !shouldStop {
                shouldStop = handler(bitmask: bitmask, bit: relativeOption)
            }
        }
        
        referenceRawValue = shouldReverselyEnumerate ?
            referenceRawValue >> 1 :
            referenceRawValue << 1
        
        currentRawValue = currentRawValue >> 1
    }
}

/**
Enumerate each occurred/not occurred option in a given RawOptionSetType conformed type value.

- parameter     optionSet:               A RawOptionSetType conformed type value to enumerate

- parameter     options:                 Options instructs enumeration

- parameter     handler:                 Handler to handle enumeration
*/
public func enumerate<B: RawRepresentable where B.RawValue == UInt16>(bitmask: B, withOptions options: BitmaskTraversalOptions, usingClosure handler:(bitmask: B, bit: B) -> Bool) {
    
    let shouldHandleOccurred        = options.contains(.HandleOccurred)
    let shouldHandleNotOccurred     = options.contains(.HandleNotOccurred)
    let shouldReverselyEnumerate    = options.contains(.ReverselyEnumerate)
    
    let examinedRawValue    = bitmask.rawValue
    var currentRawValue       = examinedRawValue
    var referenceRawValue   = shouldReverselyEnumerate ? examinedRawValue : 1
    
    var shouldStop = false
    
    while currentRawValue != 0 && !shouldStop {
        if let relativeOption = B(rawValue: referenceRawValue) {
            let hasOccurred = (examinedRawValue & referenceRawValue) != 0
            
            if shouldHandleOccurred && hasOccurred && !shouldStop {
                shouldStop = handler(bitmask: bitmask, bit: relativeOption)
            }
            if shouldHandleNotOccurred && !hasOccurred && !shouldStop {
                shouldStop = handler(bitmask: bitmask, bit: relativeOption)
            }
        }
        
        referenceRawValue = shouldReverselyEnumerate ?
            referenceRawValue >> 1 :
            referenceRawValue << 1
        
        currentRawValue = currentRawValue >> 1
    }
}

/**
Enumerate each occurred/not occurred option in a given RawOptionSetType conformed type value.

- parameter     optionSet:               A RawOptionSetType conformed type value to enumerate

- parameter     options:                 Options instructs enumeration

- parameter     handler:                 Handler to handle enumeration
*/
public func enumerate<B: RawRepresentable where B.RawValue == UInt32>(bitmask: B, withOptions options: BitmaskTraversalOptions, usingClosure handler:(bitmask: B, bit: B) -> Bool) {
    
    let shouldHandleOccurred        = options.contains(.HandleOccurred)
    let shouldHandleNotOccurred     = options.contains(.HandleNotOccurred)
    let shouldReverselyEnumerate    = options.contains(.ReverselyEnumerate)
    
    let examinedRawValue    = bitmask.rawValue
    var currentRawValue       = examinedRawValue
    var referenceRawValue   = shouldReverselyEnumerate ? examinedRawValue : 1
    
    var shouldStop = false
    
    while currentRawValue != 0 && !shouldStop {
        if let relativeOption = B(rawValue: referenceRawValue) {
            let hasOccurred = (examinedRawValue & referenceRawValue) != 0
            
            if shouldHandleOccurred && hasOccurred && !shouldStop {
                shouldStop = handler(bitmask: bitmask, bit: relativeOption)
            }
            if shouldHandleNotOccurred && !hasOccurred && !shouldStop {
                shouldStop = handler(bitmask: bitmask, bit: relativeOption)
            }
        }
        
        referenceRawValue = shouldReverselyEnumerate ?
            referenceRawValue >> 1 :
            referenceRawValue << 1
        
        currentRawValue = currentRawValue >> 1
    }
}

/**
Enumerate each occurred/not occurred option in a given RawOptionSetType conformed type value.

- parameter     optionSet:               A RawOptionSetType conformed type value to enumerate

- parameter     options:                 Options instructs enumeration

- parameter     handler:                 Handler to handle enumeration
*/
public func enumerate<B: RawRepresentable where B.RawValue == UInt64>(bitmask: B, withOptions options: BitmaskTraversalOptions, usingClosure handler:(bitmask: B, bit: B) -> Bool) {
    
    let shouldHandleOccurred        = options.contains(.HandleOccurred)
    let shouldHandleNotOccurred     = options.contains(.HandleNotOccurred)
    let shouldReverselyEnumerate    = options.contains(.ReverselyEnumerate)
    
    let examinedRawValue    = bitmask.rawValue
    var currentRawValue       = examinedRawValue
    var referenceRawValue   = shouldReverselyEnumerate ? examinedRawValue : 1
    
    var shouldStop = false
    
    while currentRawValue != 0 && !shouldStop {
        if let relativeOption = B(rawValue: referenceRawValue) {
            let hasOccurred = (examinedRawValue & referenceRawValue) != 0
            
            if shouldHandleOccurred && hasOccurred && !shouldStop {
                shouldStop = handler(bitmask: bitmask, bit: relativeOption)
            }
            if shouldHandleNotOccurred && !hasOccurred && !shouldStop {
                shouldStop = handler(bitmask: bitmask, bit: relativeOption)
            }
        }
        
        referenceRawValue = shouldReverselyEnumerate ?
            referenceRawValue >> 1 :
            referenceRawValue << 1
        
        currentRawValue = currentRawValue >> 1
    }
}