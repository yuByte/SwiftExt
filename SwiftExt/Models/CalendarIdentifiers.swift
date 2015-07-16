//
//  CalendarIdentifiers.swift
//  Swift-Extended-Library
//
//  Created by Manfred Lau on 11/19/14.
//
//

import Foundation

public enum CalendarIdentifier: String, CustomDebugStringConvertible, CustomStringConvertible {
    case Gregorian = "Gregorian"
    case TraditionalChinese = "Traditional Chinese"
    case RepublicOfChina = "Republic of China"
    case JapaneseEmperor = "Japanese Emperor"
    
    public var description: String {
        return self.rawValue
    }
    
    public var debugDescription: String {
        return self.rawValue
    }
    
    func calendarRule(particularCalendar aCalendar: Calendar) -> CalendarRule? {
        switch self {
        case .Gregorian:
            return CalendarRuleGregorian(calendar: aCalendar)
        case .TraditionalChinese:
            return CalendarRuleGregorian(calendar: aCalendar)
        case .RepublicOfChina:
            return CalendarRuleGregorian(calendar: aCalendar)
        case .JapaneseEmperor:
            return CalendarRuleGregorian(calendar: aCalendar)
        }
    }
    
    var databaseTableName: String? {
        switch self {
        case .Gregorian:
            return "com.WeZZard.SwiftExt.Calendar.Gregorian"
        case .TraditionalChinese:
            return "com.WeZZard.SwiftExt.Calendar.TranditionalChinese"
        case .RepublicOfChina:
            return "com.WeZZard.SwiftExt.Calendar.RepublicOfChina"
        case .JapaneseEmperor:
            return "com.WeZZard.SwiftExt.Calendar.Japanese"
        }
    }
    
    var calendarDatabasePath: String? {
        
        return nil
    }
}