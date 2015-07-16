//
//  NumberTypes+IntegerLiteralConvertible.swift
//  Swift-Extended-Library
//
//  Created by Manfred Lau on 1/6/15.
//
//

extension Int: FloatLiteralConvertible {
    public init(floatLiteral value: FloatLiteralType) {
        self = Int(value)
    }
}
