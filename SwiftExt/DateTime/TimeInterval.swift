//
//  TimeInterval.swift
//  SwiftExt
//
//  Created by Manfred Lau on 11/12/14.
//
//

import Darwin

/// The time is expressed in seconds and microseconds since midnight (0 o'clock), January 1, 1970 dy default.
public struct TimeInterval {
    public var seconds: Int
    public var microseconds: Int
}

extension TimeInterval {
    /// Since midnight (0 hour), January 1, 1970
    public init() {
        var timevalPointer = timeval(tv_sec: 0, tv_usec: 0)
        gettimeofday(&timevalPointer, nil)
        seconds = timevalPointer.tv_sec
        microseconds = Int(timevalPointer.tv_usec)
        
        self -= TimeInterval.from1970ToReferenceDate
    }
    
    public init(seconds theSeconds: Int) {
        seconds = theSeconds
        microseconds = 0
    }
    
    public init(microseconds theMicroseconds: Int) {
        seconds = 0
        microseconds = theMicroseconds
    }
    
    /// Since midnight (0 hour), January 1, 1970
    public static func since1970() -> TimeInterval {
        let timeInterval = TimeInterval()
        return timeInterval
    }
    
    /// Since midnight (0 hour), January 1, 2000
    public static func sinceReferenceDate() -> TimeInterval {
        let timeInterval = TimeInterval() - TimeInterval.from1970ToReferenceDate
        return timeInterval
    }
}

extension TimeInterval: CustomStringConvertible {
    public var description: String {
        return "\(seconds).\(microseconds*100000)"
    }
}

extension TimeInterval {
    static let from1970ToReferenceDate = TimeInterval(seconds: 978307200, microseconds: 0)
}

func + (lhs: TimeInterval, rhs: TimeInterval) -> TimeInterval {
    return TimeInterval(seconds: lhs.seconds + rhs.seconds,
        microseconds: lhs.microseconds + rhs.microseconds)
}

func - (lhs: TimeInterval, rhs: TimeInterval) -> TimeInterval {
    return TimeInterval(seconds: lhs.seconds - rhs.seconds,
        microseconds: lhs.microseconds - rhs.microseconds)
}

func * (lhs: TimeInterval, rhs: Int) -> TimeInterval {
    return TimeInterval(seconds: lhs.seconds * rhs,
        microseconds: lhs.microseconds * rhs)
}

func * (lhs: Int, rhs: TimeInterval) -> TimeInterval {
    return TimeInterval(seconds: rhs.seconds * lhs,
        microseconds: rhs.microseconds * lhs)
}

func / (lhs: TimeInterval, rhs: Int) -> TimeInterval {
    return TimeInterval(seconds: lhs.seconds / rhs,
        microseconds: lhs.microseconds / rhs)
}

func += (inout lhs: TimeInterval, rhs: TimeInterval) {
    lhs.seconds += rhs.seconds
    lhs.microseconds += rhs.microseconds
}

func -= (inout lhs: TimeInterval, rhs: TimeInterval) {
    lhs.seconds -= rhs.seconds
    lhs.microseconds -= rhs.microseconds
}

func *= (inout lhs: TimeInterval, rhs: Int) {
    lhs.seconds *= rhs
    lhs.microseconds *= rhs
}

func /= (inout lhs: TimeInterval, rhs: Int) {
    lhs.seconds /= rhs
    lhs.microseconds /= rhs
}

public func < (lhs: TimeInterval, rhs: TimeInterval) -> Bool {
    if lhs.seconds == rhs.seconds {
        return lhs.microseconds < rhs.microseconds
    } else {
        return lhs.seconds < rhs.seconds
    }
}

public func <= (lhs: TimeInterval, rhs: TimeInterval) -> Bool {
    if lhs.seconds == rhs.seconds {
        return lhs.microseconds <= rhs.microseconds
    } else {
        return lhs.seconds < rhs.seconds
    }
}

public func > (lhs: TimeInterval, rhs: TimeInterval) -> Bool {
    if lhs.seconds == rhs.seconds {
        return lhs.microseconds > rhs.microseconds
    } else {
        return lhs.seconds > rhs.seconds
    }
}

public func >= (lhs: TimeInterval, rhs: TimeInterval) -> Bool {
    if lhs.seconds == rhs.seconds {
        return lhs.microseconds >= rhs.microseconds
    } else {
        return lhs.seconds > rhs.seconds
    }
}

public func == (lhs: TimeInterval, rhs: TimeInterval) -> Bool {
    return (lhs.seconds == rhs.seconds &&
        lhs.microseconds == rhs.microseconds)
}

extension TimeInterval: FloatLiteralConvertible {
    /// Create an instance initialized to `value`.
    public init(floatLiteral value: FloatLiteralType) {
        seconds = Int(floor(value))
        microseconds = Int((value - floor(value)) * 1000000.0)
    }
}

extension TimeInterval: IntegerLiteralConvertible {
    /// Create an instance initialized to `value`.
    public init(integerLiteral value: IntegerLiteralType) {
        seconds = value
        microseconds = 0
    }
}

extension TimeInterval: CustomReflectable {
    public func customMirror() -> Mirror {
        return Mirror(self, children: [], displayStyle: Mirror.DisplayStyle.Struct)
    }
}
