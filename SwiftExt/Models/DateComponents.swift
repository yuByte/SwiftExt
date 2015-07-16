//
//  DateComponent.swift
//  Swift-Extended-Library
//
//  Created by Manfred Lau on 11/12/14.
//
//

import Darwin

import Foundation

public struct DateComponents {
    var calendar: Calendar?
    var timeZone: TimeZone?
    
    var era: Int?
    var year: Int?
    var month: Int?
    var day: Int?
    var hour: Int?
    var minute: Int?
    var second: Int?
    var microsecond: Int?
    var weekday: Int?
    var weekdayOrdinal: Int?
    var quarter: Int?
    var weekOfMonth: Int?
    var weekOfYear: Int?
    var yearForWeekOfYear: Int?
    var leapMonth: Bool?
    
    let date: Date?
    
    ///This API allows one to set a specific component of NSDateComponents, by enum constant value rather than property name.
    ///The calendar and timeZone and isLeapMonth properties cannot be set by this method.
    mutating func setValue(value: Int?, forComponent unit: CalendarUnit) {
        if unit == CalendarUnit.Era {
            era = value
        }
        
        if unit == CalendarUnit.Year {
            year = value
        }
        
        if unit == CalendarUnit.Month {
            month = value
        }
        
        if unit == CalendarUnit.Day {
            day = value
        }
        
        if unit == CalendarUnit.Hour {
            hour = value
        }
        
        if unit == CalendarUnit.Second {
            second = value
        }
        
        if unit == CalendarUnit.Microsecond {
            microsecond = value
        }
        
        if unit == CalendarUnit.Weekday {
            weekday = value
        }
        
        if unit == CalendarUnit.WeekdayOrdinal {
            weekdayOrdinal = value
        }
        
        if unit == CalendarUnit.Quarter {
            quarter = value
        }
        
        if unit == CalendarUnit.WeekOfMonth {
            weekOfMonth = value
        }
        
        if unit == CalendarUnit.WeekOfYear {
            weekOfYear = value
        }
        
        if unit == CalendarUnit.YearForWeekOfYear {
            yearForWeekOfYear = value
        }
    }
    
    ///This API allows one to get the value of a specific component of NSDateComponents, by enum constant value rather than property name.
    ///The calendar and timeZone and isLeapMonth property values cannot be gotten by this method.
    func valueForComponent(unit: CalendarUnit) -> Int? {
        if unit == CalendarUnit.Era {
            return era
        }
        
        if unit == CalendarUnit.Year {
            return year
        }
        
        if unit == CalendarUnit.Month {
            return month
        }
        
        if unit == CalendarUnit.Day {
            return day
        }
        
        if unit == CalendarUnit.Hour {
            return hour
        }
        
        if unit == CalendarUnit.Minute {
            return minute
        }
        
        if unit == CalendarUnit.Second {
            return second
        }
        
        if unit == CalendarUnit.Microsecond {
            return microsecond
        }
        
        if unit == CalendarUnit.Weekday {
            return weekday
        }
        
        if unit == CalendarUnit.WeekdayOrdinal {
            return weekdayOrdinal
        }
        
        if unit == CalendarUnit.Quarter {
            return quarter
        }
        
        if unit == CalendarUnit.WeekOfMonth {
            return weekOfMonth
        }
        
        if unit == CalendarUnit.WeekOfYear {
            return weekOfYear
        }
        
        if unit == CalendarUnit.YearForWeekOfYear {
            return yearForWeekOfYear
        }
        
        return nil
    }
    
    ///Reports whether or not the combination of properties which have been set in the receiver is a date which exists in the calendar.
    ///This method is not appropriate for use on NSDateComponents objects which are specifying relative quantities of calendar components.
    ///Except for some trivial cases (e.g., 'seconds' should be 0 - 59 in any calendar), this method is not necessarily cheap.
    ///If the time zone property is set in the NSDateComponents object, it is used.
    ///The calendar property must be set, or NO is returned.
    var validDate: Bool {
        //FIXME: Needs calculation
        return false
    }
    
    ///Reports whether or not the combination of properties which have been set in the receiver is a date which exists in the calendar.
    ///This method is not appropriate for use on NSDateComponents objects which are specifying relative quantities of calendar components.
    ///Except for some trivial cases (e.g., 'seconds' should be 0 - 59 in any calendar), this method is not necessarily cheap.
    ///If the time zone property is set in the NSDateComponents object, it is used.
    func isValidDateInCalendar(calendar: Calendar) -> Bool {
        //FIXME: Needs calculation
        return false
    }
}

extension DateComponents {
    init() {
        self = DateComponents(calendar: nil, timeZone: nil, era: nil, year: nil, month: nil, day: nil, hour: nil, minute: nil, second: nil, microsecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil, leapMonth: nil, date: nil)
    }
    
    init(date: Date) {
        self = DateComponents(calendar: nil, timeZone: nil, era: nil, year: nil, month: nil, day: nil, hour: nil, minute: nil, second: nil, microsecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil, leapMonth: nil, date: date)
    }
}