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
}
