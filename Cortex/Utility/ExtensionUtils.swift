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

extension UIImage {
    
    func correctlyOrientedImage() -> UIImage {
        if self.imageOrientation == UIImageOrientation.Up {
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.drawInRect(CGRectMake(0, 0, self.size.width, self.size.height))
        let normalizedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return normalizedImage;
    }
    
    func imageWithColor(tintColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        let context = UIGraphicsGetCurrentContext()
        CGContextTranslateCTM(context, 0, self.size.height)
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextSetBlendMode(context, CGBlendMode.Normal)
        
        let rect = CGRectMake(0, 0, self.size.width, self.size.height) as CGRect
        CGContextClipToMask(context, rect, self.CGImage)
        tintColor.setFill()
        CGContextFillRect(context, rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext() as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
}





