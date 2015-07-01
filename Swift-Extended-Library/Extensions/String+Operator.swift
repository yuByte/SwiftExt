//
//  String+Operator.swift
//  Swift-Extended-Library
//
//  Created by Manfred Lau on 5/20/15.
//
//

/*
Create a string which repeats itself with the given string

:param:     lhs             A given string

:param:     rhs             Repeat times
*/
public func *(lhs: String, rhs: Int) -> String {
    return repeatString(lhs, times: rhs)
}

/*
Create a string which repeats itself with the given string

:param:     lhs             Repeat times

:param:     rhs             A given string
*/
public func *(lhs: Int, rhs: String) -> String {
    return repeatString(rhs, times: lhs)
}

private func repeatString(string: String, times: Int) -> String {
    var repeated = ""
    for _ in 0..<times {
        repeated += string
    }
    return repeated
}
