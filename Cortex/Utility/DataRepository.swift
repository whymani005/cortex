//
//  DataRepository.swift
//  Cortex
//
//  Created by Manisha Yeramareddy on 9/19/15.
//  Copyright © 2015 Manisha Yeramareddy. All rights reserved.
//

import UIKit
import CoreData

class DataRepository {
    
    // Retreive the managedObjectContext from AppDelegate
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var dateStringFormatter = NSDateFormatter()
    
    //######################################### MANAGED OBJECT CONTEXT ##############################################
    //Core Data doesn’t persist automatically, you must explicitly call save for that behavior
    func save() {
        if((managedObjectContext?.hasChanges) != nil) {
            do {
                try managedObjectContext!.save()
            } catch let cdSaveError as NSError {
                fatalError("[DataRepository] ERROR SAVING \(cdSaveError.localizedDescription)")
            }
            
            // clear the moc
            self.managedObjectContext!.refreshAllObjects()
        }
    }
    
    //################################################### CORE DATA QUERIES ########################################################
    
    func getAllCategories() -> [Category] {
        //Query Category entity
        let fetchRequest = NSFetchRequest(entityName: EntityInfo.Category.tableName)
        let sortDescriptor = NSSortDescriptor(key: EntityInfo.Category.category, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let fetchResults = (try? managedObjectContext!.executeFetchRequest(fetchRequest)) as? [Category] {
            return fetchResults
        } else {
            return [Category]()
        }
    }
    
    func getAllLocations() -> [NSDictionary] {
        var properties = [AnyObject]()
        properties.append(EntityInfo.Thought.location)
        
        let fetchRequest = NSFetchRequest(entityName: EntityInfo.Thought.tableName)
        fetchRequest.propertiesToFetch = properties
        fetchRequest.resultType = .DictionaryResultType
        fetchRequest.propertiesToGroupBy = [EntityInfo.Thought.location]
        
        var fetchResults : [NSDictionary]
        do {
            fetchResults = try managedObjectContext!.executeFetchRequest(fetchRequest) as! [NSDictionary]
            //print("------location results -- \(fetchResults)")
            if(fetchResults.count > 0) {
                return fetchResults
            } else {
                return [NSDictionary]()
            }
        } catch _ {
            return [NSDictionary]()
        }
    }
    
    func getCDCategoryByGuid(guid: String) -> Category? {
        let fetchRequest = NSFetchRequest(entityName: EntityInfo.Category.tableName)
        let guidCondition = NSPredicate(format: "guid = %@", guid)
        fetchRequest.predicate = guidCondition
        
        if let fetchResults = (try? managedObjectContext!.executeFetchRequest(fetchRequest)) as? [Category] {
            if(fetchResults.count > 0) {
                return fetchResults[0]
            } else {
                return nil
            }
        } else {
            return nil
        }
    }

    func getCDAttachmentByGuid(guid: String) -> Attachment? {
        let fetchRequest = NSFetchRequest(entityName: EntityInfo.Attachment.tableName)
        let guidCondition = NSPredicate(format: "guid = %@", guid)
        fetchRequest.predicate = guidCondition
        
        if let fetchResults = (try? managedObjectContext!.executeFetchRequest(fetchRequest)) as? [Attachment] {
            if(fetchResults.count > 0) {
                return fetchResults[0]
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    func getCDCategoryByCategoryName(category: String) -> Category? {
        let fetchRequest = NSFetchRequest(entityName: EntityInfo.Category.tableName)
        let guidCondition = NSPredicate(format: "category = %@", category)
        
        let andPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [guidCondition])
        fetchRequest.predicate = andPredicate
        
        if let fetchResults = (try? managedObjectContext!.executeFetchRequest(fetchRequest)) as? [Category] {
            if(fetchResults.count > 0) {
                return fetchResults[0]
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    func getCDThoughtByGuid (guid: String) -> Thought? {
        let fetchRequest = NSFetchRequest(entityName: EntityInfo.Thought.tableName)
        let guidCondition = NSPredicate(format: "guid = %@", guid)
        fetchRequest.predicate = guidCondition
        
        if let fetchResults = (try? managedObjectContext!.executeFetchRequest(fetchRequest)) as? [Thought] {
            if(fetchResults.count > 0) {
                return fetchResults[0]
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    func getMAXmodifiedTimeForCDThoughts() -> NSDate {
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.timeZone = NSTimeZone(abbreviation: "UTC");
        
        let fetchRequest = NSFetchRequest(entityName: EntityInfo.Thought.tableName)
        fetchRequest.fetchLimit = 1
        let sortDescriptor = NSSortDescriptor(key: EntityInfo.Thought.lastModified_CD_ONLY, ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let fetchResults = (try? managedObjectContext!.executeFetchRequest(fetchRequest)) as? [Thought] {
            if(fetchResults.isEmpty || fetchResults.count <= 0) {
                return dateStringFormatter.dateFromString("1970-01-01")!
            } else {
                return fetchResults[0].lastModified!
            }
        } else {
            return dateStringFormatter.dateFromString("1970-01-01")!
        }
    }
    
    func getFirstThoughtCreatedAtDate() -> NSDate {
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.timeZone = NSTimeZone(abbreviation: "UTC");
        
        let fetchRequest = NSFetchRequest(entityName: EntityInfo.Thought.tableName)
        fetchRequest.fetchLimit = 1
        let sortDescriptor = NSSortDescriptor(key: EntityInfo.Thought.createdAt, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let fetchResults = (try? managedObjectContext!.executeFetchRequest(fetchRequest)) as? [Thought] {
            if(fetchResults.isEmpty || fetchResults.count <= 0) {
                return NSDate()
            } else {
                return fetchResults[0].createdAt!
            }
        } else {
            return NSDate()
        }
    }
    
    
    func getMAXmodifiedTimeForCDCategories() -> NSDate {
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.timeZone = NSTimeZone(abbreviation: "UTC");
        
        let fetchRequest = NSFetchRequest(entityName: EntityInfo.Category.tableName)
        fetchRequest.fetchLimit = 1
        let sortDescriptor = NSSortDescriptor(key: EntityInfo.Category.lastModified_CD_ONLY, ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let fetchResults = (try? managedObjectContext!.executeFetchRequest(fetchRequest)) as? [Category] {
            if(fetchResults.isEmpty || fetchResults.count <= 0) {
                return dateStringFormatter.dateFromString("1970-01-01")!
            } else {
                return fetchResults[0].lastModified!
            }
        } else {
            return dateStringFormatter.dateFromString("1970-01-01")!
        }
    }
    
    func getAllCDThoughtsForDate(date: NSDate) -> [Thought] {
        //Query Category entity
        let fetchRequest = NSFetchRequest(entityName: EntityInfo.Thought.tableName)
        
        // Create a sort descriptor object that sorts on the "title"
        // property of the Core Data object
        let sortDescriptor = NSSortDescriptor(key: EntityInfo.Thought.createdAt, ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let newDate = NSCalendar.currentCalendar().startOfDayForDate(date)
        let newDatePlusOneDay = NSCalendar.currentCalendar().startOfDayForDate(date.dateByAddingTimeInterval(60*60*24*1))
        
        let startDateTime = NSPredicate(format: "createdAt >= %@", newDate)
        let endDateTime = NSPredicate(format: "createdAt < %@", newDatePlusOneDay)
        let delCondition = NSPredicate(format: "isThoughtDeleted == 0")
        
        // Combine the predicates above in to one compound predicate
        let andPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [delCondition, startDateTime, endDateTime])
        
        // Set the predicate on the fetch request
        fetchRequest.predicate = andPredicate
        
        if let fetchResults = (try? managedObjectContext!.executeFetchRequest(fetchRequest)) as? [Thought] {
            return fetchResults
        } else {
            return [Thought]()
        }
    }
    
    func getAllCDThoughtsForAttributeValue(value: String, attribute: String) -> [Thought] {
        //Query Category entity
        let fetchRequest = NSFetchRequest(entityName: EntityInfo.Thought.tableName)
        
        let sortDescriptor = NSSortDescriptor(key: EntityInfo.Thought.createdAt, ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]

        let attributePredicate = NSPredicate(format: attribute+" == %@", value)
        let delCondition = NSPredicate(format: "isThoughtDeleted == 0")
        let andPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [delCondition, attributePredicate])
        
        // Set the predicate on the fetch request
        fetchRequest.predicate = andPredicate
        
        if let fetchResults = (try? managedObjectContext!.executeFetchRequest(fetchRequest)) as? [Thought] {
            return fetchResults
        } else {
            return [Thought]()
        }
    }
    
    func getAllCDThoughtsForMoodValue(value: Int) -> [Thought] {
        //Query Category entity
        let fetchRequest = NSFetchRequest(entityName: EntityInfo.Thought.tableName)
        
        let sortDescriptor = NSSortDescriptor(key: EntityInfo.Thought.createdAt, ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let attributePredicate = NSPredicate(format: EntityInfo.Thought.mood+" = %d", value)
        let delCondition = NSPredicate(format: "isThoughtDeleted == 0")
        let andPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [delCondition, attributePredicate])
        
        // Set the predicate on the fetch request
        fetchRequest.predicate = andPredicate
        
        if let fetchResults = (try? managedObjectContext!.executeFetchRequest(fetchRequest)) as? [Thought] {
            return fetchResults
        } else {
            return [Thought]()
        }
    }
    
    func getAllCDThoughtsForDateRange(startDate: NSDate, endDate: NSDate) -> [Thought] {
        //Query Category entity
        let fetchRequest = NSFetchRequest(entityName: EntityInfo.Thought.tableName)
        let sortDescriptor = NSSortDescriptor(key: EntityInfo.Thought.createdAt, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let newStartDate = NSCalendar.currentCalendar().startOfDayForDate(startDate)
        let newEndDate = NSCalendar.currentCalendar().startOfDayForDate(endDate)
        let newEndDatePlusOneDay = NSCalendar.currentCalendar().startOfDayForDate(newEndDate.dateByAddingTimeInterval(60*60*24*1))
        
        let startDateTime = NSPredicate(format: "createdAt >= %@", newStartDate)
        let endDateTime = NSPredicate(format: "createdAt < %@", newEndDatePlusOneDay)
        let delCondition = NSPredicate(format: "isThoughtDeleted == 0")
        // Combine the two predicates above in to one compound predicate
        let andPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [startDateTime, endDateTime, delCondition])
        fetchRequest.predicate = andPredicate
        
        if let fetchResults = (try? managedObjectContext!.executeFetchRequest(fetchRequest)) as? [Thought] {
            return fetchResults
        } else {
            return [Thought]()
        }
    }
    
    func getAvgMoodForCDThoughtsOnDate(date: NSDate) -> Double {
        
        let moodExp = NSExpression(forKeyPath: EntityInfo.Thought.mood)
        let moodExpression = NSExpression(forFunction: "average:", arguments: [moodExp])
        
        let expressionDescription = NSExpressionDescription()
        expressionDescription.name = "result"
        expressionDescription.expression = moodExpression
        expressionDescription.expressionResultType = NSAttributeType.DoubleAttributeType
        
        var properties = [NSExpressionDescription]()
        properties.append(expressionDescription)
        
        let fetchRequest = NSFetchRequest(entityName: EntityInfo.Thought.tableName)
        fetchRequest.propertiesToFetch = properties
        fetchRequest.resultType = .DictionaryResultType
        
        let newDate = NSCalendar.currentCalendar().startOfDayForDate(date)
        let newDatePlusOneDay = NSCalendar.currentCalendar().startOfDayForDate(date.dateByAddingTimeInterval(60*60*24*1))
        
        let startDateTime = NSPredicate(format: "createdAt >= %@", newDate)
        let endDateTime = NSPredicate(format: "createdAt < %@", newDatePlusOneDay)
        let andPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [startDateTime, endDateTime])
        fetchRequest.predicate = andPredicate
        
        var results : NSArray
        do {
            results = try managedObjectContext!.executeFetchRequest(fetchRequest)
            let firstResult : NSDictionary = results.objectAtIndex(0) as! NSDictionary
            let test = firstResult["result"]
            if(test != nil) {
                let moodAvg : Double = firstResult["result"]! as! Double
                return moodAvg
            } else {
                return Double(99.0)
            }
        } catch _ {
            return Double(99.0)
        }
    }
    
    func getCategoryCountForDateRange(startDate: NSDate, endDate: NSDate) -> [NSDictionary] {
        
        let thoughtCatExp = NSExpression(forKeyPath: EntityInfo.Thought.categoryString)
        let thoughtCatExpression = NSExpression(forFunction: "count:", arguments: [thoughtCatExp])
        
        let expressionDescription = NSExpressionDescription()
        expressionDescription.name = "categoryCount"
        expressionDescription.expression = thoughtCatExpression
        expressionDescription.expressionResultType = .Integer32AttributeType
        
        var properties = [AnyObject]()
        properties.append(EntityInfo.Thought.categoryString)
        properties.append(expressionDescription)
        
        let fetchRequest = NSFetchRequest(entityName: EntityInfo.Thought.tableName)
        fetchRequest.propertiesToFetch = properties
        fetchRequest.resultType = .DictionaryResultType
        fetchRequest.propertiesToGroupBy = [EntityInfo.Thought.categoryString]
        
        let newStartDate = NSCalendar.currentCalendar().startOfDayForDate(startDate)
        let newEndDate = NSCalendar.currentCalendar().startOfDayForDate(endDate)
        let newEndDatePlusOneDay = NSCalendar.currentCalendar().startOfDayForDate(newEndDate.dateByAddingTimeInterval(60*60*24*1))
        
        let startDateTime = NSPredicate(format: "createdAt >= %@", newStartDate)
        let endDateTime = NSPredicate(format: "createdAt < %@", newEndDatePlusOneDay)
        let andPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [startDateTime, endDateTime])
        fetchRequest.predicate = andPredicate
        
        var fetchResults : [NSDictionary]
        do {
            //select count(ZTHOUGHTCATEGORY), ZTHOUGHTCATEGORY from zthought GROUP by ZTHOUGHTCATEGORY
            fetchResults = try managedObjectContext!.executeFetchRequest(fetchRequest) as! [NSDictionary]
            //print("------fetch results -- \(fetchResults)")
            if(fetchResults.count > 0) {
                return fetchResults
            } else {
                return [NSDictionary]()
            }
        } catch _ {
            return [NSDictionary]()
        }
    }
    
    func getThoughtCountForDateRange(startDate: NSDate, endDate: NSDate) -> Int {
        let thoughts = getAllCDThoughtsForDateRange(startDate, endDate: endDate)
        if(thoughts.isEmpty ) {
            return 0
        } else {
            return thoughts.count
        }
    }
    
    func deleteAllCDForCurrentUser() {
        
    }
    
    
    /*func getSearchEntityByKeyword(keyword: String) -> Search? {
        let fetchRequest = NSFetchRequest(entityName: EntityInfo.Search.tableName)
        let kwCondition = NSPredicate(format: "keyword = %@", EntityInfo.Search.keyword)
        fetchRequest.predicate = kwCondition
        
        if let fetchResults = (try? managedObjectContext!.executeFetchRequest(fetchRequest)) as? [Search] {
            if(fetchResults.count > 0) {
                return fetchResults[0]
            } else {
                return nil
            }
        } else {
            return nil
        }
    }*/
    
    /*func saveKeywords(tokens: NSMutableSet) {
        // Create and perform a request for existing keyword records for these tokens
        var request: NSFetchRequest = NSFetchRequest(entityName: "Keyword")
        request.predicate = NSPredicate(format: "keyword IN %@", tokens)
        var keywords = NSSet()
        
        do {
            keywords = try NSSet(array: (managedObjectContext?.executeFetchRequest(request))!)
        } catch _ {
            
        }
        
        // Find nonexistent keywords (by removing existing keywords from tokens) ...
        tokens.minusSet(keywords as! Set<NSObject>)
        // ... then create them
        for k : AnyObject in tokens {
            var newManagedObject: NSManagedObject = NSEntityDescription.insertNewObjectForEntityForName("Keyword", inManagedObjectContext: managedObjectContext!)
            newManagedObject["keyword"] = k
            keywords.addObject(newManagedObject)
        }
        
        // Make changes
        var keywordsToAdd: NSMutableSet = keywords.mutableCopy()
        var keywordsToRemove: NSMutableSet = self.words.mutableCopy()
        keywordsToAdd.minusSet(self.words)
        keywordsToRemove.minusSet(keywords)
        if keywordsToAdd.count {
            self.addWords(keywordsToAdd)
        }
        if keywordsToRemove.count {
            self.removeWords(keywordsToRemove)
        }
    }*/
    
    func getCDThoughtsByKeywords(searchString : String) -> [Thought]{
        let fetchRequest = NSFetchRequest(entityName: EntityInfo.Thought.tableName)
        
        // Strip out all the leading and trailing spaces.
        let whitespaceCharacterSet = NSCharacterSet.whitespaceCharacterSet()
        let strippedString = searchString.lowercaseString.stringByTrimmingCharactersInSet(whitespaceCharacterSet)
        let searchItems = strippedString.componentsSeparatedByString(" ") as [String]
        
        // Build all the "AND" expressions for each value in the searchString.
        let andMatchPredicates: [NSPredicate] = searchItems.map { searchString in
            // Each searchString creates an OR predicate for: name, yearIntroduced, introPrice.
            //
            // Example if searchItems contains "iphone 599 2007":
            //      name CONTAINS[c] "iphone"
            //      name CONTAINS[c] "599", yearIntroduced ==[c] 599, introPrice ==[c] 599
            //      name CONTAINS[c] "2007", yearIntroduced ==[c] 2007, introPrice ==[c] 2007
            //
            var searchItemsPredicate = [NSPredicate]()
            
            // Below we use NSExpression represent expressions in our predicates.
            // NSPredicate is made up of smaller, atomic parts: two NSExpressions (a left-hand value and a right-hand value).
            
            // Name field matching.
            let titleExpression = NSExpression(forKeyPath: EntityInfo.Thought.thoughtContent)
            let searchStringExpression = NSExpression(forConstantValue: searchString)
            
            let titleSearchComparisonPredicate = NSComparisonPredicate(leftExpression: titleExpression, rightExpression: searchStringExpression, modifier: .DirectPredicateModifier, type: .ContainsPredicateOperatorType, options: .CaseInsensitivePredicateOption)
            
            searchItemsPredicate.append(titleSearchComparisonPredicate)

            // Add this OR predicate to our master AND predicate.
            let orMatchPredicate = NSCompoundPredicate(orPredicateWithSubpredicates : searchItemsPredicate)
            
            return orMatchPredicate
        }
        
        // Match up the fields of the Product object.
        let finalCompoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: andMatchPredicates)
        
        //let usernameCondition = NSPredicate(format: "thoughtUser == %@", UserUtils.getCurrentUsername())
        let deleteCondition = NSPredicate(format: "isThoughtDeleted == 0")

        let FINALPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [finalCompoundPredicate, deleteCondition])
        
        fetchRequest.predicate = FINALPredicate
        
        if let fetchResults = (try? managedObjectContext!.executeFetchRequest(fetchRequest)) as? [Thought] {
            if(fetchResults.count > 0) {
                return fetchResults
            } else {
                return [Thought]()
            }
        } else {
            return [Thought]()
        }
    }
    
    //################################################### PARSE QUERIES ########################################################
    
    
    //######################################################## END ########################################################
    
}