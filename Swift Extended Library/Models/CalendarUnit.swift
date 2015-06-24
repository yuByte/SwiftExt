//
//  CalendarUnit.swift
//  Swift Extended Library
//
//  Created by Manfred Lau on 11/19/14.
//
//

public struct CalendarUnit: OptionSetType {
    public typealias RawValue = UInt
    public let rawValue: RawValue
    
    public init(rawValue value: RawValue) { self.rawValue = value }
    
    public static var Era: CalendarUnit                 { return self.init(rawValue: 1 << 00) }
    public static var Year: CalendarUnit                { return self.init(rawValue: 1 << 01) }
    public static var Month: CalendarUnit               { return self.init(rawValue: 1 << 02) }
    public static var Day: CalendarUnit                 { return self.init(rawValue: 1 << 03) }
    
    public static var Hour: CalendarUnit                { return self.init(rawValue: 1 << 04) }
    public static var Minute: CalendarUnit              { return self.init(rawValue: 1 << 05) }
    public static var Second: CalendarUnit              { return self.init(rawValue: 1 << 06) }
    public static var Microsecond: CalendarUnit         { return self.init(rawValue: 1 << 07) }
    
    public static var Weekday: CalendarUnit             { return self.init(rawValue: 1 << 08) }
    public static var WeekdayOrdinal: CalendarUnit      { return self.init(rawValue: 1 << 09) }
    
    public static var Quarter: CalendarUnit             { return self.init(rawValue: 1 << 10) }
    public static var WeekOfMonth: CalendarUnit         { return self.init(rawValue: 1 << 11) }
    public static var WeekOfYear: CalendarUnit          { return self.init(rawValue: 1 << 12) }
    public static var YearForWeekOfYear: CalendarUnit   { return self.init(rawValue: 1 << 13) }
    
    public static var Calendar: CalendarUnit            { return self.init(rawValue: 1 << 14) }
    public static var TimeZone: CalendarUnit            { return self.init(rawValue: 1 << 15) }
}

extension CalendarUnit: CustomStringConvertible {
    public var description: String {
        switch self {
        case CalendarUnit.Era:
            return "Era"
        case CalendarUnit.Year:
            return "Year"
        case CalendarUnit.Month:
            return "Month"
        case CalendarUnit.Day:
            return "Day"
        case CalendarUnit.Hour:
            return "Hour"
        case CalendarUnit.Minute:
            return "Minute"
        case CalendarUnit.Second:
            return "Second"
        case CalendarUnit.Microsecond:
            return "Micro Second"
        case CalendarUnit.Weekday:
            return "Weekday"
        case CalendarUnit.WeekdayOrdinal:
            return "Weekday Ordinal"
        case CalendarUnit.Quarter:
            return "Quarter"
        case CalendarUnit.WeekOfMonth:
            return "Week of Month"
        case CalendarUnit.WeekOfYear:
            return "Week of Year"
        case CalendarUnit.YearForWeekOfYear:
            return "Year for Week of Year"
        case CalendarUnit.Calendar:
            return "Calendar"
        case CalendarUnit.TimeZone:
            return "Time Zone"
        default:
            return "\(rawValue)"
        }
    }
}
