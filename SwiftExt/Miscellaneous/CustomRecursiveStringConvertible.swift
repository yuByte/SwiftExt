//
//  CustomRecursiveStringConvertible.swift
//  SwiftExt
//
//  Created by Manfred Lau on 11/20/14.
//
//

public protocol CustomRecursiveStringConvertible {
    func recursiveDescriptionWithLevel(level: UInt) -> String
}