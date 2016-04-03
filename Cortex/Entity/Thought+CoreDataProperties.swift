//
//  Thought+CoreDataProperties.swift
//  Cortex
//
//  Created by Manisha Yeramareddy on 10/14/15.
//  Copyright © 2015 Manisha Yeramareddy. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Thought {

    @NSManaged var categoryString: String?
    @NSManaged var createdAt: NSDate?
    @NSManaged var guid: String?
    @NSManaged var isThoughtDeleted: NSNumber?
    @NSManaged var lastModified: NSDate?
    @NSManaged var location: String?
    @NSManaged var mood: NSNumber?
    @NSManaged var thoughtContent: String?
    @NSManaged var thoughtCategory: Category?
    @NSManaged var thoughtAttachments: NSSet?
    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var note: String?
    
    //@NSManaged var keywords: NSSet?

}
