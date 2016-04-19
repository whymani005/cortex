//
//  DateUtils.swift
//  Cortex
//
//  Created by Manisha Yeramareddy on 10/9/15.
//  Copyright © 2015 Manisha Yeramareddy. All rights reserved.
//

import UIKit
import CoreData

class DateUtils {
    
    class func plusDays(date: NSDate, daysToAdd: Int) -> NSDate {
        let newDate = date.dateByAddingTimeInterval( 60*60*24*Double(daysToAdd) )
        return newDate
    }
    
    class func daysBetweenDates(startDate: NSDate, endDate: NSDate) -> Int {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day], fromDate: startDate, toDate: endDate, options: [])
        return components.day
    }
    
    class func dateByAddingDays(inputDate: NSDate, days: Int) -> NSDate {
        let resultDate = NSCalendar.currentCalendar().dateByAddingUnit(
            .Day,
            value: days,
            toDate: inputDate,
            options: NSCalendarOptions(rawValue: 0))
        return resultDate!
    }
    
}
