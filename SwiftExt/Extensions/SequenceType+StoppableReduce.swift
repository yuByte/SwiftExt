//
//  SequenceType+StoppableReduce.swift
//  SwiftExt
//
//  Created by Manfred on 9/19/15.
//
//

extension SequenceType {
    public func reduceStoppably<T>(initial: T,
        @noescape combine: (T, Self.Generator.Element, inout Bool) throws -> T)
        rethrows
        -> T
    {
        var reduced = initial
        
        var shouldStop = false
        
        for each in self {
            reduced = try combine(reduced, each, &shouldStop)
            if shouldStop { break }
        }
        
        return reduced
    }
}
