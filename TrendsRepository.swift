//
//  TrendsRepository.swift
//  Cortex
//
//  Created by Manisha Yeramareddy on 10/9/15.
//  Copyright © 2015 Manisha Yeramareddy. All rights reserved.
//

import UIKit
import CoreData

class TrendsRepository {
    
    // Retreive the managedObjectContext from AppDelegate
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    let dataRepo = DataRepository()
    
    var dateStringFormatter = NSDateFormatter()
    
    func getDateStringArrayForLastNDaysFromGivenDate(inputDate: NSDate, numOfDays: Int) -> [String] {
        var dateStringArray : [String] = []
        dateStringFormatter.dateFormat = "d MMM" ///include year??
        
        for day in 0...numOfDays {
            let dateToGet = DateUtils.plusDays(inputDate, daysToAdd: -day)
            let dtStr = dateStringFormatter.stringFromDate(dateToGet)
            dateStringArray.append(dtStr)
        }
        dateStringArray = dateStringArray.reverse()
        return dateStringArray
    }
    
    func getMoodAvgArrayForLastNDaysFromGivenDate(inputDate: NSDate, numOfDays: Int) -> [Double] {
        var moodArray : [Double] = []
        
        for day in 0...numOfDays {
            let dateToGet = DateUtils.plusDays(inputDate, daysToAdd: -day)
            let dayAvgMood = dataRepo.getAvgMoodForCDThoughtsOnDate(dateToGet)
            moodArray.append(dayAvgMood)
        }
        moodArray = moodArray.reverse()
        return moodArray
    }
    
    func getCategoryCountForDateRange(start: NSDate, end: NSDate) -> [NSDictionary] {
        let dict = dataRepo.getCategoryCountForDateRange(start, endDate: end)
        
        let sortedResults = dict.sort {
            (dictOne, dictTwo) -> Bool in
            //comparison logic here
            return dictOne["categoryCount"]! as! Int > dictTwo["categoryCount"]! as! Int
        }
        //print("*********** \(sortedResults)")
        
        return sortedResults
    }

    
}





