//
//  SequenceType+StoppableFlatMap.swift
//  SwiftExt
//
//  Created by Manfred on 9/19/15.
//
//

extension SequenceType {
    public func flatMapStoppably<T>(
        @noescape transform: (Self.Generator.Element, inout Bool) throws -> T?)
        rethrows
        -> [T]
    {
        var mapped = [T]()
        
        var shouldStop = false
        
        for each in self {
            if let result = try transform(each, &shouldStop) {
                mapped.append(result)
            }
            if shouldStop { break }
        }
        
        return mapped
    }
}
