//
//  CalendarTracker.swift
//  Swift-Extended-Library
//
//  Created by Manfred Lau on 11/19/14.
//
//

private let sharedCalendarTracker = CalendarTracker()

class CalendarTracker {
    class var sharedTracker: CalendarTracker {
        return sharedCalendarTracker
    }
}
