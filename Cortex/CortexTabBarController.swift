//
//  CortexTabBarController.swift
//  Cortex
//
//  Created by Manisha Yeramareddy on 9/17/15.
//  Copyright © 2015 Manisha Yeramareddy. All rights reserved.
//

import Foundation
import UIKit

class CortexTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.blackColor()], forState:.Normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.blackColor()], forState:.Selected)
        
        var i = 0
        for item in (self.tabBar.items as [UITabBarItem]?)! {
            if let image = item.image {
                item.image = image.imageWithColor(UIColor(rgba: "#775566")).imageWithRenderingMode(.AlwaysOriginal)
            }
            if let selectedImage = item.selectedImage {
                var finalImage = selectedImage
                if(i == 0) {
                    if let finalImage0 = UIImage(named:"PersonThoughtFilled.png") {
                        finalImage = finalImage0
                    }
                } else if(i == 1) {
                    if let finalImage0 = UIImage(named: "FilingCabinetFilled.png") {
                        finalImage = finalImage0
                    }
                } else if(i == 2) {
                    if let finalImage0 = UIImage(named: "TrendsFilled.png") {
                        finalImage = finalImage0
                    }
                } else if(i == 3) {
                    if let finalImage0 = UIImage(named: "SettingsFilled.png") {
                        finalImage = finalImage0
                    }
                }
                item.selectedImage = finalImage.imageWithColor(UIColor(rgba: "#ee9977")).imageWithRenderingMode(.AlwaysOriginal)
            }
            i++
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// Add anywhere in your app
extension UIImage {
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

