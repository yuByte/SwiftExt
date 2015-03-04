//
//  EnumerateRawOptionSetType.swift
//  Swift Extended Library
//
//  Created by Manfred Lau on 10/13/14.
//
//

infix operator |? { associativity left precedence 120}
public func |? <T where T: BitwiseOperationsType, T: Equatable> (left: T, right: T) -> Bool {
    return (right & left) != T.allZeros
}

infix operator !|? { associativity left precedence 120}
public func !|? <T where T: BitwiseOperationsType, T: Equatable> (left: T, right: T) -> Bool {
    return (right & left) == T.allZeros
}

public struct OptionSetTraversalOptions: RawOptionSetType {
    public typealias RawValue = UInt
    public let rawValue: RawValue
    
    public init(_ value: RawValue) { self.rawValue = value }
    public init(rawValue value: RawValue) { self.rawValue = value }
    public init(nilLiteral: ()) { self.rawValue = 0 }
    
    public static var allZeros: OptionSetTraversalOptions                    { return self(0) }
    
    public static var HandleOccurred: OptionSetTraversalOptions              { return self(1 << 0) }
    public static var HandleNotOccurred: OptionSetTraversalOptions           { return self(1 << 1) }
    public static var ReverselyEnumerate: OptionSetTraversalOptions          { return self(1 << 2) }
}

public func enumerate<T: RawOptionSetType where T.RawValue == UInt>(optionSet: T, withOptions options: OptionSetTraversalOptions, usingClosure handler:(optionSet: T, option: T) -> Bool ) {
    let shouldHandleOccurred        = options |? .HandleOccurred
    let shouldHandleNotOccurred     = options |? .HandleNotOccurred
    let shouldReverselyEnumerate    = options |? .ReverselyEnumerate
    
    let examinedRawValue    = optionSet.rawValue
    var indexRawValue       = examinedRawValue
    var referenceRawValue   = shouldReverselyEnumerate ? examinedRawValue : 1
    
    var shouldStop = false
    
    while indexRawValue != 0 && !shouldStop {
        let hasOccurred = examinedRawValue |? referenceRawValue
        
        if shouldHandleOccurred && hasOccurred && !shouldStop
            { shouldStop = handler(optionSet: optionSet, option: T(rawValue: referenceRawValue))}
        if shouldHandleNotOccurred && !hasOccurred && !shouldStop
            { shouldStop = handler(optionSet: optionSet, option: T(rawValue: referenceRawValue))}
        
        referenceRawValue = shouldReverselyEnumerate ? referenceRawValue >> 1 : referenceRawValue << 1
        
        indexRawValue = indexRawValue >> 1
    }
}