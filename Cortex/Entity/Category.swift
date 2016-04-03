//
//  Category.swift
//  Cortex
//
//  Created by Manisha Yeramareddy on 9/19/15.
//  Copyright © 2015 Manisha Yeramareddy. All rights reserved.
//

import Foundation
import CoreData

class Category: NSManagedObject {

    // Insert code here to add functionality to your managed object subclass
    
    //Constructor - helper to create a new Entry
    class func createNewCategoryInMOC(moc: NSManagedObjectContext, text: String, guid: String) -> Category {
        let newCategory = NSEntityDescription.insertNewObjectForEntityForName(EntityInfo.Category.tableName, inManagedObjectContext: moc) as! Category
        
        newCategory.category = text
        newCategory.guid = guid
        newCategory.isCategoryDeleted = 0
        newCategory.createdAt = NSDate()
        newCategory.lastModified = newCategory.createdAt
        
        return newCategory
    }

}
