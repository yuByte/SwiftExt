//
//  JSON.swift
//
//
//  Created by ZHANG Yi on 2015-9-1.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2015 ZHANG Yi <zhangyi.cn@gmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to 
//  deal in the Software without restriction, including without limitation the 
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or 
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in 
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//

public enum JSON {
    case String(Swift.String)
    case Integer(Int)
    case Float(Double)
    case Boolean(Bool)
    case Null
    indirect case Array([JSON])
    indirect case Object([Swift.String: JSON])
}

extension JSON {
    public var value: Any? {
        switch self {
        case .String(let value):    return value
        case .Integer(let value):   return value
        case .Float(let value):     return value
        case .Boolean(let value):   return value
        case .Null:                 return nil
        case .Array(let array):     return array.map { $0.value }
        case .Object(let dict):
            var dictValue: [Swift.String: Any] = [:]
            for (key, value) in dict {
                dictValue[key] = value.value
            }
            return dictValue
        }
    }
}

extension JSON {
    public init() {
        self = .Object([:])
    }
}

extension JSON: CustomStringConvertible {
    public var description: Swift.String {
        switch self {
        case .String(let value):    return "\"\(value)\""
        case .Integer(let value):   return "\(value)"
        case .Float(let value):     return "\(value)"
        case .Boolean(let value):   return "\(value)"
        case .Null:                 return "null"
        case .Array(let value):
            return "[" + value.map { $0.description }.joinWithSeparator(", ") + "]"
        case .Object(let value):
            return "{" + value.map { "\(JSON.String($0).description): \($1.description)" }.joinWithSeparator(", ") + "}"
        }
    }
}

extension JSON {
    public subscript(index: Int) -> JSON? {
        switch self {
        case .Array(let value):     return value[index]
        default:                    return nil
        }
    }
    
    public subscript(key: Swift.String) -> JSON? {
        switch self {
        case .Object(let value):    return value[key]
        default:                    return nil
        }
    }
}

extension JSON: NilLiteralConvertible {
    public init(nilLiteral: ()) {
        self = .Null
    }
}

extension JSON: StringLiteralConvertible {
    public init(unicodeScalarLiteral value: StringLiteralType) {
        self = .String(value)
    }
    
    public init(extendedGraphemeClusterLiteral value: StringLiteralType) {
        self = .String(value)
    }
    
    public init(stringLiteral value: StringLiteralType) {
        self = .String(value)
    }
}

extension JSON: ArrayLiteralConvertible {
    public init(arrayLiteral elements: JSON...) {
        self = .Array(elements)
    }
}

extension JSON: DictionaryLiteralConvertible {
    public init(dictionaryLiteral elements: (Swift.String, JSON)...) {
        var dict = [Key: Value]()
        elements.forEach { (k, v) in
            dict[k] = v
        }
        self = .Object(dict)
    }
}

extension JSON: FloatLiteralConvertible {
    public init(floatLiteral value: Double) {
        self = .Float(value)
    }
}

extension JSON: IntegerLiteralConvertible {
    public init(integerLiteral value: Int) {
        self = .Integer(value)
    }
}

extension JSON: BooleanLiteralConvertible {
    public init(booleanLiteral value: Bool) {
        self = .Boolean(value)
    }
}

import Foundation
public protocol JSONConvertible {
    func asJSON() -> JSON
}

extension JSON {
    public struct SerializationFailed: ErrorType {
        let on: AnyObject
    }
    
    public init(_ object: AnyObject) throws {
        switch object {
        case let string as Swift.String:
            self = .String(string)
        case let number as NSNumber:
            switch CFNumberGetType(number) {
            case .FloatType: fallthrough
            case .Float32Type: fallthrough
            case .Float64Type: fallthrough
            case .CGFloatType: fallthrough
            case .DoubleType:
                self = .Float(number.doubleValue)
            case .CharType:
                self = .Boolean(number.boolValue)
            default:
                self = .Integer(number.integerValue)
            }
        case let arrayValue as [AnyObject]:
            self = .Array(try arrayValue.map { try JSON($0) })
        case let dictValue as [Swift.String: AnyObject]:
            var dict: [Swift.String: JSON] = [:]
            
            for (key, value) in dictValue {
                dict[key] = try JSON(value)
            }
            
            for (k, v) in zip(dictValue.keys, try dictValue.values.map { try JSON($0) }) {
                dict[k] = v
            }
            self = .Object(dict)
        case is NSNull:
            self = .Null
        case let v as JSONConvertible:
            self = v.asJSON()
        default:
            throw SerializationFailed(on: object)
        }
    }
}

extension NSJSONSerialization {
    public class func JSONWithData(data: NSData, options: NSJSONReadingOptions) throws -> JSON {
        let object = try self.JSONObjectWithData(data, options: options)
        return try JSON(object)
    }
}


extension NSDate: JSONConvertible {
    public func asJSON() -> JSON {
        return .Float(self.timeIntervalSince1970)
    }
}