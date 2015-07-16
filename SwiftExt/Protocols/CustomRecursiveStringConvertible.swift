//
//  CustomRecursiveStringConvertible.swift
//  Swift-Extended-Library
//
//  Created by Manfred Lau on 11/20/14.
//
//

import Swift

public protocol CustomRecursiveStringConvertible {
    func recursiveDescriptionWithLevel(level: UInt) -> String
}