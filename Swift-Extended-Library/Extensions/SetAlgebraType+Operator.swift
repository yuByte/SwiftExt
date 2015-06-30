//
//  SetAlgebraType+Operator.swift
//  Swift-Extended-Library
//
//  Created by Manfred on 6/30/15.
//
//

//MARK: +
public func + <S: SetAlgebraType>(lhs: S, rhs: S) -> S {
    return lhs.union(rhs)
}

//MARK: -
public func - <S: SetAlgebraType>(lhs: S, rhs: S) -> S {
    return lhs.subtract(rhs)
}

//MARK: +=
public func += <S: SetAlgebraType>(inout lhs: S, rhs: S) {
    lhs.unionInPlace(rhs)
}

//MARK: -=
public func -= <S: SetAlgebraType>(inout lhs: S, rhs: S) {
    lhs.subtractInPlace(rhs)
}
