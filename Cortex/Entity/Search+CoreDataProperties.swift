//
//  Search+CoreDataProperties.swift
//  Cortex
//
//  Created by Manisha Yeramareddy on 12/8/15.
//  Copyright © 2015 Manisha Yeramareddy. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Search {

    @NSManaged var keyword: String?
    @NSManaged var thoughts: NSMutableSet?

}
