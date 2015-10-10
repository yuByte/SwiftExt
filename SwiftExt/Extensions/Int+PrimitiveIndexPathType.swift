//
//  Int+PrimitiveIndexPathType.swift
//  SwiftExt
//
//  Created by Manfred on 10/2/15.
//
//

extension Int: PrimitiveIndexPathType {
    public typealias Index = Int
    public var indices: [Index] { return [self] }
    
    public var length: Int { return 1 }
    
    public static func withPrimitiveIndexPath<I : PrimitiveIndexPathType>(
        primitiveIndexPath: I) -> Int {
            return self.init(Index(primitiveIndexPath.indices[0].toIntMax()))
    }
}
