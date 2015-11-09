//
//  Array+ContiguousSubsequenceOnMemoryConvertible.swift
//  SwiftExt
//
//  Created by Manfred on 11/4/15.
//
//

extension Array {
    public init(head: UnsafePointer<Element>, length: Int) {
        self = []
        for index in 0..<length { append(head[index]) }
    }
}
