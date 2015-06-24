//
//  CalendarOption.swift
//  Swift Extended Library
//
//  Created by Manfred Lau on 11/19/14.
//
//

public struct CalendarOptions : OptionSetType {
    public typealias RawValue = UInt
    public let rawValue: RawValue
    
    public init(rawValue: RawValue) { self.rawValue = rawValue }
    
     // option for arithmetic operations that do calendar addition
    public static var WrapComponents: CalendarOptions                           { return self.init(rawValue: 1 << 0) }
    
    public static var MatchStrictly: CalendarOptions                            { return self.init(rawValue: 1 << 1) }
    public static var SearchBackwards: CalendarOptions                          { return self.init(rawValue: 1 << 2) }
    
    public static var MatchPreviousTimePreservingSmallerUnits: CalendarOptions  { return self.init(rawValue: 1 << 3) }
    public static var MatchNextTimePreservingSmallerUnits: CalendarOptions      { return self.init(rawValue: 1 << 4) }
    public static var MatchNextTime: CalendarOptions                            { return self.init(rawValue: 1 << 5) }
    
    public static var MatchFirst: CalendarOptions                               { return self.init(rawValue: 1 << 6) }
    public static var MatchLast: CalendarOptions                                { return self.init(rawValue: 1 << 7) }
}