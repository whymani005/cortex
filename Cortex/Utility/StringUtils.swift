//
//  StringUtils.swift
//  Cortex
//
//  Created by Manisha Yeramareddy on 9/17/15.
//  Copyright © 2015 Manisha Yeramareddy. All rights reserved.
//

import Foundation
import UIKit

class StringUtils {
    
    //init() {}
    
    class func isBlank (optionalString :String?) -> Bool {
        if let string = optionalString {
            let cleanedString = string.stringByReplacingOccurrencesOfString(" ", withString: "")
            return cleanedString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).isEmpty
        } else {
            return true
        }
    }
    
    class func equals (optionalOne :String?, optionalTwo :String?) -> Bool {
        if let stringOne = optionalOne {
            if let stringTwo = optionalTwo {
                return stringOne == stringTwo
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    class func isEmailAddressValid (emailString :String?) -> Bool {
        if let main = emailString {
            if(main.containsString("@") && main.containsString(".")) {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    class func contains(findString: String?, inString: String?) -> Bool {
        if let sub = findString {
            if let main = inString {
                return main.rangeOfString(sub) != nil
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    class func stopWords() -> NSSet {
        //var path: String = NSBundle.mainBundle().bundlePath.stringByAppendingPathComponent("stopwords.plist")
        //return NSSet(array: [AnyObject].arrayWithContentsOfFile(path))
        
        let a: [AnyObject] = ["", " ", "a", "the", "by", "in", "and"]
        return NSSet(array: a)
    }
    
    class func splitCharsSet() -> NSCharacterSet {
        let cs: NSCharacterSet = NSCharacterSet(charactersInString: "abcdefghijklmnopqrstuvwxyz0123456789'")
        return cs.invertedSet
    }
    
    class func tokenize(string: String) -> NSMutableSet {
        // Remove diacritics and convert to lower case
        var tString = string.lowercaseString
        tString = tString.stringByFoldingWithOptions(NSStringCompareOptions.DiacriticInsensitiveSearch, locale: NSLocale.systemLocale())

        // Split on [^a-z0-9']
        let a: [AnyObject] = tString.componentsSeparatedByCharactersInSet(splitCharsSet())

        // Convert to a set, remove stopwords (including the empty string), and return
        let s: NSMutableSet = NSMutableSet(array: a)
        s.minusSet(stopWords() as Set<NSObject>)
        return s
    }
    
}







