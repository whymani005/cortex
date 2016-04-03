//
//  HelperUtils.swift
//  Cortex
//
//  Created by Manisha Yeramareddy on 10/7/15.
//  Copyright © 2015 Manisha Yeramareddy. All rights reserved.
//

import Foundation
import UIKit

class HelperUtils {
    
    class func setMoodButtonImage(mood : Int) -> UIImage {
        switch mood {
        case 1:
            return UIImage(named: "crying")!
        case 2:
            return UIImage(named: "sad")!
        case 3:
            return UIImage(named: "confused")!
        case 4:
            return UIImage(named: "neutral")!
        case 5:
            return UIImage(named: "happy")!
        case 6:
            return UIImage(named: "lol")!
        default :
            return UIImage(named: "neutral")!
        }
    }
    
    func getUIColorForMoodValue(mood: Int) -> UIColor {
        if(mood == 1) {
            return UIColor(rgba: "#c0392b")
        } else if(mood == 2) {
            return UIColor(rgba: "#e74c3c")
        } else if(mood == 3) {
            return UIColor(rgba: "#f39c12")
        } else if(mood == 4) {
            return UIColor(rgba: "#eed541")
        } else if(mood == 5) {
            return UIColor(rgba: "#2ecc71")
        } else if(mood == 6) {
            return UIColor(rgba: "#27ae60")
        } else {
            return UIColor.grayColor()
        }
    }
    
    class func getDocumentsURL() -> NSURL {
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        return documentsURL
    }
    
    class func getMainDocumentsDirectory() -> String {
        let fileURL = getDocumentsURL()
        return fileURL.path!
    }
    
    class func fileInDocumentsDirectory(filename: String) -> String {
        let fileURL = getDocumentsURL().URLByAppendingPathComponent(filename)
        return fileURL.path!
    }
    
    class func deleteFileAtPath(itemName: String) {
        let fileManager = NSFileManager.defaultManager()
        let filePath = fileInDocumentsDirectory(itemName)
        do {
            try fileManager.removeItemAtPath(filePath)
            print("successfully deleteFileAtPath : \(filePath)")
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
}


