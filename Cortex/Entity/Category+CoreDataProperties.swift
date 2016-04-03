//
//  Category+CoreDataProperties.swift
//  Cortex
//
//  Created by Manisha Yeramareddy on 9/19/15.
//  Copyright © 2015 Manisha Yeramareddy. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Category {

    @NSManaged var category: String?
    @NSManaged var guid: String?
    @NSManaged var createdAt: NSDate?
    @NSManaged var isCategoryDeleted: NSNumber?
    @NSManaged var lastModified: NSDate?
    @NSManaged var thoughts: NSSet?

}
