//
//  Date.swift
//  SwiftExt
//
//  Created by Manfred Lau on 10/10/14.
//
//

import Darwin

public struct Date {
    public let timeIntervalSinceReferenceDate: TimeInterval
    public let timeIntervalSince1970: TimeInterval
    
    public init() {
        timeIntervalSince1970 = TimeInterval()
        timeIntervalSinceReferenceDate = timeIntervalSince1970 - TimeInterval.since1970()
    }
    
    public init(timeInterval: TimeInterval, sinceDate date: Date) {
        timeIntervalSince1970 = date.timeIntervalSince1970 + timeInterval
        timeIntervalSinceReferenceDate = date.timeIntervalSinceReferenceDate + timeInterval
    }
    
    public init(timeIntervalSinceNow: TimeInterval) {
        timeIntervalSince1970 = TimeInterval() + timeIntervalSinceNow
        timeIntervalSinceReferenceDate = timeIntervalSince1970 - TimeInterval.since1970() + timeIntervalSinceNow
    }
    
    public init(timeIntervalSince1970 theTimeIntervalSince1970: TimeInterval) {
        timeIntervalSince1970 = theTimeIntervalSince1970
        timeIntervalSinceReferenceDate = theTimeIntervalSince1970 - TimeInterval.since1970()
    }
    
    public init(timeIntervalSinceReferenceDate theTimeIntervalSinceReferenceDate: TimeInterval) {
        timeIntervalSince1970 = theTimeIntervalSinceReferenceDate + TimeInterval.from1970ToReferenceDate
        timeIntervalSinceReferenceDate = theTimeIntervalSinceReferenceDate
    }
}

extension Date: CustomStringConvertible {
    public var description: String {
        return "\(timeIntervalSinceReferenceDate.description)"
    }
}

extension Date: CustomReflectable {
    public func customMirror() -> Mirror {
        return Mirror(self, children: [], displayStyle: Mirror.DisplayStyle.Struct)
    }
}

extension Date : Comparable {}

public func < (lhs: Date, rhs: Date) -> Bool {
    return lhs.timeIntervalSinceReferenceDate < rhs.timeIntervalSinceReferenceDate
}

public func <= (lhs: Date, rhs: Date) -> Bool {
    return lhs.timeIntervalSinceReferenceDate <= rhs.timeIntervalSinceReferenceDate
}

public func > (lhs: Date, rhs: Date) -> Bool {
    return lhs.timeIntervalSinceReferenceDate > rhs.timeIntervalSinceReferenceDate
}

public func >= (lhs: Date, rhs: Date) -> Bool {
    return lhs.timeIntervalSinceReferenceDate >= rhs.timeIntervalSinceReferenceDate
}

public func == (lhs: Date, rhs: Date) -> Bool {
    return lhs.timeIntervalSinceReferenceDate == rhs.timeIntervalSinceReferenceDate
}