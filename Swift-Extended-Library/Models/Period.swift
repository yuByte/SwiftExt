//
//  Period.swift
//  Swift Extended Library
//
//  Created by Manfred Lau on 9/30/14.
//  Copyright (c) 2014 WeZZard. All rights reserved.
//

public struct Period {
    
    public enum Relation: Int, CustomStringConvertible, CustomDebugStringConvertible {
        case Equal
        case Contains
        case Contained
        case AscendingIntersected
        case DescendingIntersected
        case Ascending
        case Descending
        
        public var description: String {
            switch self {
            case .Equal:
                return "Equal"
            case .Contains:
                return "Contains"
            case .Contained:
                return "Contained"
            case .AscendingIntersected:
                return "Ascending Intersected"
            case .DescendingIntersected:
                return "Descending Intersected"
            case .Ascending:
                return "Ascending"
            case .Descending:
                return "Descending"
            }
        }
        
        public var debugDescription: String {
            return description
        }
    }
    
    var start: DateComponents
    var end: DateComponents
    
    var startDay: Date // Calculated
    var endDay: Date // Calculated
    
    var startDateTime: Date // Calculated
    var endDateTime: Date // Calculated
    
    func containsDay(day: Date) -> Bool {
        return false
    }
    
    func containsDay(day: DateComponents) -> Bool {
        return false
    }
    
    func containsDateTime(dateTime: Date) -> Bool {
        return false
    }
    
    func containsDateTime(dateTime: DateComponents) -> Bool {
        return false
    }
}

/*
import Foundation

public enum PeriodPrecision: Int, CustomStringConvertible, CustomDebugStringConvertible {
    case Day = 1
    case DateTime
    public var description: String {
        switch self {
        case .Day:
            return "Day"
        case .DateTime:
            return "Date Time"
        default:
            return String(self.rawValue)
        }
    }
    
    public var debugDescription: String {
        return description
    }
}

public enum PeriodComparisonResult: Int, CustomStringConvertible, CustomDebugStringConvertible {
    case Equal = 1
    case Contains
    case Contained
    case AscendlyIntersected
    case DescendlyIntersected
    case Ascending
    case Descending
    
    public var description: String {
        switch self {
        case .Equal:
            return "Equal"
        case .Contains:
            return "Contains"
        case .Contained:
            return "Contained"
        case .AscendlyIntersected:
            return "Ascendly Intersected"
        case .DescendlyIntersected:
            return "Descendly Intersected"
        case .Ascending:
            return "Ascending"
        case .Descending:
            return "Descending"
        default:
            return String(self.rawValue)
        }
    }
    
    public var debugDescription: String {
        return description
    }
}

let PeriodValidateErrorDomain = "com.WeZZard.WZFoundation.Period.ValidateError"

enum PeriodValidateErrorCode: Int {
    case StartDayDescendingToEndDay                             = -1
    case StartDateTimeDescendingToEndDateTime                   = -2
    case BothStartDayAndDateTimeDescendingToEndDayAndDateTime   = -3
    func description() -> String {
        switch self {
        case .StartDayDescendingToEndDay:
            return "Start day descending to end day"
        case .StartDateTimeDescendingToEndDateTime:
            return "Start date time descending to end date time"
        case .BothStartDayAndDateTimeDescendingToEndDayAndDateTime:
            return "Both start day and date time descending to end day and date time"
        default:
            return String(self.rawValue)
        }
    }
}

let PeriodCodingKeyStartDay = "PeriodCodingKeyStartDay"
let PeriodCodingKeyEndDay = "PeriodCodingKeyEndDay"
let PeriodCodingKeyStartDateTime = "PeriodCodingKeyStartDateTime"
let PeriodCodingKeyEndDateTime = "PeriodCodingKeyEndDateTime"
let PeriodCodingKeyStartDayTimeInterval = "PeriodCodingKeyStartDayTimeInterval"
let PeriodCodingKeyEndDayTimeInterval = "PeriodCodingKeyEndDayTimeInterval"
let PeriodCodingKeyStartDateTimeInterval = "PeriodCodingKeyStartDateTimeInterval"
let PeriodCodingKeyEndDateTimeInterval = "PeriodCodingKeyEndDateTimeInterval"
let PeriodCodingKeyNeedsUpdate = "PeriodCodingKeyNeedsUpdate"
let PeriodCodingKeyPrecision = "PeriodCodingKeyPrecision"

class Period {
    let startDay: NSDate
    let endDay: NSDate
    
    let startDateTime: NSDate?
    let endDateTime: NSDate?
    
    internal let startDayTimeInterval: NSTimeInterval
    internal let endDayTimeInterval: NSTimeInterval
    
    internal let startDateTimeTimeInterval: NSTimeInterval?
    internal let endDateTimeTimeInterval: NSTimeInterval?
    
    let precision: PeriodPrecision
    
    private var _gregorianDaySpanCache: Int?
    private var _daySpanCache: [String: Int]
    
    var highestPreciseStartDateTime: NSDate {
        get {
            if let theHighestPreciseStartDateTime = startDateTime {
                return theHighestPreciseStartDateTime
            } else {
                return startDay
            }
        }
    }
    
    var highestPreciseEndDateTime: NSDate {
        get {
            if let theHighestPreciseEndDateTime = endDateTime {
                return theHighestPreciseEndDateTime
            } else {
                return endDay
            }
        }
    }
    
    func daySpanOnCalendar(calendar: NSCalendar) -> Int {
        if calendar.calendarIdentifier.hash == NSCalendarIdentifierGregorian.hash {
            if _gregorianDaySpanCache == nil {
                let deltaDaysComp = calendar.components(.CalendarUnitDay, fromDate: startDay, toDate: endDay, options: nil)
                let daySpan = deltaDaysComp.day + 1
                _gregorianDaySpanCache = daySpan;
            }
            return _gregorianDaySpanCache!
        } else {
            if let daySpan = _daySpanCache[calendar.calendarIdentifier] {
                return daySpan
            } else {
                let deltaDayComp = calendar.components(.CalendarUnitDay, fromDate: startDay, toDate: endDay, options: nil)
                let daySpan = deltaDayComp.day
                _daySpanCache[calendar.calendarIdentifier] = daySpan
                return daySpan
            }
        }
    }
    
    /*
    - (BOOL)isOccurrentOnDay:(NSDate *)day;
    - (BOOL)isOccurrentOnDayOfDate:(NSDate *)date onCalendar:(NSCalendar *)calendar;
    
    - (PeriodDateOccurence)occurrenceForDay:(NSDate *)day onCalendar:(NSCalendar *)calendar;
    - (PeriodDateOccurence)occurrenceForDayOfDate:(NSDate *)date onCalendar:(NSCalendar *)calendar;
    */
    
    //MARK: Life Cycle
    init(startDay aStartDay: NSDate, startDateTime aStartDateTime: NSDate?, endDay anEndDay: NSDate, endDateTime anEndDateTime: NSDate?) {
        startDay = aStartDay
        endDay = anEndDay
        
        startDateTime = aStartDateTime
        endDateTime = anEndDateTime
        
        startDayTimeInterval = aStartDay.timeIntervalSinceReferenceDate
        endDayTimeInterval = anEndDay.timeIntervalSinceReferenceDate
        
        if let theStartDateTime = aStartDateTime {
            startDateTimeTimeInterval = theStartDateTime.timeIntervalSinceReferenceDate
            precision = .DateTime
        } else if let theEndDateTime = anEndDateTime {
            precision = .DateTime
            endDateTimeTimeInterval = theEndDateTime.timeIntervalSinceReferenceDate
        } else {
            precision = .Day
        }
        
        _daySpanCache = [String: Int]()
        
        let validationResult = self.validate()
        assert(validationResult.isValid, "Error: \(validationResult.error)")
    }
    
    //MARK: Utilities
    func encapsultingDatesWithPrecision(precision : PeriodPrecision) -> (starts: NSDate?, ends: NSDate?) {
        switch precision {
        case .Day:
            let theStartDay = startDay
            let theEndDay = endDay
            return (theStartDay, theEndDay)
        case .DateTime:
            let theStartDateTime = startDateTime
            let theEndDateTime = endDateTime
            return (theStartDateTime, theEndDateTime)
        }
    }
    
    /*
    //MARK: NSCopying
    func copyWithZone(zone: NSZone) -> AnyObject {
        let copiedPeriod: Period = Period(startDay: startDay, startDateTime: startDateTime!, endDay: endDay, endDateTime: endDateTime!)
        return copiedPeriod
    }
    
    //MARK: NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(startDay, forKey: PeriodCodingKeyStartDay)
        aCoder.encodeObject(endDay, forKey: PeriodCodingKeyEndDay)
        aCoder.encodeObject(startDateTime!, forKey: PeriodCodingKeyStartDateTime)
        aCoder.encodeObject(endDateTime!, forKey: PeriodCodingKeyEndDateTime)
        aCoder.encodeDouble(startDayTimeInterval, forKey: PeriodCodingKeyStartDayTimeInterval)
        aCoder.encodeDouble(endDayTimeInterval, forKey: PeriodCodingKeyEndDayTimeInterval)
        aCoder.encodeDouble(startDateTimeTimeInterval!, forKey: PeriodCodingKeyStartDateTimeInterval)
        aCoder.encodeDouble(endDateTimeTimeInterval!, forKey: PeriodCodingKeyEndDateTimeInterval)
        aCoder.encodeInteger(precision.rawValue, forKey: PeriodCodingKeyPrecision)
    }
    
    required init(coder aDecoder: NSCoder) {
        startDay = aDecoder.decodeObjectForKey(PeriodCodingKeyStartDay) as NSDate
        endDay = aDecoder.decodeObjectForKey(PeriodCodingKeyEndDay) as NSDate
        startDateTime = aDecoder.decodeObjectForKey(PeriodCodingKeyStartDateTime) as? NSDate
        endDateTime = aDecoder.decodeObjectForKey(PeriodCodingKeyEndDateTime) as? NSDate
        startDayTimeInterval = aDecoder.decodeDoubleForKey(PeriodCodingKeyStartDayTimeInterval) as NSTimeInterval
        endDayTimeInterval = aDecoder.decodeDoubleForKey(PeriodCodingKeyEndDayTimeInterval) as NSTimeInterval
        startDateTimeTimeInterval = aDecoder.decodeDoubleForKey(PeriodCodingKeyStartDateTimeInterval) as NSTimeInterval
        endDateTimeTimeInterval = aDecoder.decodeDoubleForKey(PeriodCodingKeyEndDateTimeInterval) as NSTimeInterval
        precision = PeriodPrecision(rawValue: aDecoder.decodeIntegerForKey(PeriodCodingKeyPrecision) as Int)!
        _daySpanCache = [String: Int]()
    }
    */
}

//MARK: - Extend Period For Initializers
extension Period {
    convenience init(day aDay: NSDate) {
        self.init(startDay: aDay, startDateTime: nil, endDay: aDay, endDateTime: nil)
    }
    
    convenience init(startDay aStartDay: NSDate, endDay anEndDay: NSDate) {
        self.init(startDay: aStartDay, startDateTime: nil, endDay: anEndDay, endDateTime: nil)
    }
    
    convenience init(aDay: NSDate, anotherDay: NSDate) {
        var inputDays: Array<NSDate> = [aDay, anotherDay]
        inputDays.sort {$0 < $1}
        self.init(startDay: inputDays[0], startDateTime: nil, endDay: inputDays[1], endDateTime: nil)
    }
    
    convenience init(addedPeriod: Period, addedPeriodPrecision: PeriodPrecision, addingPeriod: Period, addingPeriodPrecision: PeriodPrecision) {
        let (addedStartDay, addedEndDay) = addedPeriod.encapsultingDatesWithPrecision(addedPeriodPrecision)
        let (addedStartDateTime, addedEndDateTime) = addedPeriod.encapsultingDatesWithPrecision(addedPeriodPrecision)
        
        let (addingStartDay, addingEndDay) = addingPeriod.encapsultingDatesWithPrecision(addingPeriodPrecision)
        let (addingStartDateTime, addingEndDateTime) = addingPeriod.encapsultingDatesWithPrecision(addingPeriodPrecision)
        
        let theStartDay = addingStartDay == nil ? addedStartDay : addingEndDay;
        let theEndDay = addingEndDay == nil ? addedEndDay : addingEndDay;
        let theStartDateTime = addingStartDateTime == nil ? addedStartDateTime : addingStartDateTime;
        let theEndDateTime = addingEndDateTime == nil ? addedEndDateTime : addingEndDateTime;
        
        self.init(startDay: theStartDay!, startDateTime: theStartDateTime, endDay: theEndDay!, endDateTime: theEndDateTime)
    }
    
    convenience init(period: Period) {
        self.init(startDay: period.startDay, startDateTime: period.startDateTime, endDay: period.endDay, endDateTime: period.endDateTime);
    }
    
    func periodsByEmergingPeriods(periods: Period... ) -> [Period] {
        return self.periodsByEmergingArrayOfPeriods(periods)
    }
    
    func periodsByEmergingArrayOfPeriods(arrayOfPeriods: [Period]) -> [Period] {
        let distinctPeriods = NSSet(array: arrayOfPeriods).allObjects as [Period];
        
        var nodePairs = [WZValuePair]()
        
        let Node = "Node", Role = "Role";
        let NodeRoleStart = "PeriodRoleStart", NodeRoleEnd = "PeriodRoleEnd";
        let NodeDay = "NodeDay",  NodeDateTime = "NodeDateTime";
        
        for (index, period: Period) in enumerate(distinctPeriods) {
            var startNode = WZValuePair(name1: NodeDay, value1: period.startDay, name2: NodeDateTime, value2: period.startDateTime!)
            var startNodePair = WZValuePair(name1: Node, value1: startNode, name2: Role, value2: NodeRoleStart)
            
            nodePairs.append(startNodePair)
            
            var endNode = WZValuePair(name1: NodeDay, value1: period.endDay, name2: NodeDateTime, value2: period.endDateTime!)
            var endNodePair = WZValuePair(name1: Node, value1: endNode, name2: Role, value2: NodeRoleEnd)
            
            nodePairs.append(endNodePair)
        }
        
        nodePairs.sort { (nodeRolePair1, nodeRolePair2) -> Bool in
            let node1 = nodeRolePair1.valueForName(Node) as WZValuePair
            let node2 = nodeRolePair2.valueForName(Node) as WZValuePair
            
            let role1 = node1.valueForName(Role) as String
            let role2 = node2.valueForName(Role) as String
            
            let dayNode1 = node1.valueForName(NodeDay) as NSDate
            let dayNode2 = node2.valueForName(NodeDay) as NSDate
            
            let dateTimeNode1 = node1.valueForName(NodeDateTime) as NSDate?
            let dateTimeNode2 = node2.valueForName(NodeDateTime) as NSDate?
            
            let dayComparisonResult = dayNode1.compare(dayNode2)
            
            if (dayComparisonResult == .OrderedSame) {
                let comparedDateTimeNode1 = dateTimeNode1 == nil ? dayNode1 : dateTimeNode1
                let comparedDateTimeNode2 = dateTimeNode1 == nil ? dayNode2 : dateTimeNode2
                
                let dateTimeComparisonResult = comparedDateTimeNode1!.compare(comparedDateTimeNode2!)
                
                if (dateTimeComparisonResult == .OrderedSame) {
                    assert(role1 != role2, "It is impossible that two roles equal to each other")
                    return role1 != NodeRoleStart
                } else {
                    return dateTimeComparisonResult != .OrderedDescending
                }
            } else {
                return dayComparisonResult != .OrderedDescending
            }
        }
        
        var outputPeriods = [Period]()
        var reactionStack = [WZValuePair]()
        
        for (index, nodePair) in enumerate(nodePairs) {
            let node = nodePair.valueForName(Role) as WZValuePair
            let role = nodePair.valueForName(Role) as String
            if role == NodeRoleStart {
                reactionStack.append(node)
            } else if role == NodeRoleEnd {
                if reactionStack.count > 1 {
                    reactionStack.removeLast()
                } else {
                    // React when there only 1 object in reaction stack
                    let startNode = reactionStack.last! as WZValuePair
                    let endNode = node
                    
                    let startDay = startNode.valueForName(NodeDay) as NSDate
                    let startDateTime = startNode.valueForName(NodeDateTime) as NSDate?
                    
                    let endDay = endNode.valueForName(NodeDay) as NSDate
                    let endDateTime = endNode.valueForName(NodeDateTime) as NSDate?
                    
                    let period = Period(startDay: startDay, startDateTime: startDateTime, endDay: endDay, endDateTime: endDateTime)
                    outputPeriods.append(period)
                }
            }
        }
        
        return outputPeriods
    }
}

//MARK: Extend Comparison Approaches
extension Period {
    func compareToPeriod(comparedPeriod: Period, withPrecision precision: PeriodPrecision) -> PeriodComparisonResult {
        assert(precision.rawValue <= precision.rawValue,
               "\(precision.description()) mismatches required precision: \(precision.description())")
        
        let (startPart, endPart) = self.encapsultingDatesWithPrecision(precision)
        let (comparedStartPart, comparedEndPart) = comparedPeriod.encapsultingDatesWithPrecision(precision)
        
        let startPartComparisonResult = startPart?.compare(comparedStartPart!)
        let endPartComparisonResult = endPart?.compare(comparedEndPart!)
        
        let startPartCrossComparisonResult = startPart?.compare(comparedEndPart!)
        let endPartCrossComparisonResult = endPart?.compare(comparedStartPart!)
        
        var result: PeriodComparisonResult?;
        
        if (startPartComparisonResult! == .OrderedSame && endPartComparisonResult! == .OrderedSame) {
            result = .Equal
        } else if (startPartComparisonResult! != .OrderedAscending && endPartComparisonResult! != .OrderedDescending) {
            result = .Contained
        } else if (startPartComparisonResult! != .OrderedDescending && endPartComparisonResult! != .OrderedAscending) {
            result = .Contains
        } else {
            /*startPartComparisonResult! != .OrderedSame &&
            endPartComparisonResult! != .OrderedSame
            */
            if (startPartCrossComparisonResult! == .OrderedDescending) {
                result = .Descending
            }
            if (endPartCrossComparisonResult! == .OrderedAscending) {
                result = .Ascending
            }
            if (startPartComparisonResult! == .OrderedDescending && endPartComparisonResult! == .OrderedDescending) {
                result = .DescendlyIntersected
            }
            if (startPartComparisonResult! == .OrderedAscending && endPartComparisonResult! == .OrderedAscending) {
                result = .AscendlyIntersected
            }
        }
        
        return result!
    }
    
    func touchesPeriod(period: Period) -> Bool {
        let result = self.compareToPeriod(period, withPrecision:.Day);
        switch result {
        case .Equal, .Contains, .Contained, .DescendlyIntersected, .AscendlyIntersected:
            return true
        default:
            return false
        }
    }
}

//MARK: Validation
extension Period {
    internal class func validatePeriod(startWithDay startDay: NSDate, dateTime startDateTime: NSDate?, endWithDay endDay:NSDate, dateTime endDateTime:NSDate?) -> (isValid: Bool, error: NSError?) {
        var isValid = true
        var error: NSError? = nil;
        let shouldValidateDateTime = startDateTime != nil && endDateTime != nil;
        if shouldValidateDateTime {
            let daysComparisonResult = startDay.compare(endDay)
            let dateTimeComparisonResult = startDateTime!.compare(endDateTime!)
            if (daysComparisonResult == .OrderedDescending || dateTimeComparisonResult == .OrderedDescending) {
                
                isValid = false
                if (daysComparisonResult == .OrderedDescending && dateTimeComparisonResult != .OrderedDescending) {
                    
                    let dayFormatter = NSDateFormatter()
                    dayFormatter.dateStyle = .FullStyle
                    dayFormatter.timeStyle = .NoStyle
                    
                    let failureReason = "Start day \(dayFormatter.stringFromDate(startDay)) descends to end day \(dayFormatter.stringFromDate(endDay))"
                    
                    let errorCode = PeriodValidateErrorCode.StartDayDescendingToEndDay
                    
                    error = NSError(domain: PeriodValidateErrorDomain,
                                      code: errorCode.rawValue,
                                  userInfo: [NSLocalizedDescriptionKey: errorCode.description(),
                                             NSLocalizedFailureReasonErrorKey: failureReason])
                } else if (daysComparisonResult != .OrderedDescending && dateTimeComparisonResult == .OrderedDescending) {
                    
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateStyle = .FullStyle
                    dateFormatter.timeStyle = .FullStyle
                    
                    let failureReason = "Start date time \(dateFormatter.stringFromDate(startDateTime!)) descends to end date time \(dateFormatter.stringFromDate(endDateTime!))"
                    
                    let errorCode = PeriodValidateErrorCode.StartDateTimeDescendingToEndDateTime
                    
                    error = NSError(domain: PeriodValidateErrorDomain,
                                      code: errorCode.rawValue,
                                  userInfo: [NSLocalizedDescriptionKey: errorCode.description(),
                                             NSLocalizedFailureReasonErrorKey: failureReason])
                } else {
                    
                    let dayFormatter = NSDateFormatter()
                    dayFormatter.dateStyle = .FullStyle
                    dayFormatter.timeStyle = .NoStyle
                    
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateStyle = .FullStyle
                    dateFormatter.timeStyle = .FullStyle
                    
                    let failureReason = "Both start day \(dayFormatter.stringFromDate(startDay)) and start date time \(dateFormatter.stringFromDate(startDateTime!)) descend to end day \(dayFormatter.stringFromDate(endDay)) and end date time \(dateFormatter.stringFromDate(endDateTime!))"
                    
                    let errorCode = PeriodValidateErrorCode.BothStartDayAndDateTimeDescendingToEndDayAndDateTime
                    
                    error = NSError(domain: PeriodValidateErrorDomain,
                                      code: errorCode.rawValue,
                                  userInfo: [NSLocalizedDescriptionKey: errorCode.description(),
                                             NSLocalizedFailureReasonErrorKey: failureReason])
                }
            }
        } else {
            var dayCompareisonResult = startDay.compare(endDay)
            if (dayCompareisonResult == .OrderedDescending) {
                isValid = false;
                var dayFormatter = NSDateFormatter()
                dayFormatter.dateStyle = .FullStyle
                dayFormatter.timeStyle = .NoStyle
                
                let failureReason = "Start day \(dayFormatter.stringFromDate(startDay)) descends to end day \(dayFormatter.stringFromDate(endDay))"
                
                let errorCode = PeriodValidateErrorCode.StartDayDescendingToEndDay
                
                error = NSError(domain: PeriodValidateErrorDomain,
                                  code: errorCode.rawValue,
                              userInfo: [NSLocalizedDescriptionKey: errorCode.description(),
                                         NSLocalizedFailureReasonErrorKey: failureReason])
            }
        }
        
        return (isValid, error)
    }
    
    internal class func validatePeriod(period: Period) -> (isValid: Bool, error: NSError?) {
        return self.validatePeriod(startWithDay: period.startDay, dateTime: period.startDateTime, endWithDay: period.endDay, dateTime: period.endDateTime)
    }
    
    internal func validate() -> (isValid: Bool, error: NSError?) {
        return self.dynamicType.validatePeriod(startWithDay: startDay, dateTime: startDateTime, endWithDay: endDay, dateTime: endDateTime)
    }
}

//MARK: Pritable, DebugPrintable
extension Period : Printable, DebugPrintable {
    var description: String {
        get {
            let dayFormatter = NSDateFormatter()
            dayFormatter.dateStyle = .FullStyle
            dayFormatter.timeStyle = .NoStyle
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = .FullStyle
            dateFormatter.timeStyle = .FullStyle
            
            let description = "<\(self.dynamicType): \(Unmanaged<AnyObject>.passUnretained(self).toOpaque()): Start Day:\(dayFormatter.stringFromDate(startDay)); Start Date-Time:\(dateFormatter.stringFromDate(startDateTime!)); End Day:\(dayFormatter.stringFromDate(endDay)); End Date-Time:\(dateFormatter.stringFromDate(endDateTime!))>"
            
            return description
        }
    }
    
    var debugDescription: String {
        get {
            let dayFormatter = NSDateFormatter()
            dayFormatter.dateStyle = .FullStyle
            dayFormatter.timeStyle = .NoStyle
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = .FullStyle
            dateFormatter.timeStyle = .FullStyle
            
            let description = "<\(self.dynamicType): \(Unmanaged<AnyObject>.passUnretained(self).toOpaque()): Start Day:\(dayFormatter.stringFromDate(startDay)); Start Date-Time:\(dateFormatter.stringFromDate(startDateTime!)); End Day:\(dayFormatter.stringFromDate(endDay)); End Date-Time:\(dateFormatter.stringFromDate(endDateTime!))>"
            
            return description
        }
    }
}

//MARK: Equatable
extension Period : Equatable {}

func == (lhs: Period, rhs: Period) -> Bool {
    return (lhs.startDayTimeInterval == rhs.startDayTimeInterval &&
            lhs.endDayTimeInterval == rhs.endDayTimeInterval &&
            lhs.startDateTimeTimeInterval == rhs.startDateTimeTimeInterval &&
            lhs.endDateTimeTimeInterval == rhs.endDateTimeTimeInterval)
}

//MARK: Sequence
extension Period : SequenceType {
    class PeriodGenerator : GeneratorType {
        let period: Period
        let calendar: NSCalendar
        
        var indexDay: NSDate?
        var deltaDayComp = NSDateComponents()
        
        init(period aPeriod: Period, calendar aCalendar: NSCalendar) {
            period = aPeriod
            calendar = aCalendar
            indexDay = aPeriod.startDay
            deltaDayComp.day = 1
        }
        
        func next() -> NSDate? {
            if period.endDay != indexDay {
                if (indexDay != nil) {
                    let inspectedDay = calendar.dateByAddingComponents(deltaDayComp, toDate: indexDay!, options: nil)
                    indexDay = inspectedDay!
                    return inspectedDay
                } else {
                    indexDay = period.startDay
                    return indexDay
                }
            } else {
                return nil
            }
        }
    }
    
    func generate() -> PeriodGenerator {
        return PeriodGenerator(period: self, calendar: NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!)
    }
}

//MARK: Hashable
extension Period : Hashable {
    var hashValue: Int {
        get {
            return (self.highestPreciseStartDateTime.hashValue + self.highestPreciseEndDateTime.hashValue)
        }
    }
}

//MARK: Reflectable
extension Period : Reflectable {
    private class PeriodMirror : MirrorType {
        private let _period: Period
        
        lazy var dayFormatter = NSDateFormatter()
        lazy var dateFormatter = NSDateFormatter()
        
        /// The instance being reflected
        var value: Any {
            get {
                return _period
            }
        }
        
        /// Identical to `value.dynamicType`
        var valueType: Any.Type {
            get {
                return _period.dynamicType
            }
        }
        
        /// A unique identifier for `value` if it is a class instance; `nil`
        /// otherwise.
        var objectIdentifier: ObjectIdentifier? {
            get {
                return ObjectIdentifier(_period)
            }
        }
        
        /// The count of `value`\ 's logical children
        var count: Int {
            get {
                return 0
            }
        }
        
        subscript (i: Int) -> (String, MirrorType) {
            get {
                return (_period.description, PeriodMirror(period: _period))
            }
        }
        
        /// A string description of `value`.
        var summary: String {
            get {
                return "Start Day:\(dayFormatter.stringFromDate(_period.startDay))\nStart Date-Time:\(dateFormatter.stringFromDate(_period.startDateTime!))\nEnd Day:\(dayFormatter.stringFromDate(_period.endDay))\nEnd Date-Time:\(dateFormatter.stringFromDate(_period.endDateTime!))"
            }
        }
        
        /// A rich representation of `value` for an IDE, or `nil` if none is supplied.
        var quickLookObject: QuickLookObject? {
            get {
                return QuickLookObject.Text(self.summary)
            }
        }
        
        /// How `value` should be presented in an IDE.
        var disposition: MirrorDisposition {
            get {
                return MirrorDisposition.Class
            }
        }
        
        init(period: Period) {
            _period = period
            
            dayFormatter.dateStyle = .FullStyle
            dayFormatter.timeStyle = .NoStyle
            
            dateFormatter.dateStyle = .FullStyle
            dateFormatter.timeStyle = .FullStyle
        }
    }
    
    func getMirror() -> MirrorType {
        return PeriodMirror(period: self)
    }
}*/
