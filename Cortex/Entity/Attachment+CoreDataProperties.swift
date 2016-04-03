//
//  Attachment+CoreDataProperties.swift
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

extension Attachment {

    @NSManaged var createdAt: NSDate?
    @NSManaged var guid: String?
    @NSManaged var attachmentThought: Thought?
    @NSManaged var name : String?

}
