//
//  Fraction.swift
//  Swift Extended Library
//
//  Created by Manfred Lau on 1/6/15.
//
//

public struct Fraction: Equatable, DebugPrintable, Printable {
    public var numerator: Int
    public var denominator: Int
    
    public var doubleValue: Double {
        return Double(numerator) / Double(denominator)
    }
    
    public var integerValue: Int {
        return numerator % denominator
    }
}

extension Fraction: FloatLiteralConvertible {
    public init(floatLiteral value: FloatLiteralType) {
        // As float point number in computer rarely has a real precision
        // Let's get the visible part by convert it into a string
        let valueString = value.description
        if let dotPosition = find(valueString, ".") {
            let decimalPartLength = distance(valueString.startIndex, advance(valueString.endIndex, -1))
            let enlarged = 10 ^^ decimalPartLength
            self = Fraction(numerator: Int(value) * enlarged, denominator: enlarged)
        } else {
            self = Fraction(numerator: 1, denominator: 1)
        }
    }
}

extension Fraction: IntegerLiteralConvertible {
    public init(integerLiteral value: IntegerLiteralType) {
        self = Fraction(numerator: value, denominator: 1)
    }
}

extension Fraction: Equatable, DebugPrintable, Printable {
    public var description: String {
        return "\(numerator)/\(denominator)"
    }
    
    public var debugDescription: String {
        return description
    }
}

public func +(lhs: Fraction, rhs: Fraction) -> Fraction {
    if lhs.denominator != rhs.denominator {
        return Fraction(numerator: lhs.numerator * rhs.denominator + rhs.numerator * lhs.denominator,
            denominator: lhs.denominator * rhs.denominator)
    } else {
        return Fraction(numerator: lhs.numerator + rhs.numerator, denominator: lhs.denominator)
    }
}

public func -(lhs: Fraction, rhs: Fraction) -> Fraction {
    if lhs.denominator != rhs.denominator {
        return Fraction(numerator: lhs.numerator * rhs.denominator - rhs.numerator * lhs.denominator,
            denominator: lhs.denominator * rhs.denominator)
    } else {
        return Fraction(numerator: lhs.numerator + rhs.numerator, denominator: lhs.denominator)
    }
}

public func *(lhs: Fraction, rhs: Fraction) -> Fraction {
    return Fraction(numerator: lhs.numerator * rhs.numerator, denominator: lhs.denominator * rhs.denominator)
}

public func /(lhs: Fraction, rhs: Fraction) -> Fraction {
    return Fraction(numerator: lhs.numerator * rhs.denominator, denominator: lhs.denominator * rhs.numerator)
}

public func ==(lhs: Fraction, rhs: Fraction) -> Bool {
    return (
        (lhs.numerator == rhs.numerator && lhs.denominator == rhs.denominator) ||
        ((lhs.numerator / rhs.numerator) == (lhs.denominator / rhs.denominator))
    )
}

extension Double {
    public init(_ fraction: Fraction) {
        self = Double(fraction.numerator) / Double(fraction.denominator)
    }
}

extension Float {
    public init(_ fraction: Fraction) {
        self = Float(fraction.numerator) / Float(fraction.denominator)
    }
}
