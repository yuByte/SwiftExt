//
//  Calendar.swift
//  Swift Extended Library
//
//  Created by Manfred Lau on 11/12/14.
//
//

import Swift

import Foundation

public class Calendar {
    public let identifier: CalendarIdentifier
    
    private var calendarRule: CalendarRule?
    
    var locale: Locale?
    var timeZone: TimeZone?
    
    var firstWeekday: Int = 0
    var minimumDaysInFirstWeek: Int = 0
    
    public init(identifier theIdentifier: CalendarIdentifier) {
        identifier = theIdentifier
        setup(identifier: theIdentifier)
    }
    
    func setup(identifier theIdentifier: CalendarIdentifier) {
        calendarRule = theIdentifier.calendarRule(particularCalendar: self)
    }
}

extension Calendar {
}

extension Calendar {
}