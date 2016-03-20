//
//  Search.swift
//  Cortex
//
//  Created by Manisha Yeramareddy on 12/8/15.
//  Copyright © 2015 Manisha Yeramareddy. All rights reserved.
//

import Foundation
import CoreData


class Search: NSManagedObject {

    //Constructor - helper to create a new Search Entry
    class func createNewSearchWordInMOC(moc: NSManagedObjectContext, keyword: String, thought: Thought) -> Search {
        let newSearchWord = NSEntityDescription.insertNewObjectForEntityForName(EntityInfo.Search.tableName, inManagedObjectContext: moc) as! Search
        
        newSearchWord.keyword = keyword
        newSearchWord.thoughts?.addObject(thought)
        return newSearchWord
    }

}
