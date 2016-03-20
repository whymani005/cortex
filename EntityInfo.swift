//
//  EntityInfo.swift
//  Cortex
//
//  Created by Manisha Yeramareddy on 9/19/15.
//  Copyright © 2015 Manisha Yeramareddy. All rights reserved.
//

import Foundation

struct EntityInfo {
    
    struct Category {
        static let tableName = "Category"
        
        static let category = "category"
        static let guid = "guid"
        static let createdAt = "createdAt"
        static let isCategoryDeleted = "isCategoryDeleted"
        
        static let lastModified_CD_ONLY = "lastModified"
    }
    
    struct Thought {
        static let tableName = "Thought"
        
        static let categoryString = "categoryString"
        static let thoughtContent = "thoughtContent"
        static let guid = "guid"
        static let mood = "mood"
        static let location = "location"
        static let createdAt = "createdAt"
        static let isThoughtDeleted = "isThoughtDeleted"
        
        static let lastModified_CD_ONLY = "lastModified"
    }
    
    struct Attachment {
        static let tableName = "Attachment"
        
        static let picture = "picture"
        static let guid = "guid"
        static let createdAt = "createdAt"
        static let attachmentThought = "attachmentThought"
    }
    
    
}