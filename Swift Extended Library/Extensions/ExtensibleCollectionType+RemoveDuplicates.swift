//
//  ExtensibleCollectionType.swift
//  Swift Extended Library
//
//  Created by Manfred Lau on 1/6/15.
//
//

extension ExtensibleCollectionType where Generator.Element : Equatable {
    /**
    Remove duplicated element in a ExtensibleCollectionType conformed type value
    
    - returns:   Returns the duplicates
    */
    mutating public func removeDuplicates() -> Self {
        var container = Self()
        var duplicates = Self()
        
        for element in self {
            if !container.contains(element) {
                container.append(element)
            } else {
                duplicates.append(element)
            }
        }
        
        self = container
        
        return duplicates
    }
}

