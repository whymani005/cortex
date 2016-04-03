//
//  Attachment.swift
//  Cortex
//
//  Created by Manisha Yeramareddy on 10/14/15.
//  Copyright © 2015 Manisha Yeramareddy. All rights reserved.
//

import Foundation
import CoreData

class Attachment: NSManagedObject {

    //Constructor - helper to create a new Attachment
    class func createNewAttachmentInMOC(moc: NSManagedObjectContext, name: String, thought: Thought, guid: String) -> Attachment {
        let newAttachment = NSEntityDescription.insertNewObjectForEntityForName(EntityInfo.Attachment.tableName, inManagedObjectContext: moc) as! Attachment
        
        newAttachment.name = name
        newAttachment.createdAt = NSDate()
        newAttachment.attachmentThought = thought
        newAttachment.guid = guid
        
        return newAttachment
    }

}
