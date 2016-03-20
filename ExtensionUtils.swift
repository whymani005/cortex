//
//  ExtensionUtils.swift
//  Cortex
//
//  Created by Manisha Yeramareddy on 1/2/16.
//  Copyright © 2016 Manisha Yeramareddy. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func fadeIn(duration: NSTimeInterval, delay: NSTimeInterval = 0.0, completion: ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animateWithDuration(duration, delay: delay, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.alpha = 1.0
            }, completion: completion)  }
    
    func fadeOut(duration: NSTimeInterval, delay: NSTimeInterval = 0.0, completion: (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animateWithDuration(duration, delay: delay, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.alpha = 0.0
            }, completion: completion)
    }
}


extension NSUserDefaults {
    func objectForKey(defaultName: String, defaultValue: AnyObject) -> AnyObject {
        var obj = objectForKey(defaultName)
        
        if obj == nil {
            obj = defaultValue
            setObject(obj, forKey: defaultName)
        }
        return obj!
    }
}