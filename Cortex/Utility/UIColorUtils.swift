//
//  UIColorUtils.swift
//  Cortex
//
//  Created by Manisha Yeramareddy on 9/17/15.
//  Copyright © 2015 Manisha Yeramareddy. All rights reserved.
//

import UIKit

extension UIColor
{
    convenience init(rgba: String)
    {
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0
        
        if rgba.hasPrefix("#")
        {
            let index   = rgba.startIndex.advancedBy(1)
            let hex     = rgba.substringFromIndex(index)
            let scanner = NSScanner(string: hex)
            var hexValue: CUnsignedLongLong = 0
            
            if scanner.scanHexLongLong(&hexValue)
            {
                if hex.characters.count == 6
                {
                    red   = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
                    green = CGFloat((hexValue & 0x00FF00) >> 8)  / 255.0
                    blue  = CGFloat(hexValue & 0x0000FF) / 255.0
                }
                else if hex.characters.count == 8
                {
                    red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                    green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                    blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                    alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
                }
                else
                {
                    print("invalid rgb string, length should be 7 or 9", terminator: "")
                }
            }
            else
            {
                print("scan hex error")
            }
        }
        else
        {
            print("invalid rgb string, missing '#' as prefix", terminator: "")
        }
        
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    class func lighten(color: UIColor, percentage: CGFloat = 1.5) -> UIColor
    {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        color.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        
        return UIColor(hue: h, saturation: s, brightness: (b * percentage), alpha: a)
    }
}


func getUIColorForMoodValue(mood: Int) -> UIColor {
    if(mood == 0) {
        return UIColor(rgba: "#BF4227")
    } else if(mood == 1) {
        return UIColor(rgba: "#FF6832")
    } else if(mood == 2) {
        return UIColor(rgba: "#FF8F1F")
    } else if(mood == 3) {
        return UIColor(rgba: "#FFD213")
    } else if(mood == 4) {
        return UIColor(rgba: "#FFF311")
    } else if(mood == 5) {
        return UIColor(rgba: "#F6FF16")
    } else if(mood == 6) {
        return UIColor(rgba: "#D9FF2C")
    } else if(mood == 7) {
        return UIColor(rgba: "#9EFF2F")
    } else if(mood == 8) {
        return UIColor(rgba: "#1FFF21")
    } else if(mood == 9) {
        return UIColor(rgba: "#17BF19")
    } else if(mood == 10) {
        return UIColor(rgba: "#007F1A")
    } else {
        return UIColor.grayColor()
    }
}

