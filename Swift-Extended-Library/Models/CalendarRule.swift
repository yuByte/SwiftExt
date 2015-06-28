//
//  CalendarRule.swift
//  Swift Extended Library
//
//  Created by Manfred Lau on 11/19/14.
//
//

import Foundation


protocol CalendarRule {
    /*
    var calendar: Calendar? {get}
    
    // Calendrical calculations
    func minimumRangeOfUnit(unit: CalendarUnit) -> Range<Int>
    func maximumRangeOfUnit(unit: CalendarUnit) -> Range<Int>
    
    func rangeOfUnit(smaller: CalendarUnit, inUnit larger: CalendarUnit, forDate date: Date) -> Range<Int>
    func ordinalityOfUnit(smaller: CalendarUnit, inUnit larger: CalendarUnit, forDate date: Date) -> Int
    
    func rangeOfUnit(unit: CalendarUnit, startDate startDatePointer: AutoreleasingUnsafeMutablePointer<Date?>, interval timeIntervalPointer: UnsafeMutablePointer<TimeInterval>, forDate date: Date) -> Bool
    
    func dateFromComponents(comps: DateComponents) -> Date?
    func components(unitFlags: CalendarUnit, fromDate date: Date) -> DateComponents
    
    func components(unitFlags: CalendarUnit, fromDate: Date, toDate: Date, options: CalendarOptions) -> DateComponents
*/
}

/*
var tm_sec: Int32 /* seconds after the minute [0-60] */
var tm_min: Int32 /* minutes after the hour [0-59] */
var tm_hour: Int32 /* hours since midnight [0-23] */
var tm_mday: Int32 /* day of the month [1-31] */
var tm_mon: Int32 /* months since January [0-11] */
var tm_year: Int32 /* years since 1900 */
var tm_wday: Int32 /* days since Sunday [0-6] */
var tm_yday: Int32 /* days since January 1 [0-365] */
var tm_isdst: Int32 /* Daylight Savings Time flag */
var tm_gmtoff: Int /* offset from CUT in seconds */
var tm_zone: UnsafeMutablePointer<Int8> /* timezone abbreviation */
*/

class CalendarRuleGregorian: CalendarRule {
    private weak var _calendar: Calendar?
    var calendar: Calendar {
        return _calendar!
    }
    
    init(calendar aCalendar: Calendar) {
        _calendar = aCalendar
    }
    
    func components(unitFlags: CalendarUnit, fromDate date: Date) -> DateComponents {
        var time = time_t(date.timeIntervalSince1970.seconds)
        let tmPointer = gmtime(&time)
        let tmValue = tmPointer.memory
        
        var dateComps = DateComponents()
        
        if unitFlags.contains(.Era) {
            // dateComps.era =
        }
        
        if unitFlags.contains(.Year) {
            dateComps.year = Int(tmValue.tm_year)
        }
        
        if unitFlags.contains(.Month) {
            dateComps.month = Int(tmValue.tm_mon)
        }
        
        if unitFlags.contains(.Day) {
            if unitFlags.contains(.Month) {
                dateComps.day = Int(tmValue.tm_mday)
            } else {
                dateComps.day = Int(tmValue.tm_yday)
            }
        }
        
        if unitFlags.contains(.Hour) {
            dateComps.hour = Int(tmValue.tm_hour)
        }
        
        if unitFlags.contains(.Minute) {
            dateComps.minute = Int(tmValue.tm_min)
        }
        
        if unitFlags.contains(.Second) {
            dateComps.second = Int(tmValue.tm_sec)
        }
        
        if unitFlags.contains(.Microsecond) {
            dateComps.microsecond = date.timeIntervalSince1970.microseconds * 1000
        }
        
        if unitFlags.contains(.Weekday) {
            dateComps.weekday = Int(tmValue.tm_wday)
        }
        
        if unitFlags.contains(.WeekdayOrdinal) {
            //FIXME: Needs calculation
        }
        
        if unitFlags.contains(.Quarter) {
            //FIXME: Needs calculation
        }
        
        if unitFlags.contains(.WeekOfMonth) {
            //FIXME: Needs calculation
        }
        
        if unitFlags.contains(.WeekOfYear) {
            //FIXME: Needs calculation
        }
        
        if unitFlags.contains(.YearForWeekOfYear) {
            //FIXME: Needs calculation
        }
        
        if unitFlags.contains(.Calendar) {
            dateComps.calendar = self.calendar
        }
        
        if unitFlags.contains(.TimeZone) {
            let timeZoneAbbreviationPointer = tmValue.tm_zone
            if let timeZoneAbbreviation = String.fromCString(timeZoneAbbreviationPointer) {
                dateComps.timeZone = TimeZone(abbreviation: timeZoneAbbreviation)
            }
        }
        
        return dateComps
    }
}

/*
class CalendarRuleRepublicOfChina: CalendarRule {
}

class CalendarRuleTraditionalChinese: CalendarRule {
}

class CalendarRuleJapaneseEmperor: CalendarRule {
}
*/