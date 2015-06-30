//
//  SetAlgebraType+Operator.swift
//  Swift-Extended-Library
//
//  Created by Manfred on 6/30/15.
//
//

//MARK: +
func + <S: SetAlgebraType>(lhs: S, rhs: S) -> S {
    return lhs.union(rhs)
}

func + <S: SetAlgebraType>(lhs: S, rhs: S.Element) -> S {
    var unioned = lhs
    unioned.insert(rhs)
    return unioned
}

func + <S: SetAlgebraType>(lhs: S.Element, rhs: S) -> S {
    var unioned = rhs
    unioned.insert(lhs)
    return unioned
}

func + <S: SetAlgebraType>(lhs: S.Element, rhs: S.Element) -> S {
    return [lhs, rhs]
}

//MARK: -
func - <S: SetAlgebraType>(lhs: S, rhs: S) -> S {
    return lhs.subtract(rhs)
}

func - <S: SetAlgebraType>(lhs: S, rhs: S.Element) -> S {
    var unioned = lhs
    unioned.remove(rhs)
    return unioned
}

//MARK: +=
func += <S: SetAlgebraType>(inout lhs: S, rhs: S) {
    lhs = lhs.union(rhs)
}

func += <S: SetAlgebraType>(inout lhs: S, rhs: S.Element) {
    lhs.insert(rhs)
}

//MARK: -=
func -= <S: SetAlgebraType>(inout lhs: S, rhs: S) {
    lhs = lhs.subtract(rhs)
}

func -= <S: SetAlgebraType>(inout lhs: S, rhs: S.Element) {
    lhs.remove(rhs)
}
