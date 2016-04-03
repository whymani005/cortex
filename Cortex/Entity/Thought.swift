//
//  Thought.swift
//  Cortex
//
//  Created by Manisha Yeramareddy on 9/19/15.
//  Copyright © 2015 Manisha Yeramareddy. All rights reserved.
//

import Foundation
import CoreData

class Thought: NSManagedObject {

    // Insert code here to add functionality to your managed object subclass
    
    //Constructor - helper to create a new Thought
    class func createNewThoughtInMOC(moc: NSManagedObjectContext, category: Category?, categoryString: String?, mood: Int, location: String, thoughtText: String, guid: String, createdAt : NSDate) -> Thought {
        let newEntry = NSEntityDescription.insertNewObjectForEntityForName(EntityInfo.Thought.tableName, inManagedObjectContext: moc) as! Thought
        
        newEntry.thoughtContent = thoughtText
        newEntry.thoughtCategory = category
        newEntry.categoryString = categoryString
        newEntry.mood = mood
        newEntry.location = location
        newEntry.guid = guid
        newEntry.isThoughtDeleted = 0
        newEntry.createdAt = createdAt
        newEntry.lastModified = newEntry.createdAt
        
        return newEntry
    }

}
