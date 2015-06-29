//
//  CalendarCache.swift
//  Swift Extended Library
//
//  Created by Manfred Lau on 11/20/14.
//  Copyright (c) 2014 WeZZard. All rights reserved.
//

import Foundation

/*
extension Database {
    class var sharedCalendarCacheDatabase: Database? {
        struct SharedCalendarCacheDatabase {
            static var onceToken : dispatch_once_t = 0
            static var instance : Database? = nil
        }
        
        dispatch_once(&SharedCalendarCacheDatabase.onceToken, { () -> Void in
            if let bundle = NSBundle(identifier: WZFoundationIdentifier) {
                let path = bundle.pathForResource("CalendarCache", ofType: "db")
                SharedCalendarCacheDatabase.instance = Database(path)
            }
        })
        
        return SharedCalendarCacheDatabase.instance
    }
}

class CalendarCache {
    let identifier: CalendarIdentifier
    let database: Database?
    let table: Query?
    
    init(identifier anIdentifier: CalendarIdentifier) {
        identifier = anIdentifier
        if let calendarCacheDatabase = Database.sharedCalendarCacheDatabase {
            database = calendarCacheDatabase
            
            if let tableName = identifier.databaseTableName {
                
                let calendarSpecificTable = calendarCacheDatabase[tableName]
                let dayOffset = Expression<Int>("day_offset")
                let name = Expression<Int>("name")
                let email = Expression<Int>("email")
                
                calendarCacheDatabase.create(table: calendarSpecificTable) { table in
                    table.column(dayOffset, primaryKey: true)
                    table.column(name)
                    table.column(email, unique: true)
                }
            }
        }
    }
    
    /*
    func dateComponentsForDayAtOffset(offset: Int) -> DateComponents {
        
    }*/
    
    func enqueueCacheTaskFromDayOffset(fromDayOffset: Int, toDayOffset: Int) {
        
    }
    
    func cacheDayAtOffset(offset: Int) {
        
    }
    
    func pauseCacheTask() {
        
    }
    
    func stopCacheTask() {
        
    }
}

extension CalendarCache {
    class func calendarCacheForIdentifier(identifier: CalendarIdentifier) -> CalendarCache {
        struct SharedCalendarCache {
            static var onceToken : dispatch_once_t = 0
            static var instance : CalendarCache? = nil
        }
        dispatch_once(&SharedCalendarCache.onceToken) {
            SharedCalendarCache.instance = CalendarCache(identifier: identifier)
        }
        return SharedCalendarCache.instance!
    }
}
*/