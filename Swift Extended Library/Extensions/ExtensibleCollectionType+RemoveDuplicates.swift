//
//  ExtensibleCollectionType.swift
//  Swift Extended Library
//
//  Created by Manfred Lau on 1/6/15.
//
//

public func removeDuplicates<C: ExtensibleCollectionType where C.Generator.Element : Equatable>(aCollection: C) -> C {
    var container = C()
    
    for element in aCollection {
        if !contains(container, element) {
            container.append(element)
        }
    }
    
    return container
}
